/*
 * This file is part of MULTEM.
 * Copyright 2020 Ivan Lobato <Ivanlh20@gmail.com>
 *
 * MULTEM is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * MULTEM is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with MULTEM. If not, see <http:// www.gnu.org/licenses/>.
 */

#ifndef TRANSMISSION_FUNCTION_H
#define TRANSMISSION_FUNCTION_H

#include "math.cuh"
#include "types.cuh"
#include "traits.cuh"
#include "stream.cuh"
#include "quadrature.hpp"
#include "memory_info.cuh"
#include "input_multislice.cuh"
#include "output_multislice.hpp"
#include "projected_potential.cuh"

namespace mt
{

	template <class T, eDevice dev>
  class PotentialFunction {
  public:

    virtual void operator()(double z_0, double z_E, mt::Vector<T, dev> &) = 0;
  };

	template <class T, eDevice dev>
	class Transmission_Function: public Projected_Potential<T, dev>
	{
		public:
			using T_r = T;
			using T_c = complex<T>;
			using size_type = std::size_t;

			Transmission_Function(): Projected_Potential<T, dev>(), fft_2d(nullptr), potential_function(nullptr) {}

      void set_potential_function(PotentialFunction<T, dev> *function) {
        potential_function = function;
      }

			void set_input_data(Input_Multislice<T_r> *input_multislice_i, Stream<dev> *stream_i, FFT<T_r, dev> *fft2_i)
			{
				Projected_Potential<T, dev>::set_input_data(input_multislice_i, stream_i);
				fft_2d = fft2_i;

				trans_0.resize(this->input_multislice->grid_2d.nxy());
        
        if (this->input_multislice->static_B_factor > 0) {
          static_B_factor_filter.resize(this->input_multislice->grid_2d.nxy());
          T_r B = this->input_multislice->static_B_factor;
          auto grid_2d = this->input_multislice->grid_2d;
          thrust::counting_iterator<size_t> indices(0);
          thrust::transform(
              indices,
              indices + static_B_factor_filter.size(),
              static_B_factor_filter.begin(),
              [B, grid_2d] DEVICE_CALLABLE (size_t index) {
                int ix = index / grid_2d.ny;
                int iy = index - ix * grid_2d.ny;
                T_r g2 = grid_2d.g2_shift(ix, iy);
                return exp(-B * g2 / 4.0);
              });
        }

				if(!this->input_multislice->slice_storage)
				{
					memory_slice.clear();
					return;
				}

				int n_slice_sig = (this->input_multislice->pn_dim.z)?(int)ceil(3.0*this->atoms.sigma_max/this->input_multislice->grid_2d.dz):0;
				int n_slice_req = this->slicing.slice.size() + 2*n_slice_sig;

				memory_slice.set_input_data(n_slice_req, this->input_multislice->grid_2d.nxy());

				if(memory_slice.is_potential())
				{
					memory_slice.resize_vector(this->input_multislice->grid_2d.nxy(), Vp_v);
				}
				else if(memory_slice.is_transmission())
				{
					memory_slice.resize_vector(this->input_multislice->grid_2d.nxy(), trans_v);
				}

			}

			void trans(T_r w, Vector<T_r, dev> &V0_i, Vector<T_c, dev> &Trans_o)
			{	
				mt::transmission_function(*(this->stream), this->input_multislice->grid_2d, this->input_multislice->interaction_model, w, V0_i, Trans_o);

				if(this->input_multislice->grid_2d.bwl)
				{
					fft_2d->forward(Trans_o);
					mt::bandwidth_limit(*(this->stream), this->input_multislice->grid_2d, Trans_o);
					fft_2d->inverse(Trans_o);
				}
			}

			void trans(const int &islice, Vector<T_c, dev> &trans_0)
			{
				if(islice < memory_slice.n_slice_cur(this->slicing.slice.size()))
				{
					if(memory_slice.is_potential())
					{
						trans(this->input_multislice->Vr_factor(), Vp_v[islice], trans_0);
					}
					else if(memory_slice.is_transmission())
					{
						mt::assign(trans_v[islice], trans_0);
					}
				}
				else
				{
					Projected_Potential<T, dev>::operator()(islice, this->V_0);
          
          // If we have an external function to compute potential
          if (potential_function) {
            double z_0 = this->slicing.slice[islice].z_0;
            double z_e = this->slicing.slice[islice].z_e;
            potential_function->operator()(z_0, z_e, this->V_0);  
          }

          // If static B factor is set then do the B factor blurring
          if (this->input_multislice->static_B_factor > 0) {
            apply_static_B_factor(this->V_0); 
          }

					//this->operator()(islice, this->V_0);
					trans(this->input_multislice->Vr_factor(), this->V_0, trans_0);
				}
			}

			void trans(const int &islice_0, const int &islice_e, Vector<T_c, dev> &trans_0)
			{
				Projected_Potential<T, dev>::operator()(islice_0, islice_e, this->V_0);
				//this->operator()(islice_0, islice_e, this->V_0);
				trans(this->input_multislice->Vr_factor(), this->V_0, trans_0);
			}

			template <class TOutput_multislice>
			void trans(const int &islice, TOutput_multislice &output_multislice)
			{
				trans(islice, trans_0);
				mt::copy_to_host(output_multislice.stream, trans_0, output_multislice.trans[0]);
			}

      void apply_static_B_factor(Vector<T_r, dev> &V0) {

        // Check the size of the arrays
        if (V0.size() != static_B_factor_filter.size()) {
          throw std::runtime_error("Inconsistent array sizes");
        }

        // Initialise a temporary complex array
        Vector<T_c, dev> temp(V0.begin(), V0.end());
       
        // Get the normalization constant
        T_r size = V0.size();
      
        // Convolve with the B factor filter
        fft_2d->forward(temp);
        thrust::transform(
            temp.begin(),
            temp.end(),
            static_B_factor_filter.begin(),
            temp.begin(),
            [] DEVICE_CALLABLE (T_c x, T_r y) {
              return x * y;
            });
        fft_2d->inverse(temp);

        // Copy the real component and normalize
        thrust::transform(
            temp.begin(), 
            temp.end(), 
            V0.begin(), 
            [size] DEVICE_CALLABLE (T_c x) {
              return x.real() / size;
            });
      }

			void move_atoms(const int &fp_iconf)
			{
				Projected_Potential<T, dev>::move_atoms(fp_iconf);

				// Calculate transmission functions
				for(auto islice = 0; islice< memory_slice.n_slice_cur(this->slicing.slice.size()); islice++)
				{
					if(memory_slice.is_potential())
					{
						Projected_Potential<T, dev>::operator()(islice, Vp_v[islice]);
            
            if (potential_function) {
              double z_0 = this->slicing.slice[islice].z_0;
              double z_e = this->slicing.slice[islice].z_e;
              potential_function->operator()(z_0, z_e, Vp_v[islice]);  
            }
					}
					else if(memory_slice.is_transmission())
					{
						Projected_Potential<T, dev>::operator()(islice, this->V_0);

            if (potential_function) {
              double z_0 = this->slicing.slice[islice].z_0;
              double z_e = this->slicing.slice[islice].z_e;
              potential_function->operator()(z_0, z_e, this->V_0);  
            }

						trans(this->input_multislice->Vr_factor(), this->V_0, trans_v[islice]);
					}
				}
			}

			void transmit(const int &islice, Vector<T_c, dev> &psi_io)
			{
				trans(islice, trans_0);
				mt::multiply(*(this->stream), trans_0, psi_io);
			}

			Vector<T_c, dev> trans_0;
		private:
			struct Memory_Slice
			{
				public:
					int n_slice_req;
					int n_slice_Allow;
					eSlice_Memory_Type slice_mem_type;

					Memory_Slice(): n_slice_req(0), n_slice_Allow(0), slice_mem_type(eSMT_none){}

					void clear()
					{
						n_slice_req = n_slice_Allow = 0;
						slice_mem_type = eSMT_none;
					}

					void set_input_data(const int &nSlice_req_i, const int &nxy_i)
					{
						n_slice_req = nSlice_req_i;
						double free_memory = get_free_memory<dev>() - 10;

						if(number_slices<T_c>(free_memory, nxy_i) >= n_slice_req)
						{
							slice_mem_type = eSMT_Transmission;
							n_slice_Allow = number_slices<T_c>(free_memory, nxy_i);
						}
						else
						{
							slice_mem_type = eSMT_Potential;
							n_slice_Allow = number_slices<T_r>(free_memory, nxy_i);
						}
						n_slice_Allow = min(n_slice_Allow, n_slice_req);

						if(n_slice_Allow == 0 )
						{
							slice_mem_type = eSMT_none;
						}
					}

					template <class U>
					void resize_vector(const int &nxy_i, U &vector)
					{
						vector.resize(n_slice_Allow);
						for(auto i = 0; i < n_slice_Allow; i++)
						{
							vector[i].resize(nxy_i);
						}
					}

					int n_slice_cur(const int &n_slice_i)
					{
						return min(n_slice_Allow, n_slice_i);
					}

					bool is_transmission() const
					{
						return slice_mem_type == eSMT_Transmission;
					}

					bool is_potential() const
					{
						return slice_mem_type == eSMT_Potential;
					}

				private:
					template <class U>
					int number_slices(const double &memory, const int &nxy)
					{
						return static_cast<int>(floor(memory/mt::sizeMb<U>(nxy)));
					}
			};

			Memory_Slice memory_slice;

		protected:
			Vector<Vector<T_c, dev>, e_host> trans_v;
			Vector<Vector<T_r, dev>, e_host> Vp_v;

			FFT<T_r, dev> *fft_2d;
      Vector<T_r, dev> static_B_factor_filter;
      PotentialFunction<T,dev> *potential_function;
	};

} // namespace mt

#endif

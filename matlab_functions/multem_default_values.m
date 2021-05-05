function [input_multislice] = multem_default_values()

%%%%%%%%%%%%%% Electron-Specimen interaction model %%%%%%%%%%%%%%%%%
input_multislice.interaction_model = 1;                         % eESIM_Multislice = 1, eESIM_Phase_Object = 2, eESIM_Weak_Phase_Object = 3
input_multislice.potential_type = 6;                            % ePT_Doyle_0_4 = 1, ePT_Peng_0_4 = 2, ePT_Peng_0_12 = 3, ePT_Kirkland_0_12 = 4, ePT_Weickenmeier_0_12 = 5, ePT_Lobato_0_12 = 6

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.operation_mode = 1;                            % eOM_Normal = 1, eOM_Advanced = 2
input_multislice.memory_size = 0;                               % memory size to be used(Mb)
input_multislice.reverse_multislice = 0;                        % 1: true, 0:false

%%%%%%%%%%%%%%% Electron-Phonon interaction model %%%%%%%%%%%%%%%%%%
input_multislice.pn_model = 1;                                  % ePM_Still_Atom = 1, ePM_Absorptive = 2, ePM_Frozen_Phonon = 3
input_multislice.pn_coh_contrib = 0;                            % 1: true, 0:false
input_multislice.pn_single_conf = 0;                            % 1: true, 0:false (extract single configuration)
input_multislice.pn_nconf = 1;                                  % true: specific phonon configuration, false: number of frozen phonon configurations
input_multislice.pn_dim = 110;                                  % phonon dimensions (xyz)
input_multislice.pn_seed = 300183;                              % Random seed(frozen phonon)

%%%%%%%%%%%%%%%%%%%%%%% Specimen information %%%%%%%%%%%%%%%%%%%%%%%
input_multislice.spec_atoms = [];                               % simulation box length in x direction (�)
input_multislice.spec_dz = 0.25;                                % slice thick (�)

input_multislice.spec_lx = 10;                                  % simulation box length in x direction (�)
input_multislice.spec_ly = 10;                                  % simulation box length in y direction (�)
input_multislice.spec_lz = 10;                                  % simulation box length gpuDEin z direction (�)

input_multislice.spec_cryst_na = 1;                             % number of unit cell along a
input_multislice.spec_cryst_nb = 1;                             % number of unit cell along b
input_multislice.spec_cryst_nc = 1;                             % number of unit cell along c
input_multislice.spec_cryst_a = 0;                              % length along a (�)
input_multislice.spec_cryst_b = 0;                              % length along b (�)
input_multislice.spec_cryst_c = 0;                              % length along c (�)
input_multislice.spec_cryst_x0 = 0;                             % reference position along x direction (�)
input_multislice.spec_cryst_y0 = 0;                             % reference position along y direction (�)

input_multislice.spec_amorp(1).z_0 = 0;                         % Starting z position of the amorphous layer (�)
input_multislice.spec_amorp(1).z_e = 0;                         % Ending z position of the amorphous layer (�)
input_multislice.spec_amorp(1).dz = 2.0;                        % slice thick of the amorphous layer (�)

%%%%%%%%%%%%%%%%%%%%%%%%% Specimen Rotation %%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.spec_rot_theta = 0;                            % angle (�)
input_multislice.spec_rot_u0 = [0 0 1];                          % unitary vector			
input_multislice.spec_rot_center_type = 1;                       % 1: geometric center, 2: User define		
input_multislice.spec_rot_center_p = [0 0 0];                    % rotation point

%%%%%%%%%%%%%%%%%%%%%% Specimen thickness %%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.thick_type = 1;                                % eTT_Whole_Spec = 1, eTT_Through_Thick = 2, eTT_Through_Slices = 3
input_multislice.thick = 0;                                     % Array of thickness (�)

%%%%%%%%%%%%%%%%%%%%%%% Potential slicing %%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.potential_slicing = 1;                         % ePS_Planes = 1, ePS_dz_Proj = 2, ePS_dz_Sub = 3, ePS_Auto = 4

%%%%%%%%%%%%%%%%%%%%%% x-y sampling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.nx = 256;                                      % number of pixels in x direction
input_multislice.ny = 256;                                      % number of pixels in y direction
input_multislice.bwl = 0;                                       % Band-width limit, 1: true, 0:false

%%%%%%%%%%%%%%%%%%%%%%%% Simulation type %%%%%%%%%%%%%%%%%%%%%%%%%%%
% eTEMST_STEM=11, eTEMST_ISTEM=12, eTEMST_CBED=21, eTEMST_CBEI=22, 
% eTEMST_ED=31, eTEMST_HRTEM=32, eTEMST_PED=41, eTEMST_HCTEM=42, 
% eTEMST_EWFS=51, eTEMST_EWRS=52, eTEMST_EELS=61, eTEMST_EFTEM=62, 
% eTEMST_ProbeFS=71, eTEMST_ProbeRS=72, eTEMST_PPFS=81, eTEMST_PPRS=82, 
% eTEMST_TFFS=91, eTEMST_TFRS=92
input_multislice.simulation_type = 52;    

%%%%%%%%%%%%%%%%%%%%%%%%%%% Incident wave %%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.iw_type = 4;                                   % 1: Plane_Wave, 2: Convergent_wave, 3:User_Define, 4: auto
input_multislice.iw_psi = 0;                                    % User define incident wave. It will be only used if User_Define=3
input_multislice.iw_x = 0.0;                                    % x position 
input_multislice.iw_y = 0.0;                                    % y position

%%%%%%%%%%%%%%%%%%%% Microscope parameters %%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.E_0 = 300;                                     % Acceleration Voltage (keV)
input_multislice.theta = 0.0;                                   % Polar angle (�)
input_multislice.phi = 0.0;                                     % Azimuthal angle (�)

%%%%%%%%%%%%%%%%%%%%%% Illumination model %%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.illumination_model = 2;                        % 1: coherente mode, 2: Partial coherente mode, 3: transmission cross coefficient, 4: Numerical integration
input_multislice.temporal_spatial_incoh = 1;                    % 1: Temporal and Spatial, 2: Temporal, 3: Spatial

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On the optimun probe in aberration corrected ADF-STEM
% Ultramicroscopy 111(2014) 1523-1530
% C_{nm} Krivanek --- {A, B, C, D, R}_{n} Haider notation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%% condenser lens %%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.cond_lens_m = 0;                               % Vortex momentum

input_multislice.cond_lens_c_10 = 14.0312;                      % [C1]      Defocus (�)
input_multislice.cond_lens_c_12 = 0.00;                         % [A1]      2-fold astigmatism (�)
input_multislice.cond_lens_phi_12 = 0.00;                       % [phi_A1]	Azimuthal angle of 2-fold astigmatism (�)

input_multislice.cond_lens_c_21 = 0.00;                         % [B2]      Axial coma (�)
input_multislice.cond_lens_phi_21 = 0.00;                       % [phi_B2]	Azimuthal angle of axial coma (�)
input_multislice.cond_lens_c_23 = 0.00;                         % [A2]      3-fold astigmatism (�)
input_multislice.cond_lens_phi_23 = 0.00;                       % [phi_A2]	Azimuthal angle of 3-fold astigmatism (�)

input_multislice.cond_lens_c_30 = 1e-03;                        % [C3] 		3rd order spherical aberration (mm)
input_multislice.cond_lens_c_32 = 0.00;                         % [S3]      Axial star aberration (�)
input_multislice.cond_lens_phi_32 = 0.00;                       % [phi_S3]	Azimuthal angle of axial star aberration (�)
input_multislice.cond_lens_c_34 = 0.00;                         % [A3]      4-fold astigmatism (�)
input_multislice.cond_lens_phi_34 = 0.0;                        % [phi_A3]	Azimuthal angle of 4-fold astigmatism (�)

input_multislice.cond_lens_c_41 = 0.00;                         % [B4]      4th order axial coma (�)
input_multislice.cond_lens_phi_41 = 0.00;                       % [phi_B4]	Azimuthal angle of 4th order axial coma (�)
input_multislice.cond_lens_c_43 = 0.00;                         % [D4]      3-lobe aberration (�)
input_multislice.cond_lens_phi_43 = 0.00;                       % [phi_D4]	Azimuthal angle of 3-lobe aberration (�)
input_multislice.cond_lens_c_45 = 0.00;                         % [A4]      5-fold astigmatism (�)
input_multislice.cond_lens_phi_45 = 0.00;                       % [phi_A4]	Azimuthal angle of 5-fold astigmatism (�)

input_multislice.cond_lens_c_50 = 0.00;                         % [C5]      5th order spherical aberration (mm)
input_multislice.cond_lens_c_52 = 0.00;                         % [S5]      5th order axial star aberration (�)
input_multislice.cond_lens_phi_52 = 0.00;                       % [phi_S5]	Azimuthal angle of 5th order axial star aberration (�)
input_multislice.cond_lens_c_54 = 0.00;                         % [R5]      5th order rosette aberration (�)
input_multislice.cond_lens_phi_54 = 0.00;                       % [phi_R5]	Azimuthal angle of 5th order rosette aberration (�)
input_multislice.cond_lens_c_56 = 0.00;                         % [A5]      6-fold astigmatism (�)
input_multislice.cond_lens_phi_56 = 0.00;                       % [phi_A5]	Azimuthal angle of 6-fold astigmatism (�)

input_multislice.cond_lens_inner_aper_ang = 0.0;                % Inner aperture (mrad) 
input_multislice.cond_lens_outer_aper_ang = 21.0;   			% Outer aperture (mrad)

%%%%%%%%%% source spread function %%%%%%%%%%%%
input_multislice.cond_lens_ssf_sigma = 0.0072;                  % standard deviation: For parallel ilumination(�^-1); otherwise (�)
input_multislice.cond_lens_ssf_npoints = 8;              		% # of integration points. It will be only used if illumination_model=4

%%%%%%%%% defocus spread function %%%%%%%%%%%%
input_multislice.cond_lens_dsf_sigma = 32;                 		% standard deviation (�)
input_multislice.cond_lens_dsf_npoints  = 10;                	% # of integration points. It will be only used if illumination_model=4

%%%%%%%%% zero defocus reference %%%%%%%%%%%%
input_multislice.cond_lens_zero_defocus_type = 1;   			% eZDT_First = 1, eZDT_User_Define = 2
input_multislice.cond_lens_zero_defocus_plane = 0;  			% It will be only used if cond_lens_zero_defocus_type = eZDT_User_Define

%%%%%%%%%%%%%%%%%%% condenser lens variable %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% it will be active in the future %%%%%%%%%%%%%%%%%
% 1: Vortex momentum, 2: Defocus (�), 2: Third order spherical aberration (mm)
% 3: Third order spherical aberration (mm),  4: Fifth order spherical aberration (mm)
% 5: Twofold astigmatism (�), 2: Defocus (�), 6: Azimuthal angle of the twofold astigmatism (�)
% 7: Threefold astigmatism (�),  8: Azimuthal angle of the threefold astigmatism (�)
% 9: Inner aperture (mrad), 2: Defocus (�), 10: Outer aperture (mrad)
% input_multislice.cdl_var_type = 0;                  			% 0:off 1: m, 2: f, 3 Cs3, 4:Cs5, 5:mfa2, 6:afa2, 7:mfa3, 8:afa3, 9:inner_aper_ang , 10:outer_aper_ang
% input_multislice.cdl_var = [-2 -1 0 1 2];           			% variable array

%%%%%%%%%%%%%%%%%%%%%%%% Objective lens %%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.obj_lens_m = 0;                                % Vortex momentum

input_multislice.obj_lens_c_10 = 14.0312;                       % [C1]      Defocus (�)
input_multislice.obj_lens_c_12 = 0.00;                          % [A1]      2-fold astigmatism (�)
input_multislice.obj_lens_phi_12 = 0.00;                        % [phi_A1]	Azimuthal angle of 2-fold astigmatism (�)

input_multislice.obj_lens_c_21 = 0.00;                          % [B2]      Axial coma (�)
input_multislice.obj_lens_phi_21 = 0.00;                        % [phi_B2]	Azimuthal angle of axial coma (�)
input_multislice.obj_lens_c_23 = 0.00;                          % [A2]      3-fold astigmatism (�)
input_multislice.obj_lens_phi_23 = 0.00;                        % [phi_A2]	Azimuthal angle of 3-fold astigmatism (�)

input_multislice.obj_lens_c_30 = 1e-03;                         % [C3] 		3rd order spherical aberration (mm)
input_multislice.obj_lens_c_32 = 0.00;                          % [S3]      Axial star aberration (�)
input_multislice.obj_lens_phi_32 = 0.00;                        % [phi_S3]	Azimuthal angle of axial star aberration (�)
input_multislice.obj_lens_c_34 = 0.00;                          % [A3]      4-fold astigmatism (�)
input_multislice.obj_lens_phi_34 = 0.0;                         % [phi_A3]	Azimuthal angle of 4-fold astigmatism (�)

input_multislice.obj_lens_c_41 = 0.00;                          % [B4]      4th order axial coma (�)
input_multislice.obj_lens_phi_41 = 0.00;                        % [phi_B4]	Azimuthal angle of 4th order axial coma (�)
input_multislice.obj_lens_c_43 = 0.00;                          % [D4]      3-lobe aberration (�)
input_multislice.obj_lens_phi_43 = 0.00;                        % [phi_D4]	Azimuthal angle of 3-lobe aberration (�)
input_multislice.obj_lens_c_45 = 0.00;                          % [A4]      5-fold astigmatism (�)
input_multislice.obj_lens_phi_45 = 0.00;                        % [phi_A4]	Azimuthal angle of 5-fold astigmatism (�)

input_multislice.obj_lens_c_50 = 0.00;                          % [C5]      5th order spherical aberration (mm)
input_multislice.obj_lens_c_52 = 0.00;                          % [S5]      5th order axial star aberration (�)
input_multislice.obj_lens_phi_52 = 0.00;                        % [phi_S5]	Azimuthal angle of 5th order axial star aberration (�)
input_multislice.obj_lens_c_54 = 0.00;                          % [R5]      5th order rosette aberration (�)
input_multislice.obj_lens_phi_54 = 0.00;                        % [phi_R5]	Azimuthal angle of 5th order rosette aberration (�)
input_multislice.obj_lens_c_56 = 0.00;                          % [A5]      6-fold astigmatism (�)
input_multislice.obj_lens_phi_56 = 0.00;                        % [phi_A5]	Azimuthal angle of 6-fold astigmatism (�)

input_multislice.obj_lens_inner_aper_ang = 0.0;     			% Inner aperture (mrad) 
input_multislice.obj_lens_outer_aper_ang = 24.0;    			% Outer aperture (mrad)

%%%%%%%%% defocus spread function %%%%%%%%%%%%
input_multislice.obj_lens_dsf_sigma = 32;                 		% standard deviation (�)
input_multislice.obj_lens_dsf_npoints  = 10;                	% # of integration points. It will be only used if illumination_model=4

%%%%%%%%% zero defocus reference %%%%%%%%%%%%
input_multislice.obj_lens_zero_defocus_type = 3;    			% eZDT_First = 1, eZDT_Middle = 2, eZDT_Last = 3, eZDT_User_Define = 4
input_multislice.obj_lens_zero_defocus_plane = 0;   			% It will be only used if obj_lens_zero_defocus_type = eZDT_User_Define

%%%%%%%%%%%%%%%%%%%%%%%%%% STEM Detector %%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.detector.type = 1;  % eDT_Circular = 1, eDT_Radial = 2, eDT_Matrix = 3

input_multislice.detector.cir(1).inner_ang = 60;    			% Inner angle(mrad) 
input_multislice.detector.cir(1).outer_ang = 180;   			% Outer angle(mrad)
			
input_multislice.detector.radial(1).x = 0;          			% radial detector angle(mrad)
input_multislice.detector.radial(1).fx = 0;         			% radial sensitivity value
			
input_multislice.detector.matrix(1).R = 0;          			% 2D detector angle(mrad)
input_multislice.detector.matrix(1).fR = 0;         			% 2D sensitivity value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Scanning area for ISTEM/STEM/EELS %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.scanning_type = 1;                 			% eST_Line = 1, eST_Area = 2
input_multislice.scanning_periodic = 1;             			% 1: true, 0:false (periodic boundary conditions)
input_multislice.scanning_ns = 10;                  			% number of sampling points
input_multislice.scanning_x0 = 0.0;                 			% x-starting point (�)
input_multislice.scanning_y0 = 0.0;                 			% y-starting point (�)
input_multislice.scanning_xe = 4.078;               			% x-final point (�)
input_multislice.scanning_ye = 4.078;               			% y-final point (�)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.ped_nrot = 360;                    			% Number of orientations
input_multislice.ped_theta = 3.0;                   			% Precession angle (degrees)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HCI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.hci_nrot = 360;                    			% number of orientations
input_multislice.hci_theta = 3.0;                   			% Precession angle (degrees)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%EELS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.eels_Z = 79;                       			% atomic type
input_multislice.eels_E_loss = 80;                  			% Energy loss (eV)
input_multislice.eels_collection_angle = 100;       			% Collection half angle (mrad)
input_multislice.eels_m_selection = 3;              			% selection rule
input_multislice.eels_channelling_type = 1;         			% eCT_Single_Channelling = 1, eCT_Mixed_Channelling = 2, eCT_Double_Channelling = 3 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%EFTEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.eftem_Z = 79;                      			% atomic type
input_multislice.eftem_E_loss = 80;                 			% Energy loss (eV)
input_multislice.eftem_collection_angle = 100;      			% Collection half angle (mrad)
input_multislice.eftem_m_selection = 3;             			% selection rule
input_multislice.eftem_channelling_type = 1;        			% eCT_Single_Channelling = 1, eCT_Mixed_Channelling = 2, eCT_Double_Channelling = 3 

%%%%%%%%%%%%%%%%%%%%%%% OUTPUT REGION %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This option is not use for eTEMST_STEM and eTEMST_EELS %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_multislice.output_area_ix_0 = 1;                             % x-starting in pixel
input_multislice.output_area_iy_0 = 1;                             % y-starting in pixel
input_multislice.output_area_ix_e = 1;                             % x-final in pixel
input_multislice.output_area_iy_e = 1;                             % y-final in pixel
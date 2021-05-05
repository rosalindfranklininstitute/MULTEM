function [atoms, lx, ly, lz, a, b, c, dz] = LaAlO3001_xtl(na, nb, nc, ncu, rms3d)
    xtl_parm.na = na;
    xtl_parm.nb = nb;
    xtl_parm.nc = nc;
    a = 3.7900; 
    b = 3.79; 
    c = 3.79;
    xtl_parm.a = a;
    xtl_parm.b = b;
    xtl_parm.c = c;
    xtl_parm.nuLayer = 2;
    occ = 1;
    region = 0;
    charge = 0;
    % Sr = 38, Ti = 22; O = 8
    % La = 57, Al = 13; O = 8
    % Z charge x y z rms3d occupancy region charge
    xtl_parm.uLayer(1).atoms = [57, 0.0, 0.0, 0.0, rms3d, occ, region, charge; 8, 0.5, 0.5, 0.0, rms3d, occ, region, charge];
    xtl_parm.uLayer(2).atoms = [8, 0.0, 0.5, 0.5, rms3d, occ, region, charge; 8, 0.5, 0.0, 0.5, rms3d, occ, region, charge; 13, 0.5, 0.5, 0.5, rms3d, occ, region, charge];
    atoms = il_crystal_by_lays(xtl_parm);

    dz = xtl_parm.c/ncu;
    lx = na*xtl_parm.a; ly = nb*xtl_parm.b; lz = nc*xtl_parm.c;
end
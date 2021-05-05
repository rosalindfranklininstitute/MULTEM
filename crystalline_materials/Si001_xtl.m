function [atoms, lx, ly, lz, a, b, c, dz] = Si001_xtl(na, nb, nc, ncu, rms3d)
    xtl_parm.na = na;
    xtl_parm.nb = nb;
    xtl_parm.nc = nc;
    a = 5.4307; 
    b = 5.4307; 
    c = 5.4307;
    xtl_parm.a = a;
    xtl_parm.b = b;
    xtl_parm.c = c;
    xtl_parm.nuLayer = 4;
    occ = 1;
    region = 0;
    charge = 0;
    % Si = 14
    % Z charge x y z rms3d occupancy region charge
    xtl_parm.uLayer(1).atoms = [14, 0.00, 0.00, 0.00, rms3d, occ, region, charge; 14, 0.50, 0.50, 0.00, rms3d, occ, region, charge];
    xtl_parm.uLayer(2).atoms = [14, 0.25, 0.25, 0.25, rms3d, occ, region, charge; 14, 0.75, 0.75, 0.25, rms3d, occ, region, charge];
    xtl_parm.uLayer(3).atoms = [14, 0.00, 0.50, 0.50, rms3d, occ, region, charge; 14, 0.50, 0.00, 0.50, rms3d, occ, region, charge];
    xtl_parm.uLayer(4).atoms = [14, 0.25, 0.75, 0.75, rms3d, occ, region, charge; 14, 0.75, 0.25, 0.75, rms3d, occ, region, charge];
    atoms = il_crystal_by_lays(xtl_parm);

    dz = xtl_parm.c/ncu;
    lx = na*xtl_parm.a; ly = nb*xtl_parm.b; lz = nc*xtl_parm.c;
end
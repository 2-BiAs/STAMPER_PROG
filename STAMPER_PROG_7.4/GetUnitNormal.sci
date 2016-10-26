function vNorm = GetUnitNormal(lnInput)
    //direction determined by positive 90° rotation about axis normal to plane
    
    vNorm = [lnInput(2, 2) - lnInput(1, 2), lnInput(1, 1) - lnInput(2, 1)];
    vNorm = vNorm / norm(vNorm);


endfunction

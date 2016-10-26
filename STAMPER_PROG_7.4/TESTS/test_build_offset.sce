vA = [0 -1];

vA_N = ([0 -1; 1 0] * vA')' / norm(vA);
        vA_N_N = -vA;
        
        fTheta = modulo(atan(vA(2) , vA(1)) + %pi, %pi)
        
        disp(fTheta)

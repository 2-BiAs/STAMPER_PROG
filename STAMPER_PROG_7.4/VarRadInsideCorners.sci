function plOutput = VarRadInsideCorners(plInput, iN)
    //assume tool data can be extracted from mOffestRegimeBoundaries & mOffsetComponents
    
    fRadMax = .500; //maximum radius for inside corner
    fT_Ni = .100;   //Nominal nickel thickness
    fM_V = .060;    //Nickel undercut margin in valley
    fM_P = .060;    //Nickel margin at peak
    
    //fRadOutside = .001; //Radius for outside corner
    
    for i=2:size(plInput, 1) - 1;
        
        //Get segments from plInput
        lnA = plInput(i-1:i, :);
        lnB = plInput(i:i+1, :);
        
        //Segments --> Vectors
        vA = lnA(2, :) - lnA(1,:);
        vB = lnB(2, :) - lnB(1,:);

        //Calculate Normal Vectors
        vN_A = ([0 -1; 1 0] * vA')';
        vN_B = ([0 -1; 1 0] * vB')';

        //Calculte angle from Θ=0 to normal vectors
        fAlpha = atan(vN_A(2), vN_A(1)) + %pi;
        fBeta =  atan(vN_B(2), vN_B(1)) + %pi;

        //Caculate angles between vectors
        fA = atan(vA(2), vA(1));
        fB = atan(vB(2), vB(1));
        fCornerAngle = abs(fA + fB);
        
        //Set first output point
        plOutput(1,1:2) = plInput(1, :);
        
        //Check Corner Type
        bInsideCorner = 1 == sign(det([vA; vB]));
                
        if bInsideCorner then

            //Calculate Inside Radius
            fRadius = (fT_Ni - fM_V * sin(fCornerAngle / 2)) / (1 - sin(fCornerAngle/2));
            fRadius = min(fRadMax, fRadius);
            
//            printf("R  = %f\n", fRadius);
//            pause
            
            fR(i-1,1) = fCornerAngle * (180/%pi);
            fR(i-1,2) = fRadius;
            fR(i-1,3) = fAlpha * (180/%pi);
            fR(i-1,4) = fBeta * (180/%pi);
            //Offeset polylines to determine arc center
            vOffsetRegime = [0, %pi];
            mOffsetComponents = [[fRadius, 0], [0, 0]];

            plOffset = IROffsetPolyline(plInput(i-1:i+1,1:2), vOffsetRegime, mOffsetComponents);

            //Create Arc domain (Θ)
            fTheta = linspace(fAlpha, fBeta, iN)';

            plArcPoints = [cos(fTheta), sin(fTheta)] * fRadius;

            if i ~= size(plInput, 1) - 1 then
                lnC = plInput(i + 1:i + 2, :);
                vC = lnC(2, :) - lnC(1,:);
                lnC(1,1:2) = lnC(1,1:2) - vC;
                plTemp = ones(plArcPoints(:,1)) * plOffset(2, 1:2) + plArcPoints
                listTemp = SlicePolyline(plTemp, lnC, %T);

                if isempty(listTemp)
                    plOutput($+1 : $+size(plTemp,1), 1:2) = plTemp;
                else
                    plOutput($+1: $+size(listTemp(1),1), 1:2) = listTemp(1);
                end
            else
                plTemp = ones(plArcPoints(:,1)) * plOffset(2, 1:2) + plArcPoints;
                plOutput($+1: $+size(plTemp,1), 1:2) = plTemp;
            end
        //Write Arc Points to polyline output buffer
//        for j=1:size(plArcPoints, 1)
//            plOutput($+1, 1:2) = plOffset(2, :) + plArcPoints(j, :);                
//        end
//            
        else
            
//            //Set radius for outside corner
//            fRadius = -fRadOutside;
            plOutput($+1, 1:2) = plInput(i, :);
        end
    end
    
    disp(fR)
    plOutput($+1,1:2) = plInput($, :);
endfunction

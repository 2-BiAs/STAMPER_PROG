function plOutput = RadOutsideCorners(plInput, fRadius, iN)
    
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
        fCornerAngle = %pi - abs(fA - fB);
        
        //Set first output point
        plOutput(1,1:2) = plInput(1, :);
        
        //Check Corner Type
        bInsideCorner = 1 == sign(det([vA; vB]));
//        disp(i)
//        disp(fCornerAngle * 180 / %pi)
//        disp(bInsideCorner)
//        pause
        
        if bInsideCorner | fCornerAngle < .5 then
            plOutput($+1, 1:2) = plInput(i, :);
        elseif fCornerAngle < 150/180*%pi
            //Offeset polylines to determine arc center
            vOffsetRegime = [0, %pi];
            mOffsetComponents = [[-fRadius, 0], [0, 0]];

            plOffset = IROffsetPolyline(plInput(i-1:i+1,1:2), vOffsetRegime, mOffsetComponents);

            //Create Arc domain (Θ)
            fTheta = linspace(fAlpha, fBeta, iN)';

            plArcPoints = [cos(fTheta), sin(fTheta)] * -fRadius;
            plTemp = ones(plArcPoints(:,1)) * plOffset(2, 1:2) + plArcPoints;
            plOutput($+1 : $+size(plTemp,1), 1:2) = plTemp;
            
            if plOutput($,:) == plOutput($-1,:) then
                disp('fart');
                pause;
            end
        end
    end
    
    plOutput($+1,1:2) = plInput($, :);
endfunction

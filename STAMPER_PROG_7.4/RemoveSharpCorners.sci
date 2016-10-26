function plOutput = RemoveSharpCorners(plInput, fThresholdAngle)
    
    bRemovalComplete = %F;
    
    plOutBuff = plInput;
    
    while(~bRemovalComplete)
        
        bRemovalComplete = %T;
        plInBuff = plOutBuff;
        plOutBuff = [];
        
        //Set first output point
        plOutBuff(1,1:2) = plInBuff(1, :);
        
        for i=2:size(plInBuff, 1) - 1;

            //Get segments from plInput
            lnA = plInBuff(i-1:i, :);
            lnB = plInBuff(i:i+1, :);

            //Segments --> Vectors
            vA = -(lnA(2, :) - lnA(1,:)); //Flip sign so both vectors point away from the point under inspection
            vB = lnB(2, :) - lnB(1,:);

            //Calculte angle from Θ=0 
            fAlpha = atan(vA(2), vA(1)) + %pi; //add pi to both angles to ensure angles are between 0 and 2pi
            fBeta =  atan(vB(2), vB(1)) + %pi;  //this will not effect the angle between as it is the difference....
            
            //Caculate angles between vectors
            fA = atan(vA(2), vA(1));
            fB = atan(vB(2), vB(1));
            fCornerAngle = abs(fA - fB);
            
            
            
            if fCornerAngle > fThresholdAngle then
                plOutBuff($+1, 1:2) = plInBuff(i, 1:2);
//                printf("%f, Corner Stays\n", fCornerAngle);
            else                
//                disp(fCornerAngle);
                bRemovalComplete = %F;
            end
            
        end
        plOutBuff($ + 1,1:2) = plInBuff($, :);
//        SuperPlot(list(plInBuff, plOutBuff));
//        a = gca();
//        a.isoview = "on";
//        pause;
    end
    
    plOutput = plOutBuff;
    
endfunction

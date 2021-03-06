function plOutput = RoundCorner(plInput, fR, iN)
    //assume tool data can be extracted from mOffestRegimeBoundaries & mOffsetComponents
    
    //Offset Components
    vNormalOffsetRegime = [0, %pi];
    mNormalOffsetComponents = [[fRadius, 0], [0, 0]];
    
    fR = mNormalOffsetComponents(1,1);

    plOffset = OffsetPolyline(plInput, vNormalOffsetRegime, mNormalOffsetComponents);
    plOutput(1,1:2) = plInput(1, :);
    for i=2:size(plInput, 1) - 1;
        lnA = plInput(i-1:i, :);
        lnB = plInput(i:i+1, :);
        
        vA = lnA(2, :) - lnA(1,:);
        vB = lnB(2, :) - lnB(1,:);
        
        bInsideCorner = 1 == sign(det([vA; vB]));
        //disp(det([vA; vB]))
        if bInsideCorner then
            vR = ([0 -1; 1 0] * vA')' * fR;
            vR2 = ([0 -1; 1 0] * vB')' * fR;
            
            //Need to fix this section so that alpha and beta are determined based on where lnA and lnB fall in the tool offset regime. This will make this method work for tools of all shape.
            fAlpha = atan(vR(2), vR(1)) + %pi;
            //fBeta =  atan(vT(2), vT(1)) + %pi; //for the time being use this for split rad tool
            fBeta =  atan(vR2(2), vR2(1)) + %pi; //use this for full rad
            
            fTheta = linspace(fAlpha, fBeta, iN)';
            //fTheta = fTheta(2:$-1);
            plArcPoints = [cos(fTheta), sin(fTheta)] * fR;
            //pause
            for j=1:size(plArcPoints, 1)
                plOutput($+1, 1:2) = plOffset(i, :) + plArcPoints(j, :);                
            end
        else
            plOutput($+1, 1:2) = plInput(i, :);
        end
    end
    //pause
    plOutput($+1,1:2) = plInput($, :);
    //SuperPlot(list(plOffset), list('b--'));
endfunction

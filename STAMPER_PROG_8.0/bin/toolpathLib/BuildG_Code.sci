function sOutput = BuildG_Code(plInput)
    
    for i=1:size(plInput,1)
        
        if i == 1
            sFeed = "F(P9)"; //Rapid to start point
        else
            
            //Calculate angle of i^th PL segment
            vA = plInput(i, :) - plInput(i - 1, :);
            fTheta(i) = atan(vA(2), vA(1)); //Returns segment angle in the interva (-pi, pi]
            fTheta(i) = fTheta(i) * 180 / %pi;
            fTheta(i) = round(fTheta(i)*100)/100; //Round to nearest .01;

            //Set appropriate sFeed based on PL segment angle
            if fTheta(i) == 0 | fTheta(i) == 180 | fTheta(i) == 90 | fTheta(i) == -90 then
                sFeed = "F(P9)";  //Rapid moves
            elseif fTheta(i) < -90 & fTheta(i) > -100
                sFeed = "F(P8)"; //Infeed for steep plunging cuts
            else
                sFeed = "F(P7)"; //Default feed for groove cuts
            end

            //Fix sFeeds for Center (Exeptions to the general rule above)
            if fTheta(i) == -90 & listCompedCutPath(i+1, 1) > -1
                sFeed = "F(P8)"; //Infeed for steep plunging cuts
            end
            
            if fTheta(i) == 180 & fTheta(i) == -180 & listCompedCutPath(i, 1) > -1
                sFeed = "F(P7)"; //Default feed for groove cuts
            end
            
        end
        
        sOutput($+1) = msprintf("X%f\tZ%f\t%s", listCompedCutPath(i,1), listCompedCutPath(i,2), sFeed);
        
    end
endfunction

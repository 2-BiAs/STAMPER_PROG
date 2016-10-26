function [listOutput, iLevelIndicies] = LvlMultiOffsetToBoundary(listInput, listMultiPassOffsetRegimes, listMultiPassOffsetComponents, plBoundary, iStartLevel, bIsSliceFirst)
    listInputBuffer = listInput;
    listOutput = list();
    iLevelIndicies = [];
    
    bPointsRemaining = %T;
    iLevel = iStartLevel;
    
    printf("iLevel = %d\n", iLevel)
    
    j = 0;
    while bPointsRemaining
        j = j + 1
        printf("j = %d\n", j)
        //pause
        if typeof(listInputBuffer) == 'list' then
            for i=1:size(listInputBuffer)
                printf("i = %d\n", i)
                if ~isempty(listInputBuffer(i)) then
                    [listOutput($+1), iTempIndicies] = MultiOffsetToBoundary(listInputBuffer(i), listMultiPassOffsetRegimes, listMultiPassOffsetComponents, plBoundary, iLevel);
                    iIndexCount = size(iTempIndicies);
                    try
                        iLevelIndicies($+1:$+iIndexCount) = iTempIndicies;
                    catch
//                        disp('Farge')
//                        disp(iTempIndicies);
//                        pause;
                    end
                end
            end
            bPointsRemaining = %F;
        elseif ~isempty(listInputBuffer)
            tempOffsetRegimes = listMultiPassOffsetRegimes(min(iLevel, size(listMultiPassOffsetRegimes)));
            tempOffsetComponents = listMultiPassOffsetComponents(min(iLevel, size(listMultiPassOffsetComponents)));

            listOutput($+1) = OffsetPolyline(listInputBuffer, tempOffsetRegimes, tempOffsetComponents);
            iLevelIndicies($+1) = iLevel;
            iLevel = iLevel + 1;
            printf("size(listInputBuffer,1) = %d\n", size(listInputBuffer,1))
            printf("size(listOutput($),1) = %d\n", size(listOutput($),1))
            //pause
            if ~isempty(listOutput($)) then
                listTemp = SlicePolyline(listOutput($), plBoundary, bIsSliceFirst);
                if isempty(listTemp)
                    listTemp = list(listOutput($));
                    pause;
                end
            else
                listTemp = list();    
            end
            
            printf("size(listTemp) = %d\n", size(listTemp))
            if isempty(listTemp) then
                printf("listTemp is empty\n")
                listOutput($) = null();
                iLevelIndicies($) = [];
                bPointsRemaining = %F;
            else
                listOutput($) = listTemp;
                iLevelIndicies($) = iLevel;
                listInputBuffer = listTemp;
                //SuperPlot(listOutput($), list('b--', 'r--'));
                //disp(size(listOutput))
            end
        else
            bPointsRemaining = %F;
        end        
    end
    
    
endfunction

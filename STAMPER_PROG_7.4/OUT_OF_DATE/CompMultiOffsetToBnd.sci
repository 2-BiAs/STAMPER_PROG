function [listOutput, listCompedOutput, iLevelIndicies] = CompMultiOffsetToBnd(listInput, listMultiPassOffsetRegimes, listMultiPassOffsetComponents, plBoundary, iStartLevel, vORBM, mCutterCompOffsetComponents)
    listInputBuffer = listInput;
    listOutput = list();
    listCompedOutput = list();
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
                    [listOutput($+1), listCompedOutput($+1), iTempIndicies] = CompMultiOffsetToBnd(listInputBuffer(i), listMultiPassOffsetRegimes, listMultiPassOffsetComponents, plBoundary, iLevel, vORBM, mCutterCompOffsetComponents);
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
                listTemp = SlicePolyline(listOutput($), plBoundary, %T);                
                listCompedOutput($ + 1) = OffsetPolyline(listOutput($), vORBM, mCutterCompOffsetComponents);
                if ~isempty(listCompedOutput($)) then
                    listTempComped = SlicePolyline(listCompedOutput($), plBoundary, %T);
                end
            else
                listTemp = list();    
            end
            
            printf("size(listTemp) = %d\n", size(listTemp))
            if isempty(listTemp) then
                printf("listTemp is empty\n")
                listOutput($) = null();
                if isempty(listTempComped) then
                    listCompedOutput($) = null();
                end
                iLevelIndicies($) = [];
                bPointsRemaining = %F;
            else
                listOutput($) = listTemp;
                listCompedOutput($) = listTempComped;
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
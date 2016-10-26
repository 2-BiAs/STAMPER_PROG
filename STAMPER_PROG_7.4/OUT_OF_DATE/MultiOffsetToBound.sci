function listOutput = MultiOffsetToBoundary(listInput, listMultiPassOffsetRegimes, listMultiPassOffsetComponents, plBoundary, iStartLevel)
    listInputBuffer = list();
    listOutput = list();
        
    iLevel = iStartLevel;
    while bPointsRemaining
        if typeof(listInputBuffer) == 'list' then
            for i=1:size(listInputBuffer)
                listOutput($+1) = MultiOffsetToBoundary(listInputBuffer(i), listMultiPassOffsetRegimes, listMultiPassOffsetComponents, plBoundary, iLevel + 1);
            end
        else
            tempOffsetRegimes = listMultiPassOffsetRegimes(min(iLevel, size(listMultiPassOffsetRegimes)));
            tempOffsetComponents = listMultiPassOffsetComponents(min(iLevel, size(listMultiPassOffsetComponents)));
            
            listOutput($+1) = OffsetPolyline(listInputBuffer, vMultiPassOffsetRegimes, tempOffsetComponents);
                        
            listTemp = SlicePolyline(listOutput($), plBoundary, %T);
            if isempty(listTemp) then
                listOutput($) = null();
                bPointsRemaining = %F;
            else
                listOutput($) = listTemp;
                listInputBuffer = listTemp;
            end
        end
    end
    
    
endfunction

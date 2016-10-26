function listOutput = SlicePolylines(listInput, plBoundary, bRightHanded)
    listOutput = list();
    
    for i = 1:size(listInput)
        if ~isempty(listInput) then
            listTemp = SlicePolyline(listInput(i), plBoundary, bRightHanded);
            for j = 1:size(listTemp)
                listOutput($+1) = listTemp(j); 
            end
        end
    end
endfunction

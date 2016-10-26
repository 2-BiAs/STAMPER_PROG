function listOutput = OffsetPolylines(listInput, mOffestRegimeBoundaries, mOffsetComponents)
    listOutput = list();
    for i=1:size(listInput)
        if ~isempty(listInput(i)) then
            //pause
            listOutput($+1) = OffsetPolyline(listInput(i), mOffestRegimeBoundaries, mOffsetComponents);
        end
    end
endfunction

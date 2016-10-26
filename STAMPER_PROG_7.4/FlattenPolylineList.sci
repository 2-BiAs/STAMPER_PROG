function listOutput = FlattenPolylineList(listInput)
    listOutput = list();
    for i = 1:size(listInput)
        if typeof(listInput(i)) == 'list' then
            listBuffer = FlattenPolylineList(listInput(i));
            for j = 1:size(listBuffer)
                listOutput($+1) = listBuffer(j);
            end
        else
            listOutput($+1) = listInput(i);
        end
    end
endfunction

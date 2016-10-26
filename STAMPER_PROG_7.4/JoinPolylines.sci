function plOutput = JoinPolylines(listInput)
    for i = 1:size(listInput)
        plTemp = listInput(i);
        plOutput($+1:$+size(plTemp,1), 1:2) = plTemp(:,:);
    end
endfunction

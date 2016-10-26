function plOutput = MergePolylineList(listInput)
    plOutput = [];
    for i = 1:size(listInput)
        disp(i)
        N = size(listInput(i), 1);
        plOutput($ + 1:$ + N,1:2) = listInput(i);
    end
endfunction

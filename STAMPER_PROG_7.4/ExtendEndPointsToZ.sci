function listOutput = ExtendEndPointsToZ(listInput, fExtendTo)
    //[0 1] extend to Z (Y) = 1; [-1 0] extend to X = -1
    //listInput should be a polyline list with depth 1
    listOutput = list();
    for i=1:size(listInput)
        if ~isempty(listInput(i)) then
            plTemp = listInput(i);
            disp(i)
            //pause
            plTemp(1:$+1, 1:2) = [[plTemp(1, 1), fExtendTo]; plTemp];
            plTemp($+1, 1:2) = [plTemp($, 1), fExtendTo];
            listOutput($+1) = plTemp;
        end
    end
endfunction

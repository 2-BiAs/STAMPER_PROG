function listOutput = ClearListEmpties(listInput)
    listTemp = listInput;
    for i = size(listInput):-1:1
        disp(i)
        if isempty(listInput) then
            listTemp(i) = null(); //listInput(i);
        end
    end
    listOutput = listTemp;
endfunction

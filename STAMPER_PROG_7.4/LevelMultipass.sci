function listOutput = LevelMultipass(listInput, pgBoundary, fDOC)
    listInputBuffer = listInput;
    listOutput = list();
    
    DuperPlot(pgMultipassBoundary);
    
    bInputIsEmpty = isempty(listInput);
    disp("Entering loop")
    while ~bInputIsEmpty
        disp("Loop")
        //Recursively Call LevelMultipass function to traverse tree
        if typeof(listInputBuffer) == 'list' then
            disp("Decomposing List")
            for i=1:size(listInputBuffer)
                listOutput($ + 1) = listInputBuffer(i);
                DuperPlot(listOutput($));
                pause
                listTemp = LevelMultipass(listInputBuffer(i), pgBoundary, fDOC)
                printf('i = %d', i);
                if ~isempty(listTemp)
                    listOutput($ + 1) = listTemp
                else
                    disp('Returned Empty')
                end
            end
        else
            
            plInput = listInputBuffer;
            plTemp = OffsetNormal(plInput, fDOC);
            listTemp = SlicePolyline(plTemp, pgBoundary, %F);
                        
            //If an empty slice occurs, check to see if the input PL lies outside of the PG boundary
            if isempty(listTemp)
                disp('Empty Slice')
                if ~PointInPolygon(pgBoundary, plTemp(1,1:2))
                    listOutput($ + 1) = plTemp;
                    listInputBuffer = plTemp;
                    disp('First Point Not In Polygon')
                    DuperPlot(listOutput($));
                    pause
                else
                    break;
                end
            else
                disp('Nonempty Slice')
                if size(listTemp) == 1 then
                    listOutput($ + 1) = listTemp(1);
                    listInputBuffer = listTemp(1);
                    DuperPlot(listOutput($));
                    pause
                else
                    listInputBuffer = listTemp;
                    disp(size(listTemp));
                end
            end
        end
    end

endfunction

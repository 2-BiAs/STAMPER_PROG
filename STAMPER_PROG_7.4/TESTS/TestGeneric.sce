clear
clc
stacksize('max')

exec('SplitRadCompFromTip.sci');
exec('ExtendVector.sci');
exec('GetUnitNormal.sci');


mPoints = csvRead("POINTS_16001_160409.csv", ";");
mPoints(:,1) = -mPoints(:,1);

fDepthsOfCutFacet = [-0.085 .005 .020 .050]; //Depth of cut values starting at last pass and working back. The last value, fDepthsOfCut($), will repeat if max(iPassCounts) > length(fDepthsOfCut)
fDepthsOfCutWall = [-0.085 .005];
fZ_Clearance = .1;

fToolRad = .5; //mm
fToolAngle = 5; //deg

//Trim Start and End
mEndPoint = mPoints($,:);
mPoints = mPoints(5:$-1, :);

exec('PlotSurface.sce');

iGrooveCount = (size(mPoints, 1) - 1) / 2;
for i=1:iGrooveCount
    iGroovePassCount = 1;
    bPassesComplete = %F;
    vOffsetPointBuffer = mPoints(i * 2 - 1: i * 2 + 1, :);
    iStepToLastPass = 0;
    
    vWall = [mPoints(i * 2 - 1, 1) - mPoints(i * 2, 1), mPoints(i * 2 - 1, 2) - mPoints(i * 2, 2)];
    vFacet = [mPoints(i * 2 + 1, 1) - mPoints(i * 2, 1), mPoints(i * 2 + 1, 2) - mPoints(i * 2, 2)];
    
    vWallNorm = GetUnitNormal([mPoints(i * 2 - 1,:); mPoints(i * 2,:)]);
    vFacetNorm = GetUnitNormal([mPoints(i * 2,:); mPoints(i * 2 + 1,:)]);
    
    while ~bPassesComplete
        
        fW_DoC = fDepthsOfCutWall(min(iGroovePassCount, length(fDepthsOfCutWall)));
        vWallOffset = fW_DoC * vWallNorm;
        
        fF_DoC = fDepthsOfCutFacet(min(iGroovePassCount, length(fDepthsOfCutFacet)));
        vFacetOffset = fF_DoC * vFacetNorm;
                
        vOffsetVector = vWallOffset * (vFacet / norm(vFacet))' * (vFacet / norm(vFacet)) + vFacetOffset * (vWall / norm(vWall))' * (vWall / norm(vWall));
                
        vOffsetValley = vOffsetPointBuffer((iGroovePassCount + iStepToLastPass) * 3 - 1, :) + vOffsetVector;
        vOffsetValleyExt = ExtendVector([vOffsetPointBuffer((iGroovePassCount + iStepToLastPass) * 3 - 1, :); vOffsetValley], [0,fZ_Clearance; 1, fZ_Clearance]);
        
       
        vOffsetValleyExt = [vOffsetValleyExt(2, 1) - vOffsetValleyExt(1, 1), vOffsetValleyExt(2, 2) - vOffsetValleyExt(1, 2)];
        
        bExtIsShorter = sqrt(vOffsetValleyExt * vOffsetValleyExt') <= sqrt(vOffsetVector * vOffsetVector');
        
        if ~bExtIsShorter then

            vOffsetPointBuffer(iGroovePassCount * 3 - 2: iGroovePassCount * 3, 1:2)...
            = vOffsetPointBuffer((iGroovePassCount + iStepToLastPass) * 3 - 2: (iGroovePassCount + iStepToLastPass) * 3, 1:2)...
            + [vOffsetVector; vOffsetVector; vOffsetVector];

            iGroovePassCount = iGroovePassCount + 1;
            iStepToLastPass = -1;
        else
            Groove(i).OffsetArray = vOffsetPointBuffer;
            Groove(i).Count = iGroovePassCount - 1;
            bPassesComplete = %T
        end
        
    end
end

//vToolPathBuffer;
//Reorder Groove Points
iTotalGroovePassCount = 0;
for j = max(Groove(:).Count):-1:1
    printf("j = %f\n", j);
    iGroovesOnJ = 0;
    for i = 1:iGrooveCount
        if Groove(i).Count >= j then
            iGroovesOnJ = iGroovesOnJ + 1;
            iTotalGroovePassCount = iTotalGroovePassCount + 1;
            vToolPathBuffer($ + 1: $ + 3, 1:2) = Groove(i).OffsetArray(j * 3 - 2: j * 3, :);
            if i == 1 then  //On First Groove 
                fStartOffset = 0;
                for k = 1:j
                    if k <= length(fDepthsOfCutFacet) then
                        fStartOffset = fStartOffset + fDepthsOfCutFacet(k);
                    else
                        fStartOffset = fStartOffset + fDepthsOfCutFacet($);
                    end
                end
                if fStartOffset < fZ_Clearance then
                    vToolPathBuffer($+2,1:2) = vToolPathBuffer($,1:2)
                    vToolPathBuffer($-1:-1: $ - 2, 1:2) = ExtendVector(vToolPathBuffer($ - 3:-1: $ - 4, 1:2), [0, fStartOffset; -1, fStartOffset]); 
                    vToolPathBuffer($ - 3:-1: $ - 4, 1:2) = [0, fStartOffset; 0, fZ_Clearance];
                    plot(vToolPathBuffer($:-1: $ - 4, 1), vToolPathBuffer($: -1: $ - 4, 2), 'g-O');
                else
                    vToolPathBuffer($ - 1: -1: $ - 2, 1:2) = ExtendVector(vToolPathBuffer($ - 1:-1: $ - 2, 1:2), [0, fZ_Clearance; -1, fZ_Clearance]); 
                end
            elseif i == iGrooveCount then //On Last Groove
                vToolPathBuffer($ - 1: $, 1:2) = ExtendVector(vToolPathBuffer($ - 1 : $, 1:2), [0, fZ_Clearance; -1, fZ_Clearance]);
                vA = ExtendVector(vToolPathBuffer($ - 1:-1: $ - 2, 1:2), [0, fZ_Clearance; -1, fZ_Clearance]);
                if size(vToolPathBuffer, 1) > 3 & iGroovesOnJ > 1 then //If not the first groove in prog
                    vB = ExtendVector(vToolPathBuffer($ - 1:-1: $ - 2, 1:2), vToolPathBuffer($ - 4: $ - 3, 1:2));
                    
                    
                    if norm([vA(2, 1) - vA(1, 1), vA(2, 2) - vA(1, 2)]) < norm([vB(2, 1) - vB(1, 1), vB(2, 2) - vB(1, 2)]) then //| [vA(2, 1) - vA(1, 1), vA(2,2) - vA(1, 2)] * [0, -1]' > 0 then

                        vToolPathBuffer($ - 1:-1: $ - 2, 1:2) = vA;
                        plot(vToolPathBuffer($ - 1:-1: $ - 2, 1), vToolPathBuffer($ - 1:-1: $ - 2, 2), 'r-O');
                        
                        vToolPathBuffer($ - 4: $ - 3, 1:2) = ExtendVector(vToolPathBuffer($ - 4: $ - 3, 1:2), [0, fZ_Clearance; -1, fZ_Clearance]);
                        
                    else
                        vToolPathBuffer($ - 2:-1: $ - 3, 1:2) = vB;
                        vToolPathBuffer($ - 1, 1:2) = vToolPathBuffer($, 1:2);
                        vToolPathBuffer($, 1:2) = [,];
                    end
                else
                    vToolPathBuffer($ - 1:-1: $ - 2, 1:2) = vA;
                end
            else //On Grooves in Between
                vA = ExtendVector(vToolPathBuffer($ - 1:-1: $ - 2, 1:2), [0, fZ_Clearance; -1, fZ_Clearance]);
                if size(vToolPathBuffer, 1) > 3 & iGroovesOnJ > 1 then //If not the first groove in prog
                    vB = ExtendVector(vToolPathBuffer($ - 1:-1: $ - 2, 1:2), vToolPathBuffer($ - 4: $ - 3, 1:2));
                    
                    
                    if norm([vA(2, 1) - vA(1, 1), vA(2, 2) - vA(1, 2)]) < norm([vB(2, 1) - vB(1, 1), vB(2, 2) - vB(1, 2)]) then

                        vToolPathBuffer($ - 1:-1: $ - 2, 1:2) = vA;
                        plot(vToolPathBuffer($ - 1:-1: $ - 2, 1), vToolPathBuffer($ - 1:-1: $ - 2, 2), 'r-O');
                        
                        vToolPathBuffer($ - 4: $ - 3, 1:2) = ExtendVector(vToolPathBuffer($ - 4: $ - 3, 1:2), [0, fZ_Clearance; -1, fZ_Clearance]);
                        
                    else
                        vToolPathBuffer($ - 2:-1: $ - 3, 1:2) = vB;
                        vToolPathBuffer($ - 1, 1:2) = vToolPathBuffer($, 1:2);
                        vToolPathBuffer($, 1:2) = [,];
                    end
                else
                    vToolPathBuffer($ - 1:-1: $ - 2, 1:2) = vA;
                end
            end
        end
    end
end


sLineEndCode(1) = "F(P7)"; //Set Start Feed code
for i=1 + 1:size(vToolPathBuffer, 1)
//    printf("%f == %f — %s\n", vToolPathBuffer(i - 1, 2), vToolPathBuffer(i, 2),...
//    string((round(vToolPathBuffer(i - 1, 2) * 10^6)/10^6 == fZ_Clearance) & (round(vToolPathBuffer(i, 2)*10^6) / 10^6 == fZ_Clearance)));


    if (round(vToolPathBuffer(i - 1, 2) * 10^6)/10^6 == fZ_Clearance) & (round(vToolPathBuffer(i, 2)*10^6) / 10^6 == fZ_Clearance) then
        sLineEndCode(i) = "F(P8)";
    else
        sLineEndCode(i) = "F(P7)";
    end
end

xpoly(vToolPathBuffer(:, 1), vToolPathBuffer(:, 2)) //, 'm-.');
p=get("hdl");
p.polyline_style=4;

vT = [sin(fToolAngle * %pi / 180) -cos(fToolAngle * %pi / 180)];
compedToolPath = SplitRadCompFromTip(vToolPathBuffer, fToolRad, vT);

plot(compedToolPath(:, 1), compedToolPath(:, 2), 'b--')
xpoly(compedToolPath(:, 1), compedToolPath(:, 2)) //, 'b-.');
p=get("hdl");
p.polyline_style=4;
p.thickness = 1;
p.foreground=2

//sFileToSave = uigetfile("*.txt", directory, "Save Formatted Points As")
sFileToSave = "TEST_PRG.pgm"
fFile = mopen(sFileToSave, 'wt');
mfprintf(fFile, ";Facet DoC = %s\n ;Wall DoC = %s\n", string(fDepthsOfCutFacet), string(fDepthsOfCutWall));
mfprintf(fFile, ";Tool Rad = %f\n ;Tool Angle = %f\n ;Z Clearance Plane = %f\n\n\n\n", fToolRad, fToolAngle, fZ_Clearance);

sLineEndCode(1:$-1) = sLineEndCode(2:$);

for i=1:length(compedToolPath(:,1))
    mfprintf(fFile, "X%fZ%f", compedToolPath(i,1), compedToolPath(i,2));

    if i~=1
        if sLineEndCode(i) ~= sLineEndCode(i - 1) then
            mfprintf(fFile, "%s", sLineEndCode(i));
        end
    else
        mfprintf(fFile, "%s", sLineEndCode(i));    
    end
    
    if i ~= length(compedToolPath(:,1)) then
        mfprintf(fFile, "\n");
    end
end
mclose(fFile);



//for i = 1:size(vToolPathBuffer, 1)
////    
//end

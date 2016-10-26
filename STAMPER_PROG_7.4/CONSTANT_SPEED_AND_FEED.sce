clear; clc; stacksize('max'); //Set Working Directory
directory = uigetdir(pwd(), "Select Working Directoy");
b = chdir(directory);
realpath = cd(directory);

sFile = uigetfile("*.*", pwd(), "Select Points to Fix");
[sPath, sFileName, sExt] = fileparts(sFile);

u = mopen(sFile);

[n, a, x, b, z, p]=mfscanf(-1, u,'%c %g %c %g %s\n') //Scan formatted file

mclose(sFile)

cutData = [x, z];

///////////////////////////////////
//Edit these parameters if you want to
///////////////////////////////////

fSurfaceFPM = 300; //250; // ft/min
fStepOver = .025; // mm
fStepOverPlunging = .005; //mm
fRapidFeed = 250; //Rapid feed for cut time calculation

fStartRPM = 300; //RPM
fMaxRPM = 300; //RPM
fWaitForSpindleThreshold = 10; //RPM (If the spindle is commanded to change more than X RPMs in a given iteration, then call M81 to wait for the spindle to come to speed.

////////////////////////////////////
////////////////////////////////////

iRampStartRad = 285; //mm (integer number only)
fMaxRampRate = 1;   //RPM/mm

////////////////////////////////////
////////////////////////////////////

fTotalCutTime = [0];
fTotalDistance = [0];

bIsRamping = %T;
iLastRampRad = iRampStartRad;

fCurrentRPM = fStartRPM;
fPreviousRPM = fCurrentRPM;
j = 1;
winId=waitbar('Stitching in speeds and feeds');
progress = 0;
for i = 1:size(cutData, 1)
    if cutData(i, 1) ~= 0 & cutData(i, 1) < iRampStartRad then
        
        fRPM_ConstantSpeed = fSurfaceFPM / (.2618 * abs(cutData(i, 1)) * 2 / 25.4);
        
        fCurrentRPM = min(round(fRPM_ConstantSpeed), fMaxRPM);
        
        if abs(fCurrentRPM - fPreviousRPM) > fWaitForSpindleThreshold
            outputData(j) = msprintf('G81');
            j = j + 1;
        end
        fPreviousRPM = fCurrentRPM;
    end

    select p(i)
    case 'F(P9)' then
        outputData(j) = msprintf('X%1.6fZ%1.6f ' + p(i), [cutData(i, 1) cutData(i, 2)]);
        if i ~= 1 & i ~= size(cutData, 1)
            fCurrentDistance(i) = norm(cutData(i+1,1:2) - cutData(i, 1:2));
            fCurrentTime(i) = fCurrentDistance(i) / fRapidFeed;
            fTotalCutTime(i) = fTotalCutTime(i-1) + fCurrentTime(i);
            fTotalDistance(i) = fTotalDistance(i-1) + fCurrentDistance(i);
        end
    case 'F(P8)' then
        fFeedRate = fStepOverPlunging * fCurrentRPM;
        outputData(j) = msprintf('X%1.6fZ%1.6f S%dM04F%1.3f', [cutData(i, 1) cutData(i, 2), fCurrentRPM, fFeedRate]);
        if i ~= 1 & i ~= size(cutData, 1)
            fCurrentDistance(i) = norm(cutData(i+1,1:2) - cutData(i, 1:2));
            fCurrentTime(i) = fCurrentDistance(i) / fFeedRate;
            fTotalCutTime(i) = fTotalCutTime(i-1) + fCurrentTime(i);
            fTotalDistance(i) = fTotalDistance(i-1) + fCurrentDistance(i);
        end
    case 'F(P7)' then
        fFeedRate = fStepOver * fCurrentRPM;
        outputData(j) = msprintf('X%1.6fZ%1.6f S%dM04F%1.3f', [cutData(i, 1) cutData(i, 2), fCurrentRPM, fFeedRate]);
        if i ~= 1 & i ~= size(cutData, 1)
            fCurrentDistance(i) = norm(cutData(i+1,1:2) - cutData(i, 1:2));
            fCurrentTime(i) = fCurrentDistance(i) / fFeedRate;
            fTotalCutTime(i) = fTotalCutTime(i-1) + fCurrentTime(i);
            fTotalDistance(i) = fTotalDistance(i-1) + fCurrentDistance(i);
        end
    else
        outputData(j) = msprintf('ERROR READING FEEDRATE CODE');
        break;
    end
    
    j = j + 1; 
    progress = progress + 1;
    waitbar(progress/size(cutData, 1), winId);
end
close(winId);

sHeader($ + 1) = msprintf('Surface Speed = %d (SFM)', fSurfaceFPM);
sHeader($ + 1) = msprintf('Step-over = %1.3f (mm)', fStepOver);
sHeader($ + 1) = msprintf('Plunging Step-over = %1.3f (mm)', fStepOverPlunging);
sHeader($ + 1) = msprintf('Rapid Feed = %d (mm/min) (For cut time calc)', fRapidFeed);
sHeader($ + 1) = msprintf('Total Cut Time = %d (hr) = %1.2f (days)', [fTotalCutTime($) / 60, fTotalCutTime($) / 60 / 24]);
sHeader($ + 1) = '';
sHeader($ + 1) = '';
sHeader($ + 1) = '';
sHeader($ + 1) = '';

outputData = [sHeader; outputData];

csvWrite(outputData, 'CSSF_POINTS.txt');

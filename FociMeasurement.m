function [fociVols, fociNum, fociNum_norm, volCells]= FociMeasurement(folder, segPlots, timepoints, zSteps, fociThresholdScale, backgroundThreshScale, cellVolThresh, cellHoleThresh, minFociVox, maxFociVox, scrsz, saveSeg, stamp)
%% Adam Tyson | 22/11/2017 | adam.tyson@icr.ac.uk

%% get the first file
% bioformats should (usually) pick up all other files in the time series(if exported as OME-TIFF)
 cd(folder)
 fileDir=dir('*T00*.tif');
 file=fileDir.name;
 
%% Load and convert data 
disp('Loading data')
datacell = bfopen(file); %  load a single time point (3D), exported from slidebook
arraySize=[size(datacell{1,1}{1,1}) zSteps timepoints];
rawData=zeros(arraySize);
 for t=1:timepoints 
     for z=1:zSteps 
%          arrayPos=z+(t-1)*timepoints;
           arrayPos=z+(t-1)*zSteps;
           rawData(:,:,z,t)=double(datacell{1,1}{arrayPos,1}); % make a 4D array, x,y,z,t
     end
 end

%% Segment foci
disp('Segmenting foci')
[fociSegData, ~]=segFoci4D(rawData,'bi', fociThresholdScale, minFociVox, maxFociVox);

%% Display segmentation
switch segPlots
    case 'All' 
        % Calculate display size
        dispScale=(scrsz(4)/arraySize(1))*0.8;
        screenSize=[10 10 dispScale*arraySize(2) dispScale*arraySize(1)];
        
        for t=1:timepoints                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
            figTitle=[file '_TimePoint_' num2str(t)];
            doubleColorMap(rawData(:,:,:,t), fociSegData(:,:,:,t), screenSize,figTitle)
        end
        
    case 'MIP'
         % Calculate display size
         dispScale=(scrsz(4)/arraySize(1))*0.8;
         screenSize=[10 10 dispScale*arraySize(2) dispScale*arraySize(1)];
         figTitle=[file '_MIP'];
         
         rawMIP = squeeze(max(rawData, [], 3));
         segMIP = squeeze(max(fociSegData, [], 3));
         doubleColorMap(rawMIP, segMIP, screenSize,figTitle)
        
    otherwise  
end

%% analyse foci
disp('Analysing foci')
for t=1:timepoints
    fociProps(t) =analyseFoci(rawData(:,:,:,t), fociSegData(:,:,:,t));
end

%% normalise number of foci to cell volume
disp('Segmenting cells')
fociVols=zeros(timepoints,1);
fociNum_norm=zeros(timepoints,1);
fociNum=zeros(timepoints,1);
[cellSeg, volCells]=cellsegT0(rawData(:,:,:,1),backgroundThreshScale, cellVolThresh, cellHoleThresh);
for t=1:timepoints
    fociVols(t)=fociProps(t).meanVol;
    fociNum(t)=fociProps(t).numFoci;
    fociNum_norm(t)=volCells*fociProps(t).numFoci;
end

%% save segmentation files
     [~, file, ~]=fileparts(file);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  if strcmp(saveSeg, 'Yes')
    disp('Saving segmentation')
    for t=1:timepoints
        for frame=1:zSteps
            outfileFoci=['Foci_' file '_t_' num2str(t-1) '_' stamp '.tif'];
            imwrite(fociSegData(:,:,frame,t),outfileFoci, 'tif', 'WriteMode', 'append', 'compression', 'none');
        end      
    end
    
    for frame=1:zSteps
        outfileCell=['CellSegmentation_' file '_' stamp '.tif'];
        imwrite(cellSeg(:,:,frame),outfileCell, 'tif', 'WriteMode', 'append', 'compression', 'none');
    end 
        
end
end


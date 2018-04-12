 function [fociSegData, rawScaled] = segFoci4D(dataIn, thresholdMethod, thresholdScale, minFociVox, maxFociVox)
%% Adam Tyson | 22/11/2017 | adam.tyson@icr.ac.uk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input:
% dataIn - a 4D dataset (x,y, z, t) to be segmented as one (i.e. don't want different thresholds for different time points or z positions)
% thresholdMethod - 'uni' for unimodal (Rosin) or 'bi' for bimodal (Otsu) thresholding
% thresholdScale - a fudge factor to change the threshold
% minCellVox - minimum foci volume in pixels (lower than this are removed) - (uses bwarea open - relies on pixelidlist - slow)

% output:
% segFoci4D - a binary image of the segmented foci
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% prep data
for t=1:size(dataIn,4)
data.illumCorr(:,:,:,t)=illuminationCorr(dataIn(:,:,:,t)); % background illumination correction
data.sub=backSub3D(data.illumCorr); % remove background
end
rawScaled=(data.illumCorr-min(data.illumCorr(:)))/(max(data.illumCorr(:))-min(data.illumCorr(:)));

%% thresholding - with a fudge to increase or decrease
switch thresholdMethod
    case 'uni'
levelThresh=RosinThreshold2(rawScaled(:))*thresholdScale; %Rosin
% [~, levelThresh] = cutFirstHistMode(rawScaled,0); % not used at the moment - no curve fitting toolbox
    case 'bi'
        otsuThresholds=multithresh(rawScaled,4); % otsu
        levelThresh=otsuThresholds(2)*thresholdScale; %Otsu 
end
data.thresh=rawScaled;
data.thresh(data.thresh<levelThresh)=0;
data.thresh(data.thresh>0)=1;

%% clean up
if minFociVox~=0 % remove small objects
 data.smallRem=double(bwareaopen(data.thresh, minFociVox)); 
else
 data.smallRem=data.thresh;
end

if maxFociVox~=0 % remove large objects
 data.largeRemTemp=double(bwareaopen(data.smallRem, maxFociVox)); 
 data.largeRem=data.smallRem-data.largeRemTemp;
else
 data.largeRem=data.smallRem;
end

fociSegData=data.largeRem;
  end
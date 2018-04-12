function [cellsSeg, volCells]=cellsegT0(img, thresholdScale, cellVolThresh, cellHoleThresh)
%% Adam Tyson | 08/12/2017 | adam.tyson@icr.ac.uk
% function to segment out very low intensity cells at t=0

% input: img - 3D stack of cells, in which most of the dynamic range is
%              taken up by non cellular objects
%        thresholdScale - a fudge factor to change the threshold (should be
%        able to keep at 1)
%        cellVolThresh - min volume of "cells", below which they are removed 
%        cellHoleThresh - max volume of "holes" inside cells to be filled in" 

% output: cellsSeg - segmented image of cells
%         volCells - fraction of the 3D image taken up by cells

%% prep
data.sub=backSub3D(img);
sze=size(img);
filterWidth=round(0.004*sqrt(sze(1)*sze(2)));
data.smo = loop2dsmooth(img, filterWidth);
data.firstsub= bsxfun(@minus,data.smo, data.smo(:,:,1));
data.scaled=(data.firstsub-min(data.firstsub(:)))/(max(data.firstsub(:))-min(data.firstsub(:)));

%% threshold
[~, rosinThresh] = cutFirstHistMode(data.scaled,0);
threshold=rosinThresh*thresholdScale;
data.thresh=data.scaled;
data.thresh(data.thresh<threshold)=0;
data.thresh(data.thresh>0)=1;

%% tidy up 
data.opened=double(bwareaopen(data.thresh, cellVolThresh));%remove noise
data.fill=~bwareaopen(~data.opened, cellHoleThresh);   % fill in holes

%% values to return
cellsSeg=data.fill;
volCells=sum(data.fill(:))/numel(data.fill);
 end
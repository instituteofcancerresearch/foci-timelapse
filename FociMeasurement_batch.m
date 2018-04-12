 function FociMeasurement_batch
%% Adam Tyson | 30/11/2017 | adam.tyson@icr.ac.uk
% variables:
% fociThresholdScale - increase to include fewer foci, decrease to include more
% backgroundThreshScale - as above, but for the cells
% minFociVox - minimum foci volume in voxels (smaller than this are removed) (set to 0 to not run, and speed up (will likely double run time))
% maxFociVox - maximum foci volume in voxels (bigger than this are removed) (set to 0 to not run, and speed up (will likely double run time))
% cellVolThresh - min volume of "cells", below which they are removed 
% cellHoleThresh - max volume of "holes" inside cells to be filled in" 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N.B 
% t & z need to be specified - not correct in OME metadata
% doesn't scale well - takes 8.4 hours for a 2048x2048x31x25 image

%% to do 
% add an option to segment foci separately based on intensity - give a few
% groups of foci- and analyse these groups individually
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

%% User inputs
topFolder = uigetdir('', 'Choose directory containing all time series');

% variables
disp('Higher thresholds = fewer foci/smaller cells')
prompt = {'Number of timepoints:','Number of z steps:', 'Foci threshold (a.u.)', 'Cell threshold (a.u.)', 'Minimum foci volume (voxels)', 'Maximum foci volume (voxels)','Cell volume threshold (voxels)', 'Cell fill threshold (voxels)'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'17','28', '1.0', '1', '5', '1000', '2000', '200'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
timepoints=str2double(answer{1});
zSteps=str2double(answer{2});
fociThresholdScale=str2double(answer{3});
backgroundThreshScale=str2double(answer{4});
minFociVox=str2double(answer{5});
maxFociVox=str2double(answer{6});
cellVolThresh=str2double(answer{7});
cellHoleThresh=str2double(answer{8});

% which plots
   % 'All' - will display a figure for every time point, allowing viewing of segmentation at every z
   % 'MIP' - will display a MIP for every time point, allowing an overview of segmentation
   % 'None' (or anything else) - no segmentation vis
segPlots = questdlg('Which foci segmentation plots to display?', ...
	'Plot choices', ...
	'All','MIP','None', 'None');

scrsz = get(0,'ScreenSize');

saveSeg = questdlg('Save segmentation results?', ...
	'Segmentation saving', ...
	'Yes', 'No', 'No'); 

saveResults = questdlg('Save results as .csv?', ...
	'Results saving', ...
	'Yes', 'No', 'Yes'); 
%% choose the files to send to FociMeasurement.m
files=dir(topFolder);
dirFlags = [files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..'); % remove the '.' and '..' directories (if returned) from the list of directories (rather than files)
subFolderList = files(dirFlags); % select directories of interest

numTimeSeries=length(subFolderList);

%% prep output if needed
if strcmp(saveResults, 'Yes')
    
fociVols=zeros(timepoints , numTimeSeries+1);
fociVols(:,1)=1:timepoints;

fociNum_norm=zeros(timepoints , numTimeSeries+1);
fociNum_norm(:,1)=1:timepoints;

fociNum=zeros(timepoints , numTimeSeries+1);
fociNum(:,1)=1:timepoints;

volCells=zeros(numTimeSeries);

resultsArray_fociVols=cell(1, numTimeSeries); % intialise cell array for speed
resultsArray_fociNum_norm=cell(1, numTimeSeries); 
resultsArray_fociNum=cell(1, numTimeSeries); 

resultsArray_fociVols{1,1}='Foci Volume (in voxels)';
resultsArray_fociNum_norm{1,1}='Normalised foci number';
resultsArray_fociNum{1,1}='Foci number';
resultsArray_cellVol{1,1}='T=0 cell volume (fraction of FOV)';

resultsArray_fociVols{4,1}='Timepoint';
resultsArray_fociNum_norm{4,1}='Timepoint';
resultsArray_fociNum{4,1}='Timepoint';
end

stamp=num2str(fix(clock)); % date and time 
stamp(stamp==' ') = '';%remove spaces
 
%% run analysis
progressbar('Analysing time series') % Init prog bar
for i=1:numTimeSeries
    subFolderIn = subFolderList(i).name;
    folderInput=fullfile(topFolder, subFolderIn);
    disp(['Analysing series: ' subFolderIn])
    
    if strcmp(saveResults, 'Yes')
    resultsArray_fociVols{4,i+1}=subFolderIn;
    resultsArray_fociNum_norm{4,i+1}=subFolderIn;
    resultsArray_fociNum{4,i+1}=subFolderIn;
    resultsArray_cellVol{4,i+1}=subFolderIn;

    end

    [fociVols(:,i+1), fociNum(:,i+1), fociNum_norm(:,i+1),volCells(i)]= FociMeasurement(folderInput, segPlots, timepoints, zSteps, fociThresholdScale, backgroundThreshScale, cellVolThresh, cellHoleThresh, minFociVox, maxFociVox, scrsz, saveSeg, stamp);    
        resultsArray_cellVol{5,i+1}=volCells(i);
    
    % progress bar
        frac1 = i/numTimeSeries;
        progressbar(frac1)
        
    disp(' ');
end

%% save outputs
if strcmp(saveResults, 'Yes')
    disp('Saving results')

resultsArray_fociVols=[resultsArray_fociVols; num2cell(fociVols)];
resultsArray_fociNum_norm=[resultsArray_fociNum_norm; num2cell(fociNum_norm)];
resultsArray_fociNum=[resultsArray_fociNum; num2cell(fociNum)];

cd(topFolder);
% for osx compatability
focinumTable=cell2table(resultsArray_fociNum);
writetable(focinumTable, ['Foci_number_' stamp '.csv'])
FocinumnormTable=cell2table(resultsArray_fociNum_norm);
writetable(FocinumnormTable, ['Foci_number_normalised_' stamp '.csv'])
CellvolTable=cell2table(resultsArray_cellVol);
writetable(CellvolTable, ['Cell_volume_' stamp '.csv'])
FociVolTable=cell2table(resultsArray_fociVols);
writetable(FociVolTable, ['Foci_volume_' stamp '.csv'])
end
%%
disp(['Time elapsed: ' num2str(toc) ' seconds'])

end
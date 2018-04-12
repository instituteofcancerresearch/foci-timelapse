# foci-timelapse
 Adam Tyson | 08/12/2017 | adam.tyson@icr.ac.uk



To analyse changes in foci number and size over time in 3D. N.B requires MATLAB 2017b and the Image Processing, Statistics and Machine Learning and Curve Fitting toolboxes.
 
 Instructions:
 
 1 - Export as OME-TIFF, each timeseries into its own directory. Keep all options as default. 
 
 2- Unzip foci-timelapse-master and place in the MATLAB path (e.g. C:\Users\User\Documents\MATLAB). 
 
 3- Open foci-timelapse-master\FociMeasurement_batch and run (F5 or the green "Run" arrow under the "EDITOR" tab).
 
 4- Choose a directory that contains subdirectories, each containing one time series.
 
 5a- Confirm number of timepoints and z steps are correct. 
 
 5b- Adjust thresholds if necessary 
 
        Foci threshold - decrease to include more foci, increase to reduce number of foci.
        
        Cell threshold - increase to be more stringent on what is a cell (for foci normalisation purposes).
        
        Minimum foci volume - any detected "foci" below this volume (i.e. not real foci) will be removed. Set as 0 to not run.
        
        Maximum foci volume - any detected "foci" above this volume (i.e. not real foci) will be removed. Set as 0 to not run.
        
        Cell volume threshold - any "cells" below this volume will be removed
        
        Cell fill threshold - any "holes" inside a cell below this volume will be "filled in"
        
 6. Choose which plots to display
 
        All - plots a 3D image of the detected foci, overlaid on the raw image. One 3D image for each time point (use only for 
        determining parameters)
        
        MIP - shows a maximum intensity projection of the detected foci, overlaid on the raw image, allowing scrolling through the timepoints
        
7. Choose whether to save segmentation as TIFFs (one 3D image for each time point (foci) and one t=0 cell image).

8. Choose whether to save results as .xls. Will write an excel file containing the number of foci (raw and normalised to volume of cells) and the mean foci volume for each timepoint in each time series. The volume of cells at t=0 will also be saved.

 
The script will then loop through all the directories in the chosen folder, analysing time series and writing results. The segmentation images will be saved in each time series directory, and the excel results will be saved in the chosen main directory.


Once the first time series has been analysed, the progress bar will give an estimate of the remaining time.
 

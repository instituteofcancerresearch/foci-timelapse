 function fociProps =analyseFoci(rawIm, segIm)
%% Adam Tyson | 29/11/2017 | adam.tyson@icr.ac.uk
 % use regionprops3 (needs 2017b), and extract information from the segmented foci, and
% also use the binary image to mask the raw, and get info such as intensity from these

% usage: fociProps =analyseFoci(rawData(:,:,:,15), fociSegData(:,:,:,15));
% input: rawIm - 3D, non masked greyscale image with foci
%        segIm - binary (not necessarily logical) image of segmented foci

% output: fociProps - a structure of properties averaged across the 3D image (e.g. for comparison across timepoints)


% separate signal into foci and not
signalInFoci=rawIm.*segIm;
signalOutsideFoci=rawIm.*~segIm;

rawProps = regionprops3(logical(segIm), rawIm,"Volume", "SurfaceArea", "MaxIntensity", "MeanIntensity", "MinIntensity"); % need to make seg image logical if not already

% binary foci properties
fociProps.numFoci=length(rawProps.Volume);
fociProps.meanVol=mean(rawProps.Volume);
fociProps.meanSA=mean(rawProps.SurfaceArea);
fociProps.meanSAtoVol=mean(rawProps.SurfaceArea./rawProps.Volume);

% greyscale foci properties
fociProps.meanMaxInt=mean(rawProps.MaxIntensity);
fociProps.meanMeanIntensity=mean(rawProps.MeanIntensity);
fociProps.meanMinIntensity=mean(rawProps.MinIntensity);

% general properties
fociProps.signalInVsOut=sum(signalInFoci(:))./sum(signalOutsideFoci(:));
end
function corrImage=illuminationCorr(img)
%% Adam Tyson | 23/11/17 | adam.tyson@icr.ac.uk

% corrects image for uneven illumination without a reference image -takes an image stack, sums over Z, smooths, 
%then uses that to correct for illuminaion

sze=size(img);
gaussSize=0.2*(sqrt(sze(1)*sze(2)));
imref=sum(img(:,:,:),3); % get sum over all z
imref=imgaussfilt(imref,gaussSize); % smooth
corrImage=bsxfun(@rdivide,img,imref); % element wise division
end
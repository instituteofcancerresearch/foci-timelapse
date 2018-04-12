function backgroundSubtractIm=backSub2D(img)
% partially based on segmentNucleii.m by Danuser lab
% removes background on a 2D image
%% Adam Tyson 11/11/2016 -- adamltyson@gmail.com
%%
sze=size(img);
filterWidth=0.1*sqrt(sze(1)*sze(2));

%remove noise by filtering image with a Gaussian whose sigma = 1 pixel
imageFiltered = filterGauss2D(img,1);

%estimate background by filtering image with a Gaussian whose sigma is
%proportional to image size 
imageBackground = filterGauss2D(img,filterWidth);

%calculate noise-filtered and background-subtracted image
imageFilteredMinusBackground = imageFiltered - imageBackground;
imageDilated = imageFilteredMinusBackground;
backgroundSubtractIm=imageDilated;
end


function outIm=backSub3D(im)
% function to background subtract slice by slice on 3d images (just calls a
% function slice by slice
%% Adam Tyson 12/10/2016 -- adamltyson@gmail.com

outIm=zeros(size(im));
for z=1:size(im,3)
 outIm(:,:,z)=backSub2D(im(:,:,z));
end
 

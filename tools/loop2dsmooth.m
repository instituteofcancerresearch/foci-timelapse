function smoothed=loop2dsmooth(img, filterWidth)
smoothed=zeros(size(img));
for z=1:size(img,3)
smoothed(:,:,z) = filterGauss2D(img(:,:,z),filterWidth);
end
end

%% doubleColorMap.m
%% Adam Tyson 17/11/17 adam.tyson@icr.ac.uk
% takes 2 3D images (a greyscale raw, and a binary segmented one) and
% overlays them (binary image in magenta)

%% to do - add scaling for the raw image (incase foci are very bright)
 function doubleColorMap(rawImage, overlayBinary, screenSize,figTitle)
%% testing
% rawImage=rawData(:,:,:,15);
% overlayBinary=fociSegData(:,:,:,15);
%%
raw8=uint8(rawImage/256); %scale and convert raw image to 8bit
seg8=overlayBinary;
seg8(seg8==1)=255; % scale
seg8=uint8(seg8); 
rgb8=cat(4, raw8, raw8, raw8); % add raw image to all 3 channels (making a greyscale background)
rgb8(:,:,:,1)=rgb8(:,:,:,1)+seg8; % add the segmented channel to the blue and red (making magenta)
rgb8(:,:,:,3)=rgb8(:,:,:,1)+seg8;
figure('position', screenSize,'Name',figTitle)
imshow3D(rgb8) % call function to display (needs to be newest version, which accepts RGB as well as greyscale)
 end

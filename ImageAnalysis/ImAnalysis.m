%% 

clear all
close all
clc

BFIm = im2gray(imread('s01c1.tif'));                %Read the brightfield image
FluoIm = uint16(im2gray(imread('s01c2.tif')));      %Read the fluorescence image, convert to grayscale and uInt16
       
    
figure()
imshow(BFIm)
hold on


[xcenter,ycenter] = ginput(1);         %Click on the center of the button valve   
inner_rad = 140;                       %Adjust inner and outer radii accoding to acquisiton parameters
outer_rad = 205;

% viscircles([xcenter,ycenter],inner_rad)  
% viscircles([xcenter,ycenter],outer_rad,'Color','b')


[x,y] = meshgrid(1:size(FluoIm,2),1:size(FluoIm,1));
distance = (x-xcenter).^2 + (y-ycenter).^2;
mask = distance<outer_rad^2 & distance>inner_rad^2;     %Create the background mask
mask(mask > 0) = 1;
mask = im2uint16(mask);
maskedim=FluoIm.*mask;
% figure()
% imshow(maskedim)
val=find(mask);
bkgInt= mean(maskedim(val))                             %Obtain the mean intensity of the background                          
   

[x,y] = meshgrid(1:size(FluoIm,2),1:size(FluoIm,1));    %Create the spot mask
distance = (x-xcenter).^2+(y-ycenter).^2;
mask = distance<inner_rad^2;
mask(mask > 250) = 1;
mask = im2uint16(mask);
maskedim2=FluoIm.*mask;
% figure()
% imshow(imadjust(maskedim2))
val=find(mask);
spotInt= mean(maskedim2(val))                           %Obtain the mean intensity of the spot

Intensity = spotInt-bkgInt                              %Subtract the background intensity from the spot intensity
      

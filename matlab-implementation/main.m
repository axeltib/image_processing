clear all;

% images to choose from (for simplicity)
%dark_stockholm.jpg  
%overexposed_stockholm.jpg  
%overexposed_water.jpg  
%rainy_green.jpg  
%rainy_red.jpg  
%street.jpg  
%tellus_tower.jpg
files = dir('images');
fileNames = {files.name};
fileNames = fileNames(3:length(fileNames));  % exclude . and ..

imFile='images/' + string(fileNames(19));
I = imread(imFile); % Read image

R = I(:,:,1); 
G = I(:,:,2); 
B = I(:,:,3);

% transform image to the HSV colour space
imageHSV = rgb2hsv(I);
hue = imageHSV(:,:,1);
sat = imageHSV(:,:,2);
val = imageHSV(:,:,3);

% and to grayscale
imageGray = rgb2gray(I);

%%

imshow(hsv2rgb(imageHSV));

%% SMQT
graySMQT = uint8(rescale(smqt(imageGray), 0, 255));
graySSR = ssr(imageGray, 80);
imshow([imageGray graySMQT graySSR smqt(graySSR)]);

%valHSV = smqt(val);
%imageHSV(:,:,3) = rescale(double(valHSV), 0, 1);
%imageProcessed = hsv2rgb(imageHSV);
%imshow([I, imageProcessed]);

%% Define scales
c = 80;
sigmas = [1, 30, 80, 120];  % Sigma for the different Gaussians
w = [0.4, 0.2, 0.1, 0.01];  % Scales

imageMSRCRNight = msrcrNight(I, sigmas, w);
imageMSRCR = msrcr(I, sigmas, w);
imshow([I imageMSRCRNight imageMSRCR]);

%% Combine images
total_image = [I ssr(I, c); msr(I, sigmas, w) msrcr(I, sigmas, w)];
imshow(total_image);

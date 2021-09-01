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

saveDir = 'processed_images';  %where processed images are saved

% imFile='images/' + string(fileNames(1));
imFile = 'images/tellus_tower.jpg';
[placeholder, imageName, imageExtension] = fileparts(imFile);
imageName = string(imageName);
imageExtension = string(imageExtension);

I = imread(imFile); % Read image

if size(I,3) ~= 1  % image is already gray
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
else
    imageGray = I;
end

%% Define scales
c = 80;
sigmas = [1, 30, 80, 120];  % Sigma for the different Gaussians
w = [0.01, 0.01, 0.1, 0.3];  % Scales

%% Gray image
graySMQT = uint8(rescale(smqt(imageGray), 0, 255));
graySSR = ssr(imageGray, 80);
graySSRSMQT = smqt(graySSR);
grayMSRCRNight = msrcrNight(imageGray, sigmas, w);
grayMSRCR = msrcr(imageGray, sigmas, w);

imwrite(imageGray, append(saveDir,'/',imageName,'/original',imageExtension));
imwrite(graySMQT, append(saveDir,'/',imageName,'/graySMQT',imageExtension));
imwrite(graySSR, append(saveDir,'/',imageName,'/graySSR',imageExtension));
imwrite(graySSRSMQT, append(saveDir,'/',imageName,'/graySMQTSSR',imageExtension));
imwrite(grayMSRCRNight, append(saveDir,'/',imageName,'/grayMSRCRNight',imageExtension));
imwrite(grayMSRCR, append(saveDir,'/',imageName,'/grayMSRCR',imageExtension));

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

%% Save image


function R = msrcrNight(I, sigmas, weights)
%MSR Multi scale retinex method with colour correction

R = zeros(size(I));  % Initialize output tensor
I = double(I);  % Make compatible with the log operation
I(I == 0) = 0.01;
alpha = I ./ sum(I, 3);  % create colour correction tensor
k = 0.001;
% Initialise scales and sigmas for Gaussian
%sigmas = [1, 20, 100];  % Sigma for the different Gaussians
%w = [0.05, 0.2, 0.5];  % Scales

% Iterate over the spectral channels/bands of the image, usually three
for i = 1:size(I, 3)
    spectral_band_i = I(:,:,i);
    Ri = zeros(size(spectral_band_i));
    
    for j = 1:size(sigmas, 2)
        Li = imgaussfilt(spectral_band_i, sigmas(j));
        Li(Li == 0) = 0.01;
        Ri = Ri + weights(j) * (sigCustom(spectral_band_i,k) - sigCustom(Li,k));
    end
    Ri = Ri .* alpha(:,:,i);
    R(:,:,i) = rescale(exp(Ri), 0, 255);
end

R = uint8(R);
end
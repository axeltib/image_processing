function R = msr(I, sigmas, weights)
%MSR Multi scale retinex method

R = zeros(size(I));  % Initialize output tensor
I = double(I);  % Make compatible with the log operation

% Initialise scales and sigmas for Gaussian
%sigmas = [1, 20, 100];  % Sigma for the different Gaussians
%w = [0.05, 0.2, 0.5];  % Scales

% Iterate over the spectral channels/bands of the image, usually three
for i = 1:size(I, 3)
    spectral_band_i = I(:,:,i);
    spectral_band_i(spectral_band_i == 0) = 0.01;   % Make log friendly :)
    
    Ri = zeros(size(spectral_band_i));
    
    for j = 1:size(sigmas, 2)
        Li = imgaussfilt(spectral_band_i, sigmas(j));
        Li(Li == 0) = 0.01;
        Ri = Ri + weights(j) * (log(spectral_band_i) - log(Li));
    end

    R(:,:,i) = rescale(exp(Ri), 0, 255);
end
 
R = uint8(R);
end


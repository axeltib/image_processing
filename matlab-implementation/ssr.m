function R = ssr(I, c)
%SSR Single scale retinex method

if nargin == 1
    c = 80;
end

R = zeros(size(I));
I = double(I);

for i = 1:size(I, 3)
    spectral_band_i = I(:,:,i);
    spectral_band_i(spectral_band_i == 0) = 0.01;  %avoid log singularities
    % TODO test instead with log(1 + x);
    Li = imgaussfilt(spectral_band_i, c);
    Li(Li == 0) = 0.01;                            %avoid log singularities

    Ri = exp(log(spectral_band_i) - log(Li));
    R(:,:,i) = rescale(Ri, 0, 255);
end
 
R = uint8(R);
end

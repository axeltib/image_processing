function M = smqt(D, curLayer, totLayers)
%Performing successive mean quantization on a single channeled image
% Input D: Image channeled that is to be processed
% Output M: uint8 processed image with range from 0 to 255

if nargin == 1
    % Most standard initial settings for 8-bit images (jpg for isntance)
    curLayer = 1;
    totLayers = 8;
end

% Define variables
D = double(D);
avgD = mean(D, [1,2], 'omitnan');
D0 = D;
D1 = D;

% Set filtered values to nan to differentiate from 0
D0(D0 > avgD) = nan; 
D1(D1 <= avgD) = nan;

% M will have the same "shape" as D1
M = not(isnan(D1)) * 2^(totLayers-curLayer);

if curLayer == totLayers  % Bottom of the tree is hit, return M as is
   return; 
end

% Else, call smqt with D0 and D1 and add to M
M = M + smqt(D0, curLayer+1, totLayers) + smqt(D1, curLayer+1, totLayers);
if curLayer == 1
    M = uint8(M);
end
end

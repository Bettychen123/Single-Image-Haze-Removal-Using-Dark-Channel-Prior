function q = JG_guidedfilter(I, p, r, eps)
%   GUIDEDFILTER   O(1) time implementation of guided filter.
%
%   - guidance image: I (should be a gray-scale/single channel image)
%   - filtering input image: p (should be a gray-scale/single channel image)
%   - local window radius: r
%   - regularization parameter: eps

[hei, wid] = size(I);
N = boxfilter(ones(hei, wid), r); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.

% imwrite(uint8(N), 'N.jpg');
% figure,imshow(N,[]),title('N');

L=256;
mean_I = boxfilter(I, r) ./ N;
mean_p = boxfilter(p, r) ./ N;
mean_Ip = boxfilter(I.*p, r) ./ N;
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.

mean_II = boxfilter(I.*I, r) ./ N;
var_I = mean_II - mean_I .* mean_I;%窗口为k的情况下每个像素的方差

mean_I2 = boxfilter(I,1) ./ N;
mean_II2=boxfilter(I.*I,1) ./ N;
var_I2=mean_II2-mean_I2 .* mean_I2;
Q=(var_I+(0.001*L))./(var_I2+(0.001*L));%按照论文中的公式
s=0;
for i=1:hei
    for j=1:wid
        s=s+Q(i,j);
    end
end
s=s/hei*wid;
a = cov_Ip ./ (var_I + eps/s); % Eqn. (5) in the paper;
b = mean_p - a .* mean_I; % Eqn. (6) in the paper;

mean_a = boxfilter(a, r) ./ N;
mean_b = boxfilter(b, r) ./ N;

q = mean_a .* I + mean_b; % Eqn. (8) in the paper;
end
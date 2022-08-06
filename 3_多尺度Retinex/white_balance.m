% We adjusted the general_cc.m in [52] only for white balance computation. 
%    
% INPUT :
%   I    : color input image (NxMx3)
%	mink_norm     : minkowski norm used (if mink_norm==-1 then the max
%                   operation is applied which is equal to minkowski_norm=infinity).
% OUTPUT: 
%   [white_R,white_G,white_B]           : illuminant color estimation
%   output_data                         : color corrected image

% LITERATURE :%
% J. van de Weijer, Th. Gevers, A. Gijsenij
% "Edge-Based Color Constancy"
% IEEE Trans. Image Processing, accepted 2007.
%
% The paper includes references to other Color Constancy algorithms
% included in general_cc.m such as Grey-World, and max-RGB, and
% Shades-of-Gray.

function [white_R ,white_G ,white_B,output_data] = white_balance(I,mink_norm)

I = abs(double(I));
mask_im1    = ones(size(I,1),size(I,2));
mask_im2    = set_border(mask_im1,1,0);
% the mask_im2 contains pixels higher saturation_threshold and which are
% not included in mask_im.

output_data=I;
    kleur   = power(I,mink_norm); 
    white_R = power(sum(sum(kleur(:,:,1).*mask_im2)),1/mink_norm);
    white_G = power(sum(sum(kleur(:,:,2).*mask_im2)),1/mink_norm);
    white_B = power(sum(sum(kleur(:,:,3).*mask_im2)),1/mink_norm);

    som=sqrt(white_R^2+white_G^2+white_B^2);

    white_R=white_R/som;
    white_G=white_G/som;
    white_B=white_B/som;

output_data(:,:,1)=output_data(:,:,1)/(white_R* 1.7321);
output_data(:,:,2)=output_data(:,:,2)/(white_G* 1.7321);
output_data(:,:,3)=output_data(:,:,3)/(white_B* 1.7321);
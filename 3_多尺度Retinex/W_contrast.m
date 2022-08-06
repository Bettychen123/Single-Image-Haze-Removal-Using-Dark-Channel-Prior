% W_con: Contrast weight map
function W_con = W_contrast(I)
    N                   = size(I,4);
    contrast_window     = fspecial('gaussian',7,7/6);
    contrast_window     = contrast_window/sum(sum(contrast_window));   
    warning('off');
    W_con               = zeros(size(I,1),size(I,2),N);
    for i = 1:N    
        Ig              = double(rgb2gray(uint8(I(:,:,:,i))));        
        mu              = imfilter(Ig,contrast_window,'replicate');
        mu_sq           = mu.*mu;
        sigma           = sqrt(abs(imfilter(Ig.*Ig,contrast_window,'replicate') - mu_sq));
        W_con(:,:,i)    = sigma./(max(max(sigma)));
        clear Ig mu mu_sq sigma;
    end
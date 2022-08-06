% W_lum: Fog aware luminance weight map
function W_lum = W_luminance(I, fi_intensity_RGB)
    sig         = 0.2;
    N           = size(I,4);
    W_lum       = zeros(size(I,1),size(I,2),N);
    for i = 1:N
        ER      = exp(-.5*((double(I(:,:,1,i)) - fi_intensity_RGB(1))./255).^2/sig.^2);
        EG      = exp(-.5*((double(I(:,:,2,i)) - fi_intensity_RGB(2))./255).^2/sig.^2);
        EB      = exp(-.5*((double(I(:,:,3,i)) - fi_intensity_RGB(3))./255).^2/sig.^2);       
        W_lum(:,:,i) = ER.*EG.*EB;
        clear ER EG EB
    end
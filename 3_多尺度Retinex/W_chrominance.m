% W_chr using chrominance
function W_chr = W_chrominance(I)
    N           = size(I,4);
    W_chr       = zeros(size(I,1),size(I,2),N);
    for i = 1:N
        % chrominance is computed as the standard deviation of the color channels
        R       = double(I(:,:,1,i));
        G       = double(I(:,:,2,i));
        B       = double(I(:,:,3,i));
        Ig      = 0.299*R + 0.587*G + 0.114*B;
        C       = sqrt(((R - Ig).^2 + (G - Ig).^2 + (B - Ig).^2)/3);
        W_chr(:,:,i) = C;
        clear R G B Ig
    end
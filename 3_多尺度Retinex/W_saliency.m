% Saliency using [53]
function W_sal = W_saliency(I)
     N                  = size(I,4);
     W_sal              = zeros(size(I,1),size(I,2),N);
     binominal_kernel   = [1 4 6 4 1]'*[1 4 6 4 1]/(16*16);       
     for i=1:N       
         gfrgb          = (imfilter(uint8(I(:,:,:,i)), binominal_kernel, 'symmetric', 'conv'));    
         % Perform sRGB to CIE Lab color space conversion       
         cform          = makecform('srgb2lab');
         lab            = applycform(gfrgb,cform);     
         % Compute Lab average values (note that in the paper this
         % average is found from the unblurred original image, but% the results are quite similar
         l              = double(lab(:,:,1)); lm = mean(mean(l));
         a              = double(lab(:,:,2)); am = mean(mean(a));
         b              = double(lab(:,:,3)); bm = mean(mean(b));       
         % Finally compute the saliency map and display it.      
         W_temp         = (l-lm).^2 + (a-am).^2 + (b-bm).^2;
         W_sal(:,:,i)   = W_temp;   
         clear gfrgb l a b lm am bm W_temp
     end
  
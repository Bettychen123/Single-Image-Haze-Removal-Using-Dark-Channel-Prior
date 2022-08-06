% W_sat using saturation in HSV
function W_sat = W_saturation(I)
     N                  = size(I,4);
     W_sat              = zeros(size(I,1),size(I,2),N);
     for i=1:N        
         Ihsv           = rgb2hsv(I(:,:,:,i));
         S              = Ihsv(:,:,2);                  
         Sfogfree       = 1; 
         W_temp         = exp(-((S-Sfogfree).^2)./(2*0.3^2));     
         W_sat(:,:,i)   = W_temp;
         clear Ihsv S W_temp;
     end
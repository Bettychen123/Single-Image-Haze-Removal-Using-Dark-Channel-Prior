function [Defogged_I] = DEFADE(I)
    % Input: foggy image, I
    % Output: defogged image
    % Detail explanation:
    % L. K. Choi, J. You, and A. C. Bovik, "Referenceless Prediction of Perceptual Fog Density and Perceptual Image Defogging",
    % IEEE Transactions on Image Processing, to appear (2015).
       
   %% Basic setup         
        [row col dim]                   = size(I);         
        Ig                              = double(rgb2gray(I));                    
        R                               = double(I(:,:,1));
        G                               = double(I(:,:,2));
        B                               = double(I(:,:,3));
        L                               = (R+G+B)/3; 
      
    %% Execute FADE using 8 x 8 overlapped patches           
        [D_o D_map_o]                   = FADE_overlapped(I);
        
    %% Perceputal fog density weight map
        % reduce noise of D_map using the guided filter
        guided_filter_r                 = floor(min(size(R))/10);  % guided filter parameter, r
        guided_filter_eps               = 0.0001;                  % guided filter parameter, eps 
        D_map_guided_temp               = guidedfilter(double(Ig),D_map_o,guided_filter_r,guided_filter_eps);         
        check_guided_filter             = sum(double(isnan(D_map_guided_temp(:))));
        if check_guided_filter==0             
             D_map_guided               = D_map_guided_temp - min(min(D_map_guided_temp));  % scale to remove negative values 
             D_map_guided_N             = D_map_guided./(max(max(D_map_guided)));           % scale to [0 1]
             D_map_1                    = 1 - D_map_guided_N;
             D_map_2                    = D_map_guided_N;
             D_map_3                    = (D_map_1.*D_map_2)./(max(max((D_map_1.*D_map_2)))); % scale to [0 1]   
             W_fog(:,:,1)               = D_map_1; W_fog(:,:,2) = D_map_2; W_fog(:,:,3) = D_map_3;             
        else             
             W_fog                      = ones(row, col, 3); % For the just in case when the guided filter does not work.
        end 
        
%% Preprocessed images
      % I1, White balanced image                                                
        [wR, wG, wB, I1]                = white_balance(double(I),6);      
      % I2: Mean subtracted contrast enhancement                  
        I2                              = uint8(2.5*(double(I)-mean2(L)));    
      % I3: Fog aware contrast enhancement  
            % Find the index that makes the largest average between I2 and I3 using the D_map 
            Rfi=R; Gfi=G; Bfi=B;       
            for i=1:50
                temp_percent            = 0.01*i; 
                fi = find(D_map_2< temp_percent); 
                fi_intensity_RGB(1)     = mean(Rfi(fi));                                        
                fi_intensity_RGB(2)     = mean(Gfi(fi));                                        
                fi_intensity_RGB(3)     = mean(Bfi(fi));                                       
                fi_intensity            = mean([Rfi(fi); Gfi(fi); Bfi(fi)]); 
                fi_diff(i)              = mean2(L) - fi_intensity;
                clear fi fi_intensity_RGB fi_intensity    
            end         
            opt_i                       = find(fi_diff == max(fi_diff));
            opt_percent                 = 0.01*min(opt_i);
            fi                          = find(D_map_2< opt_percent);         
            % Least-free region's mean at R, G, B each channel and for all channel                  
            fi_intensity_RGB(1)         = mean(Rfi(fi));                                        
            fi_intensity_RGB(2)         = mean(Gfi(fi));                                        
            fi_intensity_RGB(3)         = mean(Bfi(fi));                                       
            fi_intensity                = mean([Rfi(fi); Gfi(fi); Bfi(fi)]);                 
        I3                              = uint8(2.5*(double(I)-fi_intensity));
      % Combine as one input variable: Pre_I         
        Pre_I(:,:,:,1) = double(I1); Pre_I(:,:,:,2)=double(I2); Pre_I(:,:,:,3)=double(I3); 
      % number of preprocessed images
        N                               = size(Pre_I,4);             
                
%% Weight maps
      % 1. Chrominance
        W_chr                           = W_chrominance(Pre_I);           
      % 2. Saturation
        W_sat                           = W_saturation(Pre_I);    
      % 3. Saliency 
        W_sal                           = W_saliency(Pre_I);            
      % 4. Perceputal fog density was computed above   
      % 5. Fog aware luminance   
        W_lum                           = W_luminance(Pre_I, fi_intensity_RGB);                       
      % 6. Contrast
        W_con                           = W_contrast(Pre_I);        
      % 7. Nnormalized WM: make sure that weights sum to one for each pixel.
        % Comments about weighting exponents of the weight maps:
        % Similar to [17], [19], and [54], weighting exponents may be varied depending on applications or tasks. 
        % Optimizinag weighting exponents might be further research. For a ageneric approach, here, we used equal weigths.       
        W                               = W_chr.*W_sat.*W_sal.*W_fog.*W_lum.*W_con + 1e-12; %avoids division by zero
        W                               = W./repmat(sum(W,3),[1 1 N]); 
              
%% Multiscale refinement              
      % Initial empty pyramid set 
        pyr_N                           = 9;   % pyramid level
        pyr                             = gaussian_pyramid(zeros(row,col,3),pyr_N);
        nlev                            = length(pyr);        
      % Multiscale refinement: multiresolution blending
        for i = 1:N            
            % Gaussian pyramid decomposition for normalized WM
            pyrW                        = gaussian_pyramid(W(:,:,i),pyr_N);
            % Laplacian pyramid decomposition for Pre_I  
            pyrI                        = laplacian_pyramid(Pre_I(:,:,:,i),pyr_N);
            % Fused pyramid
            for l = 1:nlev
                w                       = repmat(pyrW{l},[1 1 3]);
                pyr{l}                  = pyr{l} + w.*pyrI{l};
            end
        end     
      % Laplacian pyramid reconstruction
        Defogged_I                      = uint8(reconstruct_laplacian_pyramid(pyr));
end
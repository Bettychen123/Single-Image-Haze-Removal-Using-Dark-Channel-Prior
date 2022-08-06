function [D D_map] = FADE_overlapped(I)
    % Input: test image, I
    % Output: perceptual fog density D and fog density map D_map using 8 x 8 overlapped patches
    
    %% basic setup     
            ps                              = 8; % patch size for sliding window                       
            [row col dim]                   = size(I);
        % RGB and gray channel
            R                               = double(I(:,:,1));
            G                               = double(I(:,:,2));
            B                               = double(I(:,:,3));    
            Ig                              = double(rgb2gray(I));
            Ig_int                          = uint8(Ig);        
        % Dark channel prior image: Id, pixel-wise, scaled to [0 1]
            Irn                             = R./255;
            Ign                             = G./255;
            Ibn                             = B./255;
            Id                              = min(min(Irn,Ign),Ibn);
        % HSV saturation image: Is                
            I_hsv                           = rgb2hsv(I);
            Is                              = I_hsv(:,:,2);
        % MSCN
            MSCN_window                     = fspecial('gaussian',7,7/6);
            MSCN_window                     = MSCN_window/sum(sum(MSCN_window));        
            warning('off');               
            mu                              = imfilter(Ig,MSCN_window,'replicate');
            mu_sq                           = mu.*mu;
            sigma                           = sqrt(abs(imfilter(Ig.*Ig,MSCN_window,'replicate') - mu_sq));
            MSCN                            = (Ig-mu)./(sigma+1);
            cv                              = sigma./mu;    
        % rg and by channel
            rg                              = R-G;
            by                              = 0.5*(R+G)-B;                 
        
    %% Fog aware statistical feature extraction  
        % f1       
            MSCN_var_before                 = border_in(MSCN,ps);
            MSCN_var_after                  = colfilt(MSCN_var_before, [ps ps], 'sliding',@var);        
            MSCN_var                        = border_out(MSCN_var_after,ps);
        % f2, f3                        
            MSCN_pair_var_before            = border_in(MSCN.*circshift(MSCN,[1 0]),ps);        
            MSCN_pair_var_before_positive   = MSCN_pair_var_before; MSCN_pair_var_before_positive(MSCN_pair_var_before_positive<0) = NaN;
            MSCN_pair_var_before_negative   = MSCN_pair_var_before; MSCN_pair_var_before_negative(MSCN_pair_var_before_negative>0) = NaN;        
            MSCN_pair_var_after_positive    = colfilt(MSCN_pair_var_before_positive, [ps ps], 'sliding',@nanvar);
            MSCN_pair_var_after_negative    = colfilt(MSCN_pair_var_before_negative, [ps ps], 'sliding',@nanvar);   
            MSCN_pair_var_after_negative((double(isnan(MSCN_pair_var_after_negative))==1)) = 0;
            MSCN_pair_var_after_positive((double(isnan(MSCN_pair_var_after_positive))==1)) = 0;        
            MSCN_V_pair_R_var               = border_out(MSCN_pair_var_after_positive,ps);
            MSCN_V_pair_L_var               = border_out(MSCN_pair_var_after_negative,ps);        
        % f4        
            Mean_sigma_before               = border_in(sigma,ps);
            Mean_sigma_after                = colfilt(Mean_sigma_before, [ps ps], 'sliding',@mean);
            Mean_sigma                      = border_out(Mean_sigma_after,ps);
        % f5        
            Mean_cv_before                  = border_in(cv,ps);
            Mean_cv_after                   = colfilt(Mean_cv_before, [ps ps], 'sliding',@mean);
            Mean_cv                         = border_out(Mean_cv_after,ps);
        % f6,f7,f8        
            [CE_gray CE_by CE_rg]           = CE(I);        
            Mean_CE_gray_before             = border_in(CE_gray,ps);
            Mean_CE_by_before               = border_in(CE_by,ps);
            Mean_CE_rg_before               = border_in(CE_rg,ps);
            Mean_CE_gray_after              = colfilt(Mean_CE_gray_before, [ps ps], 'sliding',@mean);
            Mean_CE_by_after                = colfilt(Mean_CE_by_before, [ps ps], 'sliding',@mean);
            Mean_CE_rg_after                = colfilt(Mean_CE_rg_before, [ps ps], 'sliding',@mean);
            Mean_CE_gray                    = border_out(Mean_CE_gray_after,ps);
            Mean_CE_by                      = border_out(Mean_CE_by_after,ps);
            Mean_CE_rg                      = border_out(Mean_CE_rg_after,ps);                        
        % f9        
            if mod(ps,2)==1
                IE_window_size              = ps;   % size should be odd
            elseif mod(ps,2)==0
                IE_window_size              = ps-1;   
            end
            IE                              = entropyfilt(Ig_int,true(IE_window_size));
        % f10
            Mean_Id_before                  = border_in(Id,ps);
            Mean_Id_after                   = colfilt(Mean_Id_before, [ps ps], 'sliding',@mean);        
            Mean_Id                         = border_out(Mean_Id_after,ps);
        % f11        
            Mean_Is_before                  = border_in(Is,ps);
            Mean_Is_after                   = colfilt(Mean_Is_before, [ps ps], 'sliding',@mean);        
            Mean_Is                         = border_out(Mean_Is_after,ps);
        % f12
            rg_before                       = border_in(rg,ps);
            by_before                       = border_in(by,ps);
            CF_after                        = sqrt(colfilt(rg_before, [ps ps], 'sliding',@std).^2+colfilt(by_before, [ps ps], 'sliding',@std).^2)+0.3*sqrt(colfilt(rg_before, [ps ps], 'sliding',@mean).^2+colfilt(by_before, [ps ps], 'sliding',@mean).^2);    
            CF                              = border_out(CF_after,ps);                
        feat                                = [MSCN_var(:) MSCN_V_pair_R_var(:) MSCN_V_pair_L_var(:) Mean_sigma(:) Mean_cv(:) Mean_CE_gray(:) Mean_CE_by(:) Mean_CE_rg(:) IE(:) Mean_Id(:) Mean_Is(:) CF(:)];     
        feat                                = log(1+ feat);        
        
    %% MVG model distance            
        % Df (foggy level distance) for each pixel                           
        % Data from a corpus of fogfree images (mu, cov)
            load('natural_fogfree_features_overlapped_patch_ps8.mat');
        % test imgae param for each pixel
            mu_fog_param_pixel         = feat;
            cov_fog_param_pixel        = nanvar(feat')';
        % calculation for distance - includes intermediate steps
            feature_size               = size(feat,2);                
            mu_matrix                  = repmat(mu_fogfreeparam, [size(feat,1),1]) - mu_fog_param_pixel;   
            cov_temp1                  = [];
            cov_temp1(cumsum(feature_size.*ones(1,length(cov_fog_param_pixel))))=1;
            cov_temp2                  = cov_fog_param_pixel(cumsum(cov_temp1)-cov_temp1+1,:);
            cov_temp3                  = repmat(cov_temp2, [1,feature_size]);
            cov_temp4                  = repmat(cov_fogfreeparam,[length(cov_fog_param_pixel),1]);
            cov_matrix                 = (cov_temp3 + cov_temp4)/2; 
        % cell computation
            mu_cell                    = num2cell(mu_matrix,2);
            cov_cell                   = mat2cell(cov_matrix, feature_size*ones(1,length(mu_matrix)),feature_size);        
            mu_transpose_cell          = num2cell(mu_matrix',1);        
        % foggy level distance computation
            distance_pixel             = sqrt(cell2mat(cellfun(@mtimes,cellfun(@mrdivide,mu_cell,cov_cell, 'UniformOutput',0),mu_transpose_cell', 'UniformOutput',0)));    
            Df                         = nanmean(distance_pixel);   % Mean_distance_pixel (Df)                 
            Df_map                     = reshape(distance_pixel,[row,col]); 
            clear mu_matrix cov_matrix mu_cell cov_cell mu_transpose_cell distance_pixel 

        %Dff (fog-free level distance) for each pixel
        % load natural foggy image features (mu, cov)
            load('natural_foggy_features_overlapped_patch_ps8.mat');   
        % calculation of distance - includes intermediate steps                
            mu_matrix                  = repmat(mu_foggyparam,  [size(feat,1),1]) - mu_fog_param_pixel;                        
            cov_temp5                  = repmat(cov_foggyparam,[length(cov_fog_param_pixel),1]);
            cov_matrix                 = (cov_temp3 + cov_temp5)/2;          
        % cell computation
            mu_cell                    = num2cell(mu_matrix,2);
            cov_cell                   = mat2cell(cov_matrix, feature_size*ones(1, size(mu_matrix,1)),feature_size);        
            mu_transpose_cell          = num2cell(mu_matrix',1);        
        % fog-free level distance computation
            distance_pixel             = sqrt(cell2mat(cellfun(@mtimes,cellfun(@mrdivide,mu_cell,cov_cell, 'UniformOutput',0),mu_transpose_cell', 'UniformOutput',0)));                         
            Dff                        = nanmean(distance_pixel);  % Mean_distance_pixel(Dff)                   
            Dff_map                    = reshape(distance_pixel,[row,col]);                                               
            clear mu_matrix cov_matrix mu_cell cov_cell mu_transpose_cell distance_pixel    

  %% Perceptual fog density and Density map
        D     = Df/(1+Dff);
        D_map = Df_map./(1+Dff_map);
end
       
function B=bilateral_filter_plus(IM,w)
r = 0;
N=[1,-2,1];   %与拉普拉斯滤波器相关的高通滤波器
M=[1;-2;1];  
dim=size(IM);
for i=1:(dim(1)/2)            %估计标准差
    for j=1:(dim(2)/2)
        p=abs(conv(M,conv(N,IM(i,j))));
        r=p+r;
    end
end
q=0.18*r/(dim(1)*dim(2));
sigma = [3 q]; %空间相似度影响因子σd记为SIGMA(1),亮度相似度影响因子σr记为SIGMA(2)
% 应用灰度或彩色双边滤波
if size(IM,3) ==1
   B = bfltGray(IM,w,sigma(1),sigma(2));
  else if size(IM,3) ==3
   B = bfltColor(IM,w,sigma(1),sigma(2));
end

if exist('applycform','file')
   B = applycform(B,makecform('lab2srgb'));
else  
   B = colorspace('RGB<-Lab',B);
end
end
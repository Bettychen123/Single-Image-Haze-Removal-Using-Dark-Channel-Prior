clc;clear;close all;
w0=1;  %保留因子
t0=0.001; %避免透射率计算中出现零时，使用了零当分母

I=imread('0027.jpg');
%I1=imread('0888_0.8_0.2.jpg');
% I_C=imread('8000.jpg');
figure; 
imshow(I); title('原图');
[I_sky,I_back,A4]=skydetection(I);%首先对天空进行分割

[h,w,s]=size(I); %有s=3的原因是因为其为彩色图片
%求取暗通道
min_I=zeros(h,w);            
for i=1:h                   %获取三通道最小值            
   for j=1:w 
        min_I(i,j)=min(I(i,j,:)); %获取R G B三通道的最小值
    end 
end 
%最小值滤波
dark_I = ordfilt2(min_I,1,ones(15,15),'symmetric'); %窗口大小7*7即共计每次将49个元素进行排序取最小的 orfilt2为二维顺序滤波函数
dark_channel=double(dark_I); 
M=uint8(dark_I);%变成矩阵后才能显示
figure;
imshow(M);
Max_dark_channel=double(max(max(dark_I)));  %A 

%求取亮通道
max_I=zeros(h,w);            
for i=1:h                   %获取三通道最小值            
   for j=1:w 
        max_I(i,j)=max(I(i,j,:)); %获取R G B三通道的最大值
    end 
end 
%最大值滤波
light_I = ordfilt2(min_I,225,ones(15,15),'symmetric'); %窗口大小7*7即共计每次将49个元素进行排序取最小的 orfilt2为二维顺序滤波函数
N=uint8(light_I);%变成矩阵后才能显示
figure;
imshow(N);%显示亮通道
t_back=1-w0*(dark_channel./Max_dark_channel);   %初始t 
t_light=1-w0*(dark_channel./light_I);   %天空t 
t_light=t_light.*A4;
t_back=t_back.*~A4;
t=t_light+t_back;
t1=max(t,t0); %清除透射率图中可能出现的零值
figure; 
T=uint8(t1*255); 
imshow(T); 
title('透射率图'); 

r=30;
eps=10^-6;

%filtered = imguidedfilter(double(rgb2gray(I))/255,t1);
filtered = guidedfilter(double(rgb2gray(I))/255,t1,r,eps);%导向滤波

% filtered = gdgif(double(rgb2gray(I))/255,t1,3,0.1);
t2=filtered;
% figure;
T=uint8(t2*255); 
imshow(T); 
% title('导向滤波透射率图'); 
A=Max_dark_channel;

I1=double(I);   %计算去雾图像
J(:,:,1) = uint8(A + (I_back(:,:,1)-A)./t2)+uint8(I_sky(:,:,1)); 
J(:,:,2) = uint8(A + (I_back(:,:,2)-A)./t2)+uint8(I_sky(:,:,2)); 
J(:,:,3) = uint8(A + (I_back(:,:,3)-A)./t2)+uint8(I_sky(:,:,3)); 
figure; 
imshow(J);
% NIQE = niqe(J);
% FADE=FADE(J);
% MSE = immse(J,I_C);  % matlab 自带函数
% PSNR = psnr(I_C,J); 
% %[~,mse]=psnr(I_C,I);
% %psnr=10*log10(255^2 / mse);
% [SSIM,SSM]=ssim(I_C, J);
 
% title('基于天空分割的双通道去雾图像'); 

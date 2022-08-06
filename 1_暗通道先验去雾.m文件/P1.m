clc;clear;close all;
w0=0.95;  %保留因子
t0=0.1; %避免透射率计算中出现零时，使用了零当分母

I=imread('0006_0.8_0.16.jpg');
%I1=imread('4571_0.8_0.2.jpg');
%I_C=imread('2586.jpg');
% figure; 
imshow(I); title('原图');
 
[h,w,s]=size(I); %有s=3的原因是因为其为彩色图片
min_I=zeros(h,w);            

for i=1:h                   %获取三通道最小值            
    for j=1:w 
        min_I(i,j)=min(I(i,j,:)); %获取R G B三通道的最小值
    end 
end 
N=uint8(min_I);
% figure;  
% imshow(N); 

%最小值滤波
dark_I = ordfilt2(min_I,1,ones(11,11),'symmetric'); %窗口大小7*7即共计每次将49个元素进行排序取最小的 orfilt2为二维顺序滤波函数
M=uint8(dark_I);
% figure;  
% imshow(M); 

Max_dark_channel=double(max(max(dark_I)));  %A 

dark_channel=double(dark_I); 
t=1-w0*(dark_channel/Max_dark_channel);   %t 


 
% figure; 
% T=uint8(t*255); 
% imshow(T); 
%title('透射率图'); 
 
t1=max(t,t0); %清除透射率图中可能出现的零值



r=30;
eps=10^-6;
%filtered = imguidedfilter(t1,double(rgb2gray(I))/255);
filtered=guidedfilter(double(rgb2gray(I)/255),t1, r, eps);%需先转化为灰度图后导向滤波
%filtered=guidedfilter_color( double(I/255),t1,r, eps);%彩色导向滤波
t2=filtered;

% figure;
% T=uint8(t2*255); 
% imshow(T); 
% title('滤波透射率图'); 

I1=double(I);   %计算去雾图像
J(:,:,1) = uint8(Max_dark_channel + (I1(:,:,1)-Max_dark_channel)./t2); 
J(:,:,2) = uint8(Max_dark_channel + (I1(:,:,2)-Max_dark_channel)./t2); 
J(:,:,3) = uint8(Max_dark_channel + (I1(:,:,3)-Max_dark_channel)./t2); 
figure; 
imshow(J);

NIQE = niqe(J);
FADE=FADE(J);
% MSE = immse(J,I_C);  % matlab 自带函数
% PSNR = psnr(I_C, J); 
% [SSIM,SSM]=ssim(I_C, J);
 AINAL=zeros(1,5);
%  AINAL(1,1)=PSNR;
%  AINAL(1,2)=MSE;
%  AINAL(1,3)=SSIM;
 AINAL(1,1)=FADE;
 AINAL(1,2)=NIQE;



 

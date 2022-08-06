clc;clear;close all;
w0=0.95;  %保留因子
t0=0.001; %避免透射率计算中出现零时，使用了零当分母

I=imread('0059.jpg');
%I_C=imread('0002.jpg');
figure; 
imshow(I); title('原图');

[h,w,s]=size(I); %有s=3的原因是因为其为彩色图片
min_I=zeros(h,w);            
for i=1:h                   %获取三通道最小值            
   for j=1:w 
        min_I(i,j)=min(I(i,j,:)); %获取R G B三通道的最小值
    end 
end 

%最小值滤波
dark_I = ordfilt2(min_I,1,ones(13,13),'symmetric'); %窗口大小7*7即共计每次将49个元素进行排序取最小的 orfilt2为二维顺序滤波函数

Max_dark_channel=double(max(max(dark_I)));  %A 

dark_channel=double(dark_I); 
t=1-w0*(dark_channel/(Max_dark_channel));   %初始t 
t1=max(t,t0); %清除透射率图中可能出现的零值

%OTSU分割算法
I_f=rgb2gray(I);%先把彩色图变灰度图
level = graythresh(I_f);%寻找方差最大时的阈值
BW = imbinarize(I_f,level);
BW=1-BW;
BW=1-imfill(BW,'holes');
se=strel('disk',1);% disk 21

A4=BW;
A4=bwmorph(A4,'bridge',inf);
A4=bwmorph(A4,'clean',inf);
A4=imerode(A4,se);
%A4=imdilate(A4,de);

I_sky(:,:,1)=double(I(:,:,1)).*A4;%天空R
I_sky(:,:,2)=double(I(:,:,2)).*A4;%G
I_sky(:,:,3)=double(I(:,:,3)).*A4;%B


B4=~A4;%非天空区域
I_back(:,:,1)=double(I(:,:,1)).*B4;%背景
I_back(:,:,2)=double(I(:,:,2)).*B4;
I_back(:,:,3)=double(I(:,:,3)).*B4;


[m,n,s]=size(I_sky);
s=0;a=0;
for x=1:m
    for y=1:n
        for z=1:3
         if I_sky(x,y,z)~=0
             a=a+1;
        s=s+I_sky(x,y,z); %求像素值总和 s
         end
    end
    end
end
a3=s/a;
Max_dark_channel_sky=a3;%A天空

r=60;
eps=10^-6;
%filtered = gdgif(double(rgb2gray(I))/255,t1,3,0.1);%梯度域导向滤波

%t1= imguidedfilter(double(rgb2gray(I))/255,t1);
filtered = guidedfilter(double(rgb2gray(I))/255,t1,r,eps);%导向滤波
t2=filtered;
%t2=t2./255;


figure;
T=uint8(t2*255); 
imshow(T); 
%title('导向滤波透射率图'); 


I1=double(I);   %计算去雾图像
J(:,:,1) = uint8(Max_dark_channel_sky + (I1(:,:,1)-Max_dark_channel_sky)./t2); 
J(:,:,2) = uint8(Max_dark_channel_sky + (I1(:,:,2)-Max_dark_channel_sky)./t2); 
J(:,:,3) = uint8(Max_dark_channel_sky + (I1(:,:,3)-Max_dark_channel_sky)./t2);
figure; 
imshow(J); 
% NIQE = niqe(J);
% FADE=FADE(J);
% MSE = immse(J,I_C);  % matlab 自带函数
% PSNR = psnr(I_C,J); 
% [SSIM,SSM]=ssim(I_C, J);

%title('基于暗通道先验原理的去雾图像'); 
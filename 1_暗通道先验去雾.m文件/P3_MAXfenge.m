clc;clear;close all;
w0=0.95;  %保留因子
t0=0.00001; %避免透射率计算中出现零时，使用了零当分母

I=imread('0578_0.95_0.2.jpg'); 
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
dark_I = ordfilt2(min_I,1,ones(6,6),'symmetric'); %窗口大小7*7即共计每次将49个元素进行排序取最小的 orfilt2为二维顺序滤波函数

Max_dark_channel=double(max(max(dark_I)));  %A 

dark_channel=double(dark_I); 
t=1-w0*(dark_channel/Max_dark_channel);   %初始t 
t1=max(t,t0); %清除透射率图中可能出现的零值
figure; 
T=uint8(t1*255); 
imshow(T); 
title('透射率图'); 
%完成对图像的初始值t的求解

%maxfangcha分割算法
I_f=I
I_gray=rgb2gray(I_f);%转换为灰度图
figure;subplot(121),imshow(I);
%转换为双精度
I_double=double(I_gray);
[wid,len]=size(I_gray);%图像的大小
%灰度级
colorLevel=256;
%直方图
hist=zeros(colorLevel,1);
%计算直方图
for i=1:wid
    for j=1:len
        m=I_gray(i,j)+1;%图像的灰度级m
        hist(m)=hist(m)+1;%灰度值为i的像素和
    end
end
%直方图归一化
hist=hist/(wid*len);%各灰度值概率 Pi
miuT=0;%定义总体均值
for m=1:colorLevel
    miuT=miuT+(m-1)*hist(m);  %总体均值
end
xigmaB2=0;%
for mindex=1:colorLevel
    threshold=mindex-1;%设定阈值
    omega1=0;%目标概率
    omega2=0;%背景概率
    for m=1:threshold-1
        omega1=omega1+hist(m);% 目标概率 W0
    end
    omega2=1-omega1; %背景的概率 W1
    miu1=0;%目标的平均灰度值
    miu2=0;%背景的平均灰度值
    for m=1:colorLevel
        if m<threshold
            miu1=miu1+(m-1)*hist(m);%目标 i*pi的累加值[1 threshold]
        else
            miu2=miu2+(m-1)*hist(m);%背景 i*pi的累加值[threshold m]
        end
    end
    miu1=miu1/omega1;%目标的平均灰度值
    miu2=miu2/omega2;%背景的平均灰度值
    xigmaB21=omega1*(miu1-miuT)^2+omega2*(miu2-miuT)^2;%最大方差
    xigma(mindex)=xigmaB21;%先设定一个值 再遍历所有灰度级
    %找到xigmaB21的值最大
    if xigmaB21>xigmaB2
        finalT=threshold;%找到阈值 灰度级
        xigmaB2=xigmaB21;%方差为最大
    end
end
%阈值归一化
fT=finalT/255;
for i=1:wid
     for j=1:len
         if I_double(i,j)>finalT %大于所设定的均值 则为目标
             bin(i,j)=0;
         else
             bin(i,j)=1;
         end
     end
end
subplot(122),imshow(bin);

se=strel('disk',20);
fc=imclose(bin,se);%直接闭运算
fco=imopen(fc,se);%先闭后开运算
figure;imshow(fco);
title('先闭后开运算');
A4=fco;

I_sky(:,:,1)=double(I(:,:,1)).*A4;%天空R
I_sky(:,:,2)=double(I(:,:,2)).*A4;%G
I_sky(:,:,3)=double(I(:,:,3)).*A4;%B
figure;imshow(I_sky)
title('分割后的天空');

B4=~A4;%非天空区域
I_back(:,:,1)=double(I(:,:,1)).*B4;%背景
I_back(:,:,2)=double(I(:,:,2)).*B4;
I_back(:,:,3)=double(I(:,:,3)).*B4;
figure;imshow(I_back);title('分割后的背景');


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


r=30;
eps=10^-6;
filtered = guidedfilter_color(double(I),t1,r, eps);%导向滤波
t2=filtered;

figure;
T=uint8(t2*255); 
imshow(T); 
title('导向滤波透射率图'); 


I1=double(I);   %计算去雾图像
J(:,:,1) = uint8(Max_dark_channel_sky + (I_back(:,:,1)-Max_dark_channel_sky)./t2)+uint8(I_sky(:,:,1)); 
J(:,:,2) = uint8(Max_dark_channel_sky + (I_back(:,:,2)-Max_dark_channel_sky)./t2)+uint8(I_sky(:,:,2)); 
J(:,:,3) = uint8(Max_dark_channel_sky + (I_back(:,:,3)-Max_dark_channel_sky)./t2)+uint8(I_sky(:,:,3)); 
figure; 
imshow(J); 
title('基于暗通道先验原理的去雾图像'); 
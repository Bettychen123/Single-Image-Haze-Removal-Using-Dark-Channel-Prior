%=========================================================%
%调用规则：（有雾时调用，否则不调用）
%实际操作时,according to experiments：
%percent=under_50/total
%percent<0.1%,取w=0.6
%percent>0.1%&&percent<1%,取w=0.45
%percenet>1%&&percent<2%,取w=0.3
%else not use haze-free-adjust
%有雾：绘制出的直方图<50的部分<1%
%最后控制台还会输出原图中under_50像素点所占比例
%=========================================================%
close all
clear all
clc
blockSize=15;               %每个block为15个像素
w0=0.6;                    
t0=0.1;
% A=200;
I=imread('22.png');
%I=imread('C:\Users\Zrq\Desktop\同济.jpg');

%set(gcf,'outerposition',get(0,'screensize'));%获得SystemScreenSize 传递给当前图像句柄gcf的outerposition属性
%subplot(321)%表示3（行数）*2（列数）的图像，1代表所画图形的序号
figure;
imshow(I);
title('Original Image');
%subplot(323);
figure;
grayI=rgb2gray(I);
imshow(grayI,[]);
title('原图像灰度图')
%subplot(324);
imhist(grayI,64);
%统计<50的像素所占的比例
%%%%%%%%%%%%%%%%%%%%%%
[COUNT x]=imhist(grayI);
under_50=0;
for i=0:50
    under_50=under_50+COUNT(x==i);
end
under_50
total=size(I,1)*size(I,2)*size(I,3);
percent=under_50/total
%%%%%%%%%%%%%%%%%%%%%%
%if(percent>0.02)
    %('This image need not Haze-Free-Proprocessing.');%
 if(percent<0.001)
        w=0.6;
    else if (percent>0.01)
            w=0.3;
        else
            w=0.45;
        end
    end

 
[h,w,s]=size(I);
min_I=zeros(h,w);
 
for i=1:h                 
    for j=1:w
        dark_I(i,j)=min(I(i,j,:));%取每个点的像素为RGB分量中最低的那个通道的值
    end
end
 
Max_dark_channel=double(max(max(dark_I)))
dark_channel=double(dark_I);
t=1-w0*(dark_channel/Max_dark_channel);
 
T=uint8(t*255);
 
t=max(t,t0);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I1=double(I);
J(:,:,1) = uint8((I1(:,:,1) - (1-t)*Max_dark_channel)./t);
 
J(:,:,2) = uint8((I1(:,:,2) - (1-t)*Max_dark_channel)./t);
 
J(:,:,3) =uint8((I1(:,:,3) - (1-t)*Max_dark_channel)./t);
%subplot(322)
figure;
imshow(J);
imwrite(J,'tj2.jpg');
title('Haze-Free Image:');
 
%subplot(325);
figure;
grayJ=rgb2gray(J);
imshow(grayJ,[]);
title('去雾后灰度图')
 
%subplot(326);
figure;
imhist(grayJ,64);
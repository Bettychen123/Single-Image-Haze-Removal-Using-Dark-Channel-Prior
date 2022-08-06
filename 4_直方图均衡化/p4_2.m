clear;close all;clc;
% 读取图像
I=imread('xkl.png');
figure;imshow(I);title('原图');
%AHE中不同的分块数目得到的效果会有所差异
I_AHE_1=ahe(I,4,256);
figure;imshow(I_AHE_1);title('4*4分块');
imwrite(I_AHE_1,'AHE4_4.jpg');
I_AHE_2=ahe(I,6,256);
figure;imshow(I_AHE_2);title('6*6分块');
imwrite(I_AHE_2,'AHE6_6.jpg');

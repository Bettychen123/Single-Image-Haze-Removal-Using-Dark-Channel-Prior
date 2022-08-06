clear; clc;
close all 
I=imread('xkl.png'); 
figure;imshow(I);title('原图')
I(:,:,1)=adapthisteq(I(:,:,1));
I(:,:,2)=adapthisteq(I(:,:,2));
I(:,:,3)=adapthisteq(I(:,:,3));
figure;imshow(I);title('直接直方图均衡化后的图像')
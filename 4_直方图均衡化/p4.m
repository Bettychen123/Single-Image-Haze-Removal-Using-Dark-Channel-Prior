clear; clc;
close all 
I=imread('xkl.png'); 
figure;imshow(I);title('ԭͼ')
I(:,:,1)=adapthisteq(I(:,:,1));
I(:,:,2)=adapthisteq(I(:,:,2));
I(:,:,3)=adapthisteq(I(:,:,3));
figure;imshow(I);title('ֱ��ֱ��ͼ���⻯���ͼ��')
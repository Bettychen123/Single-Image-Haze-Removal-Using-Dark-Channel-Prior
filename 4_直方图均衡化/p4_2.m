clear;close all;clc;
% ��ȡͼ��
I=imread('xkl.png');
figure;imshow(I);title('ԭͼ');
%AHE�в�ͬ�ķֿ���Ŀ�õ���Ч������������
I_AHE_1=ahe(I,4,256);
figure;imshow(I_AHE_1);title('4*4�ֿ�');
imwrite(I_AHE_1,'AHE4_4.jpg');
I_AHE_2=ahe(I,6,256);
figure;imshow(I_AHE_2);title('6*6�ֿ�');
imwrite(I_AHE_2,'AHE6_6.jpg');

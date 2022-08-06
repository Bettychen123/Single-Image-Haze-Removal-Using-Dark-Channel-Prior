%--------------------------------------
%软抠图-暗通道先验去雾，解决透射率图不够精细的问题，但运算量大，后续的导向滤波改进可以解决该问题
%作者：西安邮电大学图像处理团队-郝浩
clc;
clear;
close all;

img = imread('88.png');
figure;imshow(img);title('雾图');
De_img = anyuanse(img);
figure;imshow(De_img);title('去雾图');

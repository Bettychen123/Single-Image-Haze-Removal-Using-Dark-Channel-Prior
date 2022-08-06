function [I_sky,I_back,A4]=skydetection(I)
%OTSU分割算法
I_f=rgb2gray(I);%先把彩色图变灰度图
figure;imshow(I_f);
level = graythresh(I_f);%寻找方差最大时的阈值
BW = imbinarize(I_f,level);
BW=1-BW;
BW=1-imfill(BW,'holes');
% figure;
% imshow(BW);
% title('图像分割');
se=strel('disk',1);% disk 21
de=strel('disk',10);

A4=BW;
A4=bwmorph(A4,'bridge',inf);
A4=bwmorph(A4,'clean',inf);
A4=imerode(A4,se);
%A4=imdilate(A4,de);
% figure;imshow(A4);
I_sky(:,:,1)=double(I(:,:,1)).*A4;%天空R
I_sky(:,:,2)=double(I(:,:,2)).*A4;%G
I_sky(:,:,3)=double(I(:,:,3)).*A4;%B
%  figure;imshow(uint8(I_sky));
%title('分割后的天空');

B4=~A4;%非天空区域
I_back(:,:,1)=double(I(:,:,1)).*B4;%背景
I_back(:,:,2)=double(I(:,:,2)).*B4;
I_back(:,:,3)=double(I(:,:,3)).*B4;
%  figure;imshow(uint8(I_back));title('分割后的背景');%将数据类型转化为uint8后才能够进行显示
end
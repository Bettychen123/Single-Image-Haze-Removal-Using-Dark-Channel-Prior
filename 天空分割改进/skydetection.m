function [I_sky,I_back,A4]=skydetection(I)
%OTSU�ָ��㷨
I_f=rgb2gray(I);%�ȰѲ�ɫͼ��Ҷ�ͼ
figure;imshow(I_f);
level = graythresh(I_f);%Ѱ�ҷ������ʱ����ֵ
BW = imbinarize(I_f,level);
BW=1-BW;
BW=1-imfill(BW,'holes');
% figure;
% imshow(BW);
% title('ͼ��ָ�');
se=strel('disk',1);% disk 21
de=strel('disk',10);

A4=BW;
A4=bwmorph(A4,'bridge',inf);
A4=bwmorph(A4,'clean',inf);
A4=imerode(A4,se);
%A4=imdilate(A4,de);
% figure;imshow(A4);
I_sky(:,:,1)=double(I(:,:,1)).*A4;%���R
I_sky(:,:,2)=double(I(:,:,2)).*A4;%G
I_sky(:,:,3)=double(I(:,:,3)).*A4;%B
%  figure;imshow(uint8(I_sky));
%title('�ָ������');

B4=~A4;%���������
I_back(:,:,1)=double(I(:,:,1)).*B4;%����
I_back(:,:,2)=double(I(:,:,2)).*B4;
I_back(:,:,3)=double(I(:,:,3)).*B4;
%  figure;imshow(uint8(I_back));title('�ָ��ı���');%����������ת��Ϊuint8����ܹ�������ʾ
end
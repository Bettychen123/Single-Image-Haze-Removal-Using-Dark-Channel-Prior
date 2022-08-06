clc;clear;close all;
w0=0.95;  %��������
t0=0.001; %����͸���ʼ����г�����ʱ��ʹ�����㵱��ĸ

I=imread('D3.jpg');
%I1=imread('4571_0.8_0.2.jpg');
%I_C=imread('0685.jpg');
figure; 
 imshow(I); title('ԭͼ');

[h,w,s]=size(I); %��s=3��ԭ������Ϊ��Ϊ��ɫͼƬ
min_I=zeros(h,w);            
for i=1:h                   %��ȡ��ͨ����Сֵ            
   for j=1:w 
        min_I(i,j)=min(I(i,j,:)); %��ȡR G B��ͨ������Сֵ
    end 
end 

%��Сֵ�˲�
dark_I = ordfilt2(min_I,1,ones(13,13),'symmetric'); %���ڴ�С7*7������ÿ�ν�49��Ԫ�ؽ�������ȡ��С�� orfilt2Ϊ��ά˳���˲�����

Max_dark_channel=double(max(max(dark_I)));  %A 

dark_channel=double(dark_I); 
t=1-w0*(dark_channel/(Max_dark_channel));   %��ʼt 
t1=max(t,t0); %���͸����ͼ�п��ܳ��ֵ���ֵ
%figure; 
%T=uint8(t1*255); 
%imshow(T); 
%title('͸����ͼ'); 
%��ɶ�ͼ��ĳ�ʼֵt�����

%OTSU�ָ��㷨
I_f=rgb2gray(I);%�ȰѲ�ɫͼ��Ҷ�ͼ

level = graythresh(I_f);%Ѱ�ҷ������ʱ����ֵ
BW = imbinarize(I_f,level);

BW=1-BW;
BW=1-imfill(BW,'holes');
% figure;
% imshow(BW);
%title('ͼ��ָ�');

se=strel('disk',1);% disk 21
de=strel('disk',10);
%fc=imclose(BW,se);%ֱ�ӱ�����
%fco=imopen(fc,se);%�ȱպ�����
%figure;imshow(fco);
%title('�ȱպ�����');
%A4=fc;
%A4=imdilate(BW,de);
A4=BW;
A4=bwmorph(A4,'bridge',inf);
A4=bwmorph(A4,'clean',inf);
A4=imerode(A4,se);
%A4=imdilate(A4,de);
figure;imshow(A4);
I_sky(:,:,1)=double(I(:,:,1)).*A4;%���R
I_sky(:,:,2)=double(I(:,:,2)).*A4;%G
I_sky(:,:,3)=double(I(:,:,3)).*A4;%B
%figure;imshow(I_sky)
%title('�ָ������');

B4=~A4;%���������
I_back(:,:,1)=double(I(:,:,1)).*B4;%����
I_back(:,:,2)=double(I(:,:,2)).*B4;
I_back(:,:,3)=double(I(:,:,3)).*B4;
%figure;imshow(I_back);title('�ָ��ı���');

[m,n,s]=size(I_sky);
s=0;a=0;
for x=1:m
    for y=1:n
        for z=1:3
         if I_sky(x,y,z)~=0
             a=a+1;
        s=s+I_sky(x,y,z); %������ֵ�ܺ� s
         end
    end
    end
end
a3=s/a;
Max_dark_channel_sky=a3;%A���

r=60;
eps=10^-6;
%filtered = gdgif(double(rgb2gray(I))/255,t1,3,0.1);%�ݶ������˲�

%t1= imguidedfilter(double(rgb2gray(I))/255,t1);
filtered = guidedfilter(double(rgb2gray(I))/255,t1,r,eps);%�����˲�
t2=filtered;
%t2=t2./255;


W=uint8(t1*255); 
% imshow(W); 
% figure;
% T=uint8(t2*255); 
% imshow(T); 
%title('�����˲�͸����ͼ'); 


I1=double(I);   %����ȥ��ͼ��
J(:,:,1) = uint8(Max_dark_channel_sky + (I_back(:,:,1)-Max_dark_channel_sky)./t2)+uint8(I_sky(:,:,1)); 
J(:,:,2) = uint8(Max_dark_channel_sky + (I_back(:,:,2)-Max_dark_channel_sky)./t2)+uint8(I_sky(:,:,2)); 
J(:,:,3) = uint8(Max_dark_channel_sky + (I_back(:,:,3)-Max_dark_channel_sky)./t2)+uint8(I_sky(:,:,3)); 
figure; 
imshow(J); 
% NIQE = niqe(J);
% FADE=FADE(J);
%MSE = immse(J,I_C);  % matlab �Դ�����
%  PSNR = psnr(I_C,J); 
% [SSIM,SSM]=ssim(I_C, J);

%title('���ڰ�ͨ������ԭ���ȥ��ͼ��'); 
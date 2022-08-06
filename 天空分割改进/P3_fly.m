clc;clear;close all;
w0=0.95;  %��������
t0=0.001; %����͸���ʼ����г�����ʱ��ʹ�����㵱��ĸ

I=imread('0059.jpg');
%I_C=imread('0002.jpg');
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

%OTSU�ָ��㷨
I_f=rgb2gray(I);%�ȰѲ�ɫͼ��Ҷ�ͼ
level = graythresh(I_f);%Ѱ�ҷ������ʱ����ֵ
BW = imbinarize(I_f,level);
BW=1-BW;
BW=1-imfill(BW,'holes');
se=strel('disk',1);% disk 21

A4=BW;
A4=bwmorph(A4,'bridge',inf);
A4=bwmorph(A4,'clean',inf);
A4=imerode(A4,se);
%A4=imdilate(A4,de);

I_sky(:,:,1)=double(I(:,:,1)).*A4;%���R
I_sky(:,:,2)=double(I(:,:,2)).*A4;%G
I_sky(:,:,3)=double(I(:,:,3)).*A4;%B


B4=~A4;%���������
I_back(:,:,1)=double(I(:,:,1)).*B4;%����
I_back(:,:,2)=double(I(:,:,2)).*B4;
I_back(:,:,3)=double(I(:,:,3)).*B4;


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


figure;
T=uint8(t2*255); 
imshow(T); 
%title('�����˲�͸����ͼ'); 


I1=double(I);   %����ȥ��ͼ��
J(:,:,1) = uint8(Max_dark_channel_sky + (I1(:,:,1)-Max_dark_channel_sky)./t2); 
J(:,:,2) = uint8(Max_dark_channel_sky + (I1(:,:,2)-Max_dark_channel_sky)./t2); 
J(:,:,3) = uint8(Max_dark_channel_sky + (I1(:,:,3)-Max_dark_channel_sky)./t2);
figure; 
imshow(J); 
% NIQE = niqe(J);
% FADE=FADE(J);
% MSE = immse(J,I_C);  % matlab �Դ�����
% PSNR = psnr(I_C,J); 
% [SSIM,SSM]=ssim(I_C, J);

%title('���ڰ�ͨ������ԭ���ȥ��ͼ��'); 
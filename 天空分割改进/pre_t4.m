clc;clear;close all;
w0=1;  %��������
t0=0.001; %����͸���ʼ����г�����ʱ��ʹ�����㵱��ĸ

I=imread('0006_0.8_0.2.jpg');
%I1=imread('0888_0.8_0.2.jpg');
I_C=imread('0006.jpg');
figure; 
imshow(I); title('ԭͼ');
[I_sky,I_back,A4]=skydetection(I);%���ȶ���ս��зָ�

[h,w,s]=size(I); %��s=3��ԭ������Ϊ��Ϊ��ɫͼƬ
%��ȡ��ͨ��
min_I=zeros(h,w);            
for i=1:h                   %��ȡ��ͨ����Сֵ            
   for j=1:w 
        min_I(i,j)=min(I(i,j,:)); %��ȡR G B��ͨ������Сֵ
    end 
end 
%��Сֵ�˲�
dark_I = ordfilt2(min_I,1,ones(15,15),'symmetric'); %���ڴ�С7*7������ÿ�ν�49��Ԫ�ؽ�������ȡ��С�� orfilt2Ϊ��ά˳���˲�����
dark_channel=double(dark_I); 
M=uint8(dark_I);%��ɾ���������ʾ
figure;
imshow(M);
Max_dark_channel=double(max(max(dark_I)));  %A 

%��ȡ��ͨ��
max_I=zeros(h,w);            
for i=1:h                   %��ȡ��ͨ����Сֵ            
   for j=1:w 
        max_I(i,j)=max(I(i,j,:)); %��ȡR G B��ͨ�������ֵ
    end 
end 
%���ֵ�˲�
light_I = ordfilt2(min_I,169,ones(15,15),'symmetric'); %���ڴ�С7*7������ÿ�ν�49��Ԫ�ؽ�������ȡ��С�� orfilt2Ϊ��ά˳���˲�����
N=uint8(light_I);%��ɾ���������ʾ
figure;
imshow(N);%��ʾ��ͨ��

[m,n,s]=size(I_back);
s=0;a=0;
for x=1:m
    for y=1:n
        for z=1:3
         if I_back(x,y,z)~=0
             a=a+1;
        s=s+I_back(x,y,z); %������ֵ�ܺ� s
         end
    end
    end
end
a3=s/a;

A_light=light_I.*A4;
A_dark=Max_dark_channel.*~A4;
A=A_light+A_dark;

t=1-w0*(dark_channel./A);   %��ʼt 

t1=max(t,t0); %���͸����ͼ�п��ܳ��ֵ���ֵ
% figure; 
T=uint8(t1*255); 
% imshow(T); 
title('͸����ͼ'); 

r=30;
eps=10^-6;

%filtered = imguidedfilter(double(rgb2gray(I))/255,t1);
filtered = guidedfilter(double(rgb2gray(I))/255,t1,r,eps);%�����˲�

% filtered = gdgif(double(rgb2gray(I))/255,t1,3,0.1);
t2=filtered;
% figure;
T=uint8(t2*255); 
imshow(T); 
% title('�����˲�͸����ͼ'); 


I1=double(I);   %����ȥ��ͼ��
J(:,:,1) = uint8(A + (I_back(:,:,1)-A)./t2)+uint8(I_sky(:,:,1)); 
J(:,:,2) = uint8(A + (I_back(:,:,2)-A)./t2)+uint8(I_sky(:,:,2)); 
J(:,:,3) = uint8(A + (I_back(:,:,3)-A)./t2)+uint8(I_sky(:,:,3)); 
figure; 
imshow(J);
NIQE = niqe(J);
FADE=FADE(J);
MSE = immse(J,I_C);  % matlab �Դ�����
PSNR = psnr(I_C,J); 
%[~,mse]=psnr(I_C,I);
%psnr=10*log10(255^2 / mse);
[SSIM,SSM]=ssim(I_C, J);
 
% title('������շָ��˫ͨ��ȥ��ͼ��'); 

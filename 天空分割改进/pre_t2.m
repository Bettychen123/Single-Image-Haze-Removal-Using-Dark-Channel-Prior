clc;clear;close all;
w0=1;  %��������
t0=0.001; %����͸���ʼ����г�����ʱ��ʹ�����㵱��ĸ

I=imread('8000_0.8_0.2.jpg');
%I1=imread('0888_0.8_0.2.jpg');
I_C=imread('8000.jpg');
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

%��ȡ��ͨ��
max_I=zeros(h,w);            
for i=1:h                   %��ȡ��ͨ����Сֵ            
   for j=1:w 
        max_I(i,j)=max(I(i,j,:)); %��ȡR G B��ͨ�������ֵ
    end 
end 
%���ֵ�˲�
light_I = ordfilt2(min_I,196,ones(15,15),'symmetric'); %���ڴ�С7*7������ÿ�ν�49��Ԫ�ؽ�������ȡ��С�� orfilt2Ϊ��ά˳���˲�����
N=uint8(light_I);%��ɾ���������ʾ
figure;
imshow(N);%��ʾ��ͨ��

M=sort(I_sky(:),'descend');
M=M';
j=h*w*0.001;s=0;%��ȡǰ0.1%
for i=1:j
    s=s+M(i);
end
Max_dark_channel=double(max(max(dark_I)));  %A 
Max_dark_channel_sky=max(max(max(I_sky)));%A���
A=0.7*light_I+0.25*Max_dark_channel_sky;
for i=1:h
    for j=1:w
        if(A(i,j)<Max_dark_channel)
            A(i,j)=1.01*Max_dark_channel;
        end
    end
end
% A_sky=A.*~A4;
% A_back=A.*A4;
% A_sky=ordfilt2(A_sky,121,ones(11,11),'symmetric');
% A=A_sky+A_back;
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

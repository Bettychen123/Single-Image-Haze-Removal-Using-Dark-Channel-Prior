clc;clear;close all;
w0=0.95;  %��������
t0=0.1; %����͸���ʼ����г�����ʱ��ʹ�����㵱��ĸ

I=imread('0006_0.8_0.16.jpg');
%I1=imread('4571_0.8_0.2.jpg');
%I_C=imread('2586.jpg');
% figure; 
imshow(I); title('ԭͼ');
 
[h,w,s]=size(I); %��s=3��ԭ������Ϊ��Ϊ��ɫͼƬ
min_I=zeros(h,w);            

for i=1:h                   %��ȡ��ͨ����Сֵ            
    for j=1:w 
        min_I(i,j)=min(I(i,j,:)); %��ȡR G B��ͨ������Сֵ
    end 
end 
N=uint8(min_I);
% figure;  
% imshow(N); 

%��Сֵ�˲�
dark_I = ordfilt2(min_I,1,ones(11,11),'symmetric'); %���ڴ�С7*7������ÿ�ν�49��Ԫ�ؽ�������ȡ��С�� orfilt2Ϊ��ά˳���˲�����
M=uint8(dark_I);
% figure;  
% imshow(M); 

Max_dark_channel=double(max(max(dark_I)));  %A 

dark_channel=double(dark_I); 
t=1-w0*(dark_channel/Max_dark_channel);   %t 


 
% figure; 
% T=uint8(t*255); 
% imshow(T); 
%title('͸����ͼ'); 
 
t1=max(t,t0); %���͸����ͼ�п��ܳ��ֵ���ֵ



r=30;
eps=10^-6;
%filtered = imguidedfilter(t1,double(rgb2gray(I))/255);
filtered=guidedfilter(double(rgb2gray(I)/255),t1, r, eps);%����ת��Ϊ�Ҷ�ͼ�����˲�
%filtered=guidedfilter_color( double(I/255),t1,r, eps);%��ɫ�����˲�
t2=filtered;

% figure;
% T=uint8(t2*255); 
% imshow(T); 
% title('�˲�͸����ͼ'); 

I1=double(I);   %����ȥ��ͼ��
J(:,:,1) = uint8(Max_dark_channel + (I1(:,:,1)-Max_dark_channel)./t2); 
J(:,:,2) = uint8(Max_dark_channel + (I1(:,:,2)-Max_dark_channel)./t2); 
J(:,:,3) = uint8(Max_dark_channel + (I1(:,:,3)-Max_dark_channel)./t2); 
figure; 
imshow(J);

NIQE = niqe(J);
FADE=FADE(J);
% MSE = immse(J,I_C);  % matlab �Դ�����
% PSNR = psnr(I_C, J); 
% [SSIM,SSM]=ssim(I_C, J);
 AINAL=zeros(1,5);
%  AINAL(1,1)=PSNR;
%  AINAL(1,2)=MSE;
%  AINAL(1,3)=SSIM;
 AINAL(1,1)=FADE;
 AINAL(1,2)=NIQE;



 

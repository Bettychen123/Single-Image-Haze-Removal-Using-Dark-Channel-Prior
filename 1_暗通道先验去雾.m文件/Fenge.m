%=========================================================%
%���ù��򣺣�����ʱ���ã����򲻵��ã�
%ʵ�ʲ���ʱ,according to experiments��
%percent=under_50/total
%percent<0.1%,ȡw=0.6
%percent>0.1%&&percent<1%,ȡw=0.45
%percenet>1%&&percent<2%,ȡw=0.3
%else not use haze-free-adjust
%�������Ƴ���ֱ��ͼ<50�Ĳ���<1%
%������̨�������ԭͼ��under_50���ص���ռ����
%=========================================================%
close all
clear all
clc
blockSize=15;               %ÿ��blockΪ15������
w0=0.6;                    
t0=0.1;
% A=200;
I=imread('22.png');
%I=imread('C:\Users\Zrq\Desktop\ͬ��.jpg');

%set(gcf,'outerposition',get(0,'screensize'));%���SystemScreenSize ���ݸ���ǰͼ����gcf��outerposition����
%subplot(321)%��ʾ3��������*2����������ͼ��1��������ͼ�ε����
figure;
imshow(I);
title('Original Image');
%subplot(323);
figure;
grayI=rgb2gray(I);
imshow(grayI,[]);
title('ԭͼ��Ҷ�ͼ')
%subplot(324);
imhist(grayI,64);
%ͳ��<50��������ռ�ı���
%%%%%%%%%%%%%%%%%%%%%%
[COUNT x]=imhist(grayI);
under_50=0;
for i=0:50
    under_50=under_50+COUNT(x==i);
end
under_50
total=size(I,1)*size(I,2)*size(I,3);
percent=under_50/total
%%%%%%%%%%%%%%%%%%%%%%
%if(percent>0.02)
    %('This image need not Haze-Free-Proprocessing.');%
 if(percent<0.001)
        w=0.6;
    else if (percent>0.01)
            w=0.3;
        else
            w=0.45;
        end
    end

 
[h,w,s]=size(I);
min_I=zeros(h,w);
 
for i=1:h                 
    for j=1:w
        dark_I(i,j)=min(I(i,j,:));%ȡÿ���������ΪRGB��������͵��Ǹ�ͨ����ֵ
    end
end
 
Max_dark_channel=double(max(max(dark_I)))
dark_channel=double(dark_I);
t=1-w0*(dark_channel/Max_dark_channel);
 
T=uint8(t*255);
 
t=max(t,t0);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I1=double(I);
J(:,:,1) = uint8((I1(:,:,1) - (1-t)*Max_dark_channel)./t);
 
J(:,:,2) = uint8((I1(:,:,2) - (1-t)*Max_dark_channel)./t);
 
J(:,:,3) =uint8((I1(:,:,3) - (1-t)*Max_dark_channel)./t);
%subplot(322)
figure;
imshow(J);
imwrite(J,'tj2.jpg');
title('Haze-Free Image:');
 
%subplot(325);
figure;
grayJ=rgb2gray(J);
imshow(grayJ,[]);
title('ȥ���Ҷ�ͼ')
 
%subplot(326);
figure;
imhist(grayJ,64);
clc;clear;close all;
w0=0.95;  %��������
t0=0.00001; %����͸���ʼ����г�����ʱ��ʹ�����㵱��ĸ

I=imread('0578_0.95_0.2.jpg'); 
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
dark_I = ordfilt2(min_I,1,ones(6,6),'symmetric'); %���ڴ�С7*7������ÿ�ν�49��Ԫ�ؽ�������ȡ��С�� orfilt2Ϊ��ά˳���˲�����

Max_dark_channel=double(max(max(dark_I)));  %A 

dark_channel=double(dark_I); 
t=1-w0*(dark_channel/Max_dark_channel);   %��ʼt 
t1=max(t,t0); %���͸����ͼ�п��ܳ��ֵ���ֵ
figure; 
T=uint8(t1*255); 
imshow(T); 
title('͸����ͼ'); 
%��ɶ�ͼ��ĳ�ʼֵt�����

%maxfangcha�ָ��㷨
I_f=I
I_gray=rgb2gray(I_f);%ת��Ϊ�Ҷ�ͼ
figure;subplot(121),imshow(I);
%ת��Ϊ˫����
I_double=double(I_gray);
[wid,len]=size(I_gray);%ͼ��Ĵ�С
%�Ҷȼ�
colorLevel=256;
%ֱ��ͼ
hist=zeros(colorLevel,1);
%����ֱ��ͼ
for i=1:wid
    for j=1:len
        m=I_gray(i,j)+1;%ͼ��ĻҶȼ�m
        hist(m)=hist(m)+1;%�Ҷ�ֵΪi�����غ�
    end
end
%ֱ��ͼ��һ��
hist=hist/(wid*len);%���Ҷ�ֵ���� Pi
miuT=0;%���������ֵ
for m=1:colorLevel
    miuT=miuT+(m-1)*hist(m);  %�����ֵ
end
xigmaB2=0;%
for mindex=1:colorLevel
    threshold=mindex-1;%�趨��ֵ
    omega1=0;%Ŀ�����
    omega2=0;%��������
    for m=1:threshold-1
        omega1=omega1+hist(m);% Ŀ����� W0
    end
    omega2=1-omega1; %�����ĸ��� W1
    miu1=0;%Ŀ���ƽ���Ҷ�ֵ
    miu2=0;%������ƽ���Ҷ�ֵ
    for m=1:colorLevel
        if m<threshold
            miu1=miu1+(m-1)*hist(m);%Ŀ�� i*pi���ۼ�ֵ[1 threshold]
        else
            miu2=miu2+(m-1)*hist(m);%���� i*pi���ۼ�ֵ[threshold m]
        end
    end
    miu1=miu1/omega1;%Ŀ���ƽ���Ҷ�ֵ
    miu2=miu2/omega2;%������ƽ���Ҷ�ֵ
    xigmaB21=omega1*(miu1-miuT)^2+omega2*(miu2-miuT)^2;%��󷽲�
    xigma(mindex)=xigmaB21;%���趨һ��ֵ �ٱ������лҶȼ�
    %�ҵ�xigmaB21��ֵ���
    if xigmaB21>xigmaB2
        finalT=threshold;%�ҵ���ֵ �Ҷȼ�
        xigmaB2=xigmaB21;%����Ϊ���
    end
end
%��ֵ��һ��
fT=finalT/255;
for i=1:wid
     for j=1:len
         if I_double(i,j)>finalT %�������趨�ľ�ֵ ��ΪĿ��
             bin(i,j)=0;
         else
             bin(i,j)=1;
         end
     end
end
subplot(122),imshow(bin);

se=strel('disk',20);
fc=imclose(bin,se);%ֱ�ӱ�����
fco=imopen(fc,se);%�ȱպ�����
figure;imshow(fco);
title('�ȱպ�����');
A4=fco;

I_sky(:,:,1)=double(I(:,:,1)).*A4;%���R
I_sky(:,:,2)=double(I(:,:,2)).*A4;%G
I_sky(:,:,3)=double(I(:,:,3)).*A4;%B
figure;imshow(I_sky)
title('�ָ������');

B4=~A4;%���������
I_back(:,:,1)=double(I(:,:,1)).*B4;%����
I_back(:,:,2)=double(I(:,:,2)).*B4;
I_back(:,:,3)=double(I(:,:,3)).*B4;
figure;imshow(I_back);title('�ָ��ı���');


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


r=30;
eps=10^-6;
filtered = guidedfilter_color(double(I),t1,r, eps);%�����˲�
t2=filtered;

figure;
T=uint8(t2*255); 
imshow(T); 
title('�����˲�͸����ͼ'); 


I1=double(I);   %����ȥ��ͼ��
J(:,:,1) = uint8(Max_dark_channel_sky + (I_back(:,:,1)-Max_dark_channel_sky)./t2)+uint8(I_sky(:,:,1)); 
J(:,:,2) = uint8(Max_dark_channel_sky + (I_back(:,:,2)-Max_dark_channel_sky)./t2)+uint8(I_sky(:,:,2)); 
J(:,:,3) = uint8(Max_dark_channel_sky + (I_back(:,:,3)-Max_dark_channel_sky)./t2)+uint8(I_sky(:,:,3)); 
figure; 
imshow(J); 
title('���ڰ�ͨ������ԭ���ȥ��ͼ��'); 
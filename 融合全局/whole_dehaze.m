clc;clear;close all;
w0=0.95;  %��������
t0=0.0001; %����͸���ʼ����г�����ʱ��ʹ�����㵱��ĸ

I=imread('duck.jpg'); 
figure; 
imshow(I); title('ԭͼ');
I_g=rgb2gray(I);%�Ѳ�ɫͼ��Ҷ�ͼ

[h,w,s]=size(I); %��s=3��ԭ������Ϊ��Ϊ��ɫͼƬ
min_I=zeros(h,w);                                                                                                                                                              
% ������С����ͶӰ��������
hsv = rgb2hsv(I);
V = hsv(:,:,3); % ��ȡ����
V_lmean=sum(V)/h;%��ȡÿ�����Ⱥ͵�ƽ��ֵ
k=1;
R_sum=zeros(1,w);%��ȡ�涨��Χ������ʽ֮��
for i=1:w-2*k%δ��������
    for j=i:2*k+i
    R_sum(i)=R_sum(i)+V_lmean(j);
    end
end
for i=w-2*k:w%��������
    for j=i:w
    R_sum(i)=R_sum(i)+V_lmean(j);
end
end
%��ȡ��ֵ
R_mean=R_sum./(2*k+1);
[ans,pos]=sort(R_sum,'descend');%pos���Ƕ���Ԫ�ص�λ����Ϣ 1-3��Ϊ��Ӧ���������ֵ���±�

S_y=zeros(1,3);%���ڴ��3�����ֵ��Ӧ�ķ���
for i=1:3
  for j=pos(i):pos(i)+2*k
    S_y(i)=(S_y(i)+(R_sum(j)-R_mean(pos(i)))^2)/(2*k+1);
  end
end
[fans,fpos]=sort(S_y,'descend');
y_A=pos(fpos(1));%��ô������ѡ�����������


V_hmean=sum(V,2)/w;%��ȡÿ�����Ⱥ͵�ƽ��ֵ
V_hmean=V_hmean';
k=1;
R_hsum=zeros(1,h);%��ȡ�涨��Χ������ʽ֮��
for i=1:h-2*k%δ��������
    for j=i:2*k+i
    R_hsum(i)=R_hsum(i)+V_hmean(j);
    end
end
for i=h-2*k:h%��������
    for j=i:h
    R_hsum(i)=R_hsum(i)+V_hmean(j);
end
end
%��ȡ��ֵ
R_hmean=R_hsum./(2*k+1);
[ansh,posh]=sort(R_hsum,'descend');%pos���Ƕ���Ԫ�ص�λ����Ϣ 1-3��Ϊ��Ӧ���������ֵ���±�

S_x=zeros(1,3);%���ڴ��3�����ֵ��Ӧ�ķ���
for i=1:3
  for j=posh(i):posh(i)+2*k
    S_x(i)=(S_x(i)+(R_hsum(j)-R_hmean(posh(i)))^2)/(2*k+1);
  end
end
[fhans,fhpos]=sort(S_x,'descend');
x_A=posh(fhpos(1));%��ô������ѡ�����������

I_A1=zeros(2*k+1,2*k+1);%���ô������ѡ��
x=x_A-k-1;y=y_A-k-1;%�������ʹ��

if x_A-k>=1&&x_A+k<=h&&y_A-k>=1&&y_A+k<=w%������Χ
for i=x_A-k:x_A+k%��
    for j=y_A-k:y_A+k%��
        I_A1(i-x,j-y)=I_g(i,j);
    end
end
end

  if x_A-k<1&&y_A-k<1|| x_A-k<1&&y_A-k>1||x_A-k>1&&y_A-k<1%���Ͻ�
      for i=1:1+k%��
    for j=1:1+k%��
        I_A1(i,j)=I_g(i,j);
    end
end
  end
  
if x_A-k<1&&y_A+k>w||x_A-k<1&&y_A+k<w||x_A-k>1&&y_A+k>w%���½�
 for i=1:1+k%��
    for j=w-k:w%��
        I_A1(i,j-w+k+1)=I_g(i,j);
    end
end
end
  
if x_A+k>h&&y_A-k<1||x_A+k>h&&y_A-k>1||x_A+k<h&&y_A-k<1%���Ͻ�
      for i=h-k:h%��
    for j=1:1+k%��
        I_A1(i-h+k+1,j)=I_g(i,j);
    end
end
end
  
if x_A+k>h&&y_A+k>w||x_A+k>h&&y_A-k<w||x_A+k<h&&y_A+k>w%���½�
      for i=h-k:h%��
    for j=w-k:w%��
        I_A1(i-h+k+1,j-w+k+1)=I_g(i,j);
    end
end
end     
A1=median(I_A1(:));

%���ڳ�����ȵ�������������A
for i=1:h                   %��ȡ��ͨ����Сֵ            
    for j=1:w 
        min_I(i,j)=min(I(i,j,:)); %��ȡR G B��ͨ������Сֵ
    end 
end 
%��Сֵ�˲�
dark_I = ordfilt2(min_I,1,ones(6,6),'symmetric'); %���ڴ�С6*6������ÿ�ν�49��Ԫ�ؽ�������ȡ��С�� orfilt2Ϊ��ά˳���˲�����
dark_channel=double(dark_I); 
M=uint8(dark_I);%��ɾ���������ʾ
figure;
imshow(M);

%K_means����
[m, n, p] = size(dark_I);
k = 5;
[C_A,C, label, J] = kmeans(dark_I, k);%C_AΪ��ȡ�����������
I_seg = reshape(C_A(label, :), m, n, p);%��ԭ���󱻷�Ϊͬһ����������ֵ�滻��
figure
imshow(I, []), title('ԭͼ') 
figure
imshow(uint8(I_seg), []), title('����ͼ')
figure
plot(1:length(J), J), xlabel('#iterations')

Z=zeros(k,1);
%�ںϴ������㷨
Y=reshape(label, h,w);
for i=1:k
    Z(i,1)=1;
    I_sega(:,:,i) = reshape(Z(label, :), m, n, p)
     Z(i,1)=0;
end%ȡ���ֺõ�ͼ���


%%��������
C_B=C_A./255;
A_sum=zeros(k,1);
for i=1:k
    if(C_B(i,1)>0.75)
    A_sum(i,1)=A1*0.4+0.4*C_A(i,1);
    else
        A_sum(i,1)=A1*0.49+0.41*C_A(i,1);
    end
end

Q1=dark_channel.*I_sega(:,:,1);
Q2=dark_channel.*I_sega(:,:,2);
Q3=dark_channel.*I_sega(:,:,3);
Q4=dark_channel.*I_sega(:,:,4);
Q5=dark_channel.*I_sega(:,:,5);


t_com=(1-w0*(Q1/A_sum(1,1)-w0*(Q2/A_sum(2,1))-w0*(Q3/A_sum(3,1)))-w0*(Q4/A_sum(4,1))-w0*(Q5/A_sum(5,1)));   %t 


T=uint8(t_com); 
imshow(T); 
title('͸����ͼ'); 
 
t1=max(t_com,t0); %���͸����ͼ�п��ܳ��ֵ���ֵ



r=60;
eps=10^-6;
filtered = guidedfilter(double(rgb2gray(I))/255, t1, r, eps);
%filtered=guidedfilter_color(double(I/255),t1, r, eps);%��ɫ�����˲�
t1=filtered;

figure;
T=uint8(t1*255); 
imshow(T); 
title('�˲�͸����ͼ'); 


I_dou=double(I);   %����ȥ��ͼ��
A_sum=double(A_sum);

I1=I_dou.*I_sega(:,:,1);
I2=I_dou.*I_sega(:,:,2);
I3=I_dou.*I_sega(:,:,3);
I4=I_dou.*I_sega(:,:,4);
I5=I_dou.*I_sega(:,:,5);

J1(:,:,1) = uint8(A_sum(1,1) + (I1(:,:,1)-A_sum(1,1))./t1); 
J1(:,:,2) = uint8(A_sum(1,1) + (I1(:,:,2)-A_sum(1,1))./t1); 
J1(:,:,3) = uint8(A_sum(1,1) + (I1(:,:,3)-A_sum(1,1))./t1); 

J2(:,:,1) = uint8(A_sum(2,1) + (I2(:,:,1)-A_sum(2,1))./t1); 
J2(:,:,2) = uint8(A_sum(2,1) + (I2(:,:,2)-A_sum(2,1))./t1); 
J2(:,:,3) = uint8(A_sum(2,1) + (I2(:,:,3)-A_sum(2,1))./t1); 

J3(:,:,1) = uint8(A_sum(3,1) + (I3(:,:,1)-A_sum(3,1))./t1); 
J3(:,:,2) = uint8(A_sum(3,1) + (I3(:,:,2)-A_sum(3,1))./t1); 
J3(:,:,3) = uint8(A_sum(3,1) + (I3(:,:,3)-A_sum(3,1))./t1); 

J4(:,:,1) = uint8(A_sum(4,1) + (I4(:,:,1)-A_sum(4,1))./t1); 
J4(:,:,2) = uint8(A_sum(4,1) + (I4(:,:,2)-A_sum(4,1))./t1); 
J4(:,:,3) = uint8(A_sum(4,1) + (I4(:,:,3)-A_sum(4,1))./t1); 

J5(:,:,1) = uint8(A_sum(5,1) + (I5(:,:,1)-A_sum(5,1))./t1); 
J5(:,:,2) = uint8(A_sum(5,1) + (I5(:,:,2)-A_sum(5,1))./t1); 
J5(:,:,3) = uint8(A_sum(5,1) + (I5(:,:,3)-A_sum(5,1))./t1); 

J=J1+J2+J3+J4+J5;
figure; 
imshow(J); 
title('�����ں�ȫ��ԭ���ȥ��ͼ��'); 
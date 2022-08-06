clc;clear;close all;
w0=0.95;  %��������
t0=0.0001; %����͸���ʼ����г�����ʱ��ʹ�����㵱��ĸ

I=imread('0007_0.8_0.1.jpg');
I_C=imread('0007.jpg');
figure; 
imshow(I); title('ԭͼ');
I_g=rgb2gray(I);%�Ѳ�ɫͼ��Ҷ�ͼ

[h,w,s]=size(I); %��s=3��ԭ������Ϊ��Ϊ��ɫͼƬ
min_I=zeros(h,w);                                                                                                                                                              
% ������С����ͶӰ��������
hsv = rgb2hsv(I);
R = hsv(:,:,3); % ��ȡ����
V_lmean=sum(R)/h;%��ȡÿ�����Ⱥ͵�ƽ��ֵ
r=1;
R_sum=zeros(3,w);%��ȡ�涨��Χ������ʽ֮��
R_sum(1,:)=V_lmean
R_sum=boxfilter(R_sum, r)%��ȡ�涨��Χ������ʽ֮��
R_sum=R_sum(1,:)

%��ȡ��ֵ
R_mean=R_sum./(2*r+1);
[ans,pos]=sort(R_sum,'descend');%pos���Ƕ���Ԫ�ص�λ����Ϣ 1-3��Ϊ��Ӧ���������ֵ���±�

S_y=zeros(1,3);%���ڴ��3�����ֵ��Ӧ�ķ���
for i=1:3
  for j=pos(i):pos(i)+2*r
    S_y(i)=(S_y(i)+(R_sum(j)-R_mean(pos(i)))^2)/(2*r+1);
  end
end
[fans,fpos]=sort(S_y,'descend');
y_A=pos(fpos(1));%��ô������ѡ�����������


V_hmean=sum(R,2)/w;%��ȡÿ�����Ⱥ͵�ƽ��ֵ
V_hmean=V_hmean';
R_hsum=zeros(3,h);%��ȡ�涨��Χ������ʽ֮��
R_hsum(1,:)=V_hmean
R_hsum=boxfilter(R_hsum, r)%��ȡ�涨��Χ������ʽ֮��
R_hsum=R_hsum(1,:)

%��ȡ��ֵ
R_hmean=R_hsum./(2*r+1);
[ansh,posh]=sort(R_hsum,'descend');%pos���Ƕ���Ԫ�ص�λ����Ϣ 1-3��Ϊ��Ӧ���������ֵ���±�

S_x=zeros(1,3);%���ڴ��3�����ֵ��Ӧ�ķ���
for i=1:3
  for j=posh(i):posh(i)+2*r
    S_x(i)=(S_x(i)+(R_hsum(j)-R_hmean(posh(i)))^2)/(2*r+1);
  end
end
[fhans,fhpos]=sort(S_x,'descend');
x_A=posh(fhpos(1));%��ô������ѡ�����������

I_A1=zeros(2*r+1,2*r+1);%���ô������ѡ��
x=x_A-r-1;y=y_A-r-1;%�������ʹ��

if x_A-r>=1&&x_A+r<=h&&y_A-r>=1&&y_A+r<=w%������Χ
for i=x_A-r:x_A+r%��
    for j=y_A-r:y_A+r%��
        I_A1(i-x,j-y)=I_g(i,j);
    end
end
end

  if x_A-r<1&&y_A-r<1|| x_A-r<1&&y_A-r>1||x_A-r>1&&y_A-r<1%���Ͻ�
      for i=1:1+r%��
    for j=1:1+r%��
        I_A1(i,j)=I_g(i,j);
    end
end
  end
  
if x_A-r<1&&y_A+r>w||x_A-r<1&&y_A+r<w||x_A-r>1&&y_A+r>w%���½�
 for i=1:1+r%��
    for j=w-r:w%��
        I_A1(i,j-w+r+1)=I_g(i,j);
    end
end
end
  
if x_A+r>h&&y_A-r<1||x_A+r>h&&y_A-r>1||x_A+r<h&&y_A-r<1%���Ͻ�
      for i=h-r:h%��
    for j=1:1+r%��
        I_A1(i-h+r+1,j)=I_g(i,j);
    end
end
end
  
if x_A+r>h&&y_A+r>w||x_A+r>h&&y_A-r<w||x_A+r<h&&y_A+r>w%���½�
      for i=h-r:h%��
    for j=w-r:w%��
        I_A1(i-h+r+1,j-w+r+1)=I_g(i,j);
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
k = 2;
[C_A,C,label, R] = kmeans(dark_I, k);%C_AΪ��ȡ����������� CΪ�������� labelΪ�����ݴ��2��ǩ��JΪ���յľ���
I_seg = reshape(C(label, :), m, n, p);%��ԭ���󱻷�Ϊͬһ����������ֵ�滻��
figure;
imshow(I, []), title('ԭͼ') ;
figure;
imshow(uint8(I_seg), []), title('����ͼ');
figure;
plot(1:length(R), R), xlabel('#iterations');

 %���������ǩ���������������ʹ��
 tj=tabulate(label(:));
 tj=tj(:,2,:);
 tj_qian=tj./100;
J=zeros(k,1);
%�ںϴ������㷨
Y=reshape(label, h,w);
for i=1:k;
    J(i,1)=1;
    I_sega(:,:,i) = reshape(J(label, :), m, n, p);
     J(i,1)=0;
end%ȡ���ֺõ�ͼ���


 for p=1:k;
     V_fg=dark_I.*I_sega(:,:,p);
     M=sort(V_fg(:),'descend');
     M=M';
 for i=1:tj_qian(p,1);
      s=s+M(i);
 end
   AQ(p,1)=s/tj_qian(p,1);%AQ_dark
    end 
A_F=reshape(AQ(label, :), m, n);%��ԭ�����Ա���е����˲�
r=10;
eps=10^-6;
filtered = guidedfilter(double(rgb2gray(I))/255,A_F,r, eps);%�Ե����˲�
A_F=filtered;

%%��������
A_sum=zeros(h,w);
C_B=A_F./255;
for i=1:h;
  for j=1:w;
    if(C_B(i,j)>0.75)
    A_sum(i,j)=A1*0.6+0.3*A_F(i,j);
    else
        A_sum(i,j)=A1*0.69+0.21*A_F(i,j);
    end
  end
end

t=1-w0*(dark_channel./A_sum);   %��ʼt 
t1=max(t,t0); %���͸����ͼ�п��ܳ��ֵ���ֵ
figure; 
T=uint8(t1*255); 
imshow(T); 
title('͸����ͼ'); 
%��ɶ�ͼ��ĳ�ʼֵt�����

% r=10;
% eps=10^-6;
%filtered = imguidedfilter(double(rgb2gray(I))/255,t1);%��Ȩ�����˲�
filtered = guidedfilter(double(rgb2gray(I))/255,t1,r, eps);%��Ȩ�����˲�

t2=filtered;

figure;
T=uint8(t2*255); 
imshow(T); 
title('��Ȩ�����˲�͸����ͼ'); 

I1=double(I);   %����ȥ��ͼ��
G(:,:,1) = uint8(A_sum + (I1(:,:,1)-A_sum)./t2);
G(:,:,2) =uint8(A_sum + (I1(:,:,2)-A_sum)./t2) ;
G(:,:,3) = uint8(A_sum + (I1(:,:,3)-A_sum)./t2);
MSE = immse(G,I_C);  % matlab �Դ�����
PSNR = psnr(I_C,G); 
[SSIM,SSM]=ssim(I_C, G);
figure; 
imshow(G); 
title('����ȫ���ں�ԭ���ȥ��ͼ��');  
clc;clear;close all;
w0=0.95;  %保留因子
t0=0.0001; %避免透射率计算中出现零时，使用了零当分母

I=imread('duck.jpg'); 
figure; 
imshow(I); title('原图');
I_g=rgb2gray(I);%把彩色图变灰度图

[h,w,s]=size(I); %有s=3的原因是因为其为彩色图片
min_I=zeros(h,w);                                                                                                                                                              
% 基于最小方差投影求解大气光
hsv = rgb2hsv(I);
V = hsv(:,:,3); % 求取亮度
V_lmean=sum(V)/h;%求取每列亮度和的平均值
k=1;
R_sum=zeros(1,w);%求取规定范围的行列式之和
for i=1:w-2*k%未超过部分
    for j=i:2*k+i
    R_sum(i)=R_sum(i)+V_lmean(j);
    end
end
for i=w-2*k:w%超过部分
    for j=i:w
    R_sum(i)=R_sum(i)+V_lmean(j);
end
end
%求取均值
R_mean=R_sum./(2*k+1);
[ans,pos]=sort(R_sum,'descend');%pos即是对于元素的位置信息 1-3即为对应的最大三个值的下标

S_y=zeros(1,3);%用于存放3个最大值对应的方差
for i=1:3
  for j=pos(i):pos(i)+2*k
    S_y(i)=(S_y(i)+(R_sum(j)-R_mean(pos(i)))^2)/(2*k+1);
  end
end
[fans,fpos]=sort(S_y,'descend');
y_A=pos(fpos(1));%求得大气光候选区域的列坐标


V_hmean=sum(V,2)/w;%求取每行亮度和的平均值
V_hmean=V_hmean';
k=1;
R_hsum=zeros(1,h);%求取规定范围的行列式之和
for i=1:h-2*k%未超过部分
    for j=i:2*k+i
    R_hsum(i)=R_hsum(i)+V_hmean(j);
    end
end
for i=h-2*k:h%超过部分
    for j=i:h
    R_hsum(i)=R_hsum(i)+V_hmean(j);
end
end
%求取均值
R_hmean=R_hsum./(2*k+1);
[ansh,posh]=sort(R_hsum,'descend');%pos即是对于元素的位置信息 1-3即为对应的最大三个值的下标

S_x=zeros(1,3);%用于存放3个最大值对应的方差
for i=1:3
  for j=posh(i):posh(i)+2*k
    S_x(i)=(S_x(i)+(R_hsum(j)-R_hmean(posh(i)))^2)/(2*k+1);
  end
end
[fhans,fhpos]=sort(S_x,'descend');
x_A=posh(fhpos(1));%求得大气光候选区域的行坐标

I_A1=zeros(2*k+1,2*k+1);%放置大气光候选区
x=x_A-k-1;y=y_A-k-1;%方便后续使用

if x_A-k>=1&&x_A+k<=h&&y_A-k>=1&&y_A+k<=w%正常范围
for i=x_A-k:x_A+k%行
    for j=y_A-k:y_A+k%列
        I_A1(i-x,j-y)=I_g(i,j);
    end
end
end

  if x_A-k<1&&y_A-k<1|| x_A-k<1&&y_A-k>1||x_A-k>1&&y_A-k<1%左上角
      for i=1:1+k%行
    for j=1:1+k%列
        I_A1(i,j)=I_g(i,j);
    end
end
  end
  
if x_A-k<1&&y_A+k>w||x_A-k<1&&y_A+k<w||x_A-k>1&&y_A+k>w%左下角
 for i=1:1+k%行
    for j=w-k:w%列
        I_A1(i,j-w+k+1)=I_g(i,j);
    end
end
end
  
if x_A+k>h&&y_A-k<1||x_A+k>h&&y_A-k>1||x_A+k<h&&y_A-k<1%右上角
      for i=h-k:h%行
    for j=1:1+k%列
        I_A1(i-h+k+1,j)=I_g(i,j);
    end
end
end
  
if x_A+k>h&&y_A+k>w||x_A+k>h&&y_A-k<w||x_A+k<h&&y_A+k>w%右下角
      for i=h-k:h%行
    for j=w-k:w%列
        I_A1(i-h+k+1,j-w+k+1)=I_g(i,j);
    end
end
end     
A1=median(I_A1(:));

%基于场景深度的区域大气光求解A
for i=1:h                   %获取三通道最小值            
    for j=1:w 
        min_I(i,j)=min(I(i,j,:)); %获取R G B三通道的最小值
    end 
end 
%最小值滤波
dark_I = ordfilt2(min_I,1,ones(6,6),'symmetric'); %窗口大小6*6即共计每次将49个元素进行排序取最小的 orfilt2为二维顺序滤波函数
dark_channel=double(dark_I); 
M=uint8(dark_I);%变成矩阵后才能显示
figure;
imshow(M);

%K_means聚类
[m, n, p] = size(dark_I);
k = 5;
[C_A,C, label, J] = kmeans(dark_I, k);%C_A为求取的区域大气光
I_seg = reshape(C_A(label, :), m, n, p);%将原矩阵被分为同一类别的用中心值替换掉
figure
imshow(I, []), title('原图') 
figure
imshow(uint8(I_seg), []), title('聚类图')
figure
plot(1:length(J), J), xlabel('#iterations')

Z=zeros(k,1);
%融合大气光算法
Y=reshape(label, h,w);
for i=1:k
    Z(i,1)=1;
    I_sega(:,:,i) = reshape(Z(label, :), m, n, p)
     Z(i,1)=0;
end%取出分好的图像块


%%亮度抑制
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
title('透射率图'); 
 
t1=max(t_com,t0); %清除透射率图中可能出现的零值



r=60;
eps=10^-6;
filtered = guidedfilter(double(rgb2gray(I))/255, t1, r, eps);
%filtered=guidedfilter_color(double(I/255),t1, r, eps);%彩色导向滤波
t1=filtered;

figure;
T=uint8(t1*255); 
imshow(T); 
title('滤波透射率图'); 


I_dou=double(I);   %计算去雾图像
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
title('基于融合全局原理的去雾图像'); 
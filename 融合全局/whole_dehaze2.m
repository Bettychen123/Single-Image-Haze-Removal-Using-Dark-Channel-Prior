clc;clear;close all;
w0=0.95;  %保留因子
t0=0.0001; %避免透射率计算中出现零时，使用了零当分母

I=imread('0007_0.8_0.1.jpg');
I_C=imread('0007.jpg');
figure; 
imshow(I); title('原图');
I_g=rgb2gray(I);%把彩色图变灰度图

[h,w,s]=size(I); %有s=3的原因是因为其为彩色图片
min_I=zeros(h,w);                                                                                                                                                              
% 基于最小方差投影求解大气光
hsv = rgb2hsv(I);
R = hsv(:,:,3); % 求取亮度
V_lmean=sum(R)/h;%求取每列亮度和的平均值
r=1;
R_sum=zeros(3,w);%求取规定范围的行列式之和
R_sum(1,:)=V_lmean
R_sum=boxfilter(R_sum, r)%求取规定范围的行列式之和
R_sum=R_sum(1,:)

%求取均值
R_mean=R_sum./(2*r+1);
[ans,pos]=sort(R_sum,'descend');%pos即是对于元素的位置信息 1-3即为对应的最大三个值的下标

S_y=zeros(1,3);%用于存放3个最大值对应的方差
for i=1:3
  for j=pos(i):pos(i)+2*r
    S_y(i)=(S_y(i)+(R_sum(j)-R_mean(pos(i)))^2)/(2*r+1);
  end
end
[fans,fpos]=sort(S_y,'descend');
y_A=pos(fpos(1));%求得大气光候选区域的列坐标


V_hmean=sum(R,2)/w;%求取每行亮度和的平均值
V_hmean=V_hmean';
R_hsum=zeros(3,h);%求取规定范围的行列式之和
R_hsum(1,:)=V_hmean
R_hsum=boxfilter(R_hsum, r)%求取规定范围的行列式之和
R_hsum=R_hsum(1,:)

%求取均值
R_hmean=R_hsum./(2*r+1);
[ansh,posh]=sort(R_hsum,'descend');%pos即是对于元素的位置信息 1-3即为对应的最大三个值的下标

S_x=zeros(1,3);%用于存放3个最大值对应的方差
for i=1:3
  for j=posh(i):posh(i)+2*r
    S_x(i)=(S_x(i)+(R_hsum(j)-R_hmean(posh(i)))^2)/(2*r+1);
  end
end
[fhans,fhpos]=sort(S_x,'descend');
x_A=posh(fhpos(1));%求得大气光候选区域的行坐标

I_A1=zeros(2*r+1,2*r+1);%放置大气光候选区
x=x_A-r-1;y=y_A-r-1;%方便后续使用

if x_A-r>=1&&x_A+r<=h&&y_A-r>=1&&y_A+r<=w%正常范围
for i=x_A-r:x_A+r%行
    for j=y_A-r:y_A+r%列
        I_A1(i-x,j-y)=I_g(i,j);
    end
end
end

  if x_A-r<1&&y_A-r<1|| x_A-r<1&&y_A-r>1||x_A-r>1&&y_A-r<1%左上角
      for i=1:1+r%行
    for j=1:1+r%列
        I_A1(i,j)=I_g(i,j);
    end
end
  end
  
if x_A-r<1&&y_A+r>w||x_A-r<1&&y_A+r<w||x_A-r>1&&y_A+r>w%左下角
 for i=1:1+r%行
    for j=w-r:w%列
        I_A1(i,j-w+r+1)=I_g(i,j);
    end
end
end
  
if x_A+r>h&&y_A-r<1||x_A+r>h&&y_A-r>1||x_A+r<h&&y_A-r<1%右上角
      for i=h-r:h%行
    for j=1:1+r%列
        I_A1(i-h+r+1,j)=I_g(i,j);
    end
end
end
  
if x_A+r>h&&y_A+r>w||x_A+r>h&&y_A-r<w||x_A+r<h&&y_A+r>w%右下角
      for i=h-r:h%行
    for j=w-r:w%列
        I_A1(i-h+r+1,j-w+r+1)=I_g(i,j);
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
k = 2;
[C_A,C,label, R] = kmeans(dark_I, k);%C_A为求取的区域大气光 C为聚类中心 label为给数据打的2标签，J为最终的距离
I_seg = reshape(C(label, :), m, n, p);%将原矩阵被分为同一类别的用中心值替换掉
figure;
imshow(I, []), title('原图') ;
figure;
imshow(uint8(I_seg), []), title('聚类图');
figure;
plot(1:length(R), R), xlabel('#iterations');

 %计算各个标签的数量，方便后期使用
 tj=tabulate(label(:));
 tj=tj(:,2,:);
 tj_qian=tj./100;
J=zeros(k,1);
%融合大气光算法
Y=reshape(label, h,w);
for i=1:k;
    J(i,1)=1;
    I_sega(:,:,i) = reshape(J(label, :), m, n, p);
     J(i,1)=0;
end%取出分好的图像块


 for p=1:k;
     V_fg=dark_I.*I_sega(:,:,p);
     M=sort(V_fg(:),'descend');
     M=M';
 for i=1:tj_qian(p,1);
      s=s+M(i);
 end
   AQ(p,1)=s/tj_qian(p,1);%AQ_dark
    end 
A_F=reshape(AQ(label, :), m, n);%复原矩阵以便进行导向滤波
r=10;
eps=10^-6;
filtered = guidedfilter(double(rgb2gray(I))/255,A_F,r, eps);%对导向滤波
A_F=filtered;

%%亮度抑制
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

t=1-w0*(dark_channel./A_sum);   %初始t 
t1=max(t,t0); %清除透射率图中可能出现的零值
figure; 
T=uint8(t1*255); 
imshow(T); 
title('透射率图'); 
%完成对图像的初始值t的求解

% r=10;
% eps=10^-6;
%filtered = imguidedfilter(double(rgb2gray(I))/255,t1);%加权导向滤波
filtered = guidedfilter(double(rgb2gray(I))/255,t1,r, eps);%加权导向滤波

t2=filtered;

figure;
T=uint8(t2*255); 
imshow(T); 
title('加权导向滤波透射率图'); 

I1=double(I);   %计算去雾图像
G(:,:,1) = uint8(A_sum + (I1(:,:,1)-A_sum)./t2);
G(:,:,2) =uint8(A_sum + (I1(:,:,2)-A_sum)./t2) ;
G(:,:,3) = uint8(A_sum + (I1(:,:,3)-A_sum)./t2);
MSE = immse(G,I_C);  % matlab 自带函数
PSNR = psnr(I_C,G); 
[SSIM,SSM]=ssim(I_C, G);
figure; 
imshow(G); 
title('基于全局融合原理的去雾图像');  
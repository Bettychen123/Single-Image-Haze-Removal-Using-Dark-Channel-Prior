img = imread('22.PNG');%原图
  I_gray=rgb2gray(img);%转换为灰度图
 
figure;subplot(121),imshow(img);
%转换为双精度
I_double=double(I_gray);
[wid,len]=size(I_gray);%图像的大小
%灰度级
colorLevel=256;
%直方图
hist=zeros(colorLevel,1);
%计算直方图
for i=1:wid
    for j=1:len
        m=I_gray(i,j)+1;%图像的灰度级m
        hist(m)=hist(m)+1;%灰度值为i的像素和
    end
end
%直方图归一化
hist=hist/(wid*len);%各灰度值概率 Pi
miuT=0;%定义总体均值
for m=1:colorLevel
    miuT=miuT+(m-1)*hist(m);  %总体均值
end
xigmaB2=0;%
for mindex=1:colorLevel
    threshold=mindex-1;%设定阈值
    omega1=0;%目标概率
    omega2=0;%背景概率
    for m=1:threshold-1
        omega1=omega1+hist(m);% 目标概率 W0
    end
    omega2=1-omega1; %背景的概率 W1
    miu1=0;%目标的平均灰度值
    miu2=0;%背景的平均灰度值
    for m=1:colorLevel
        if m<threshold
            miu1=miu1+(m-1)*hist(m);%目标 i*pi的累加值[1 threshold]
        else
            miu2=miu2+(m-1)*hist(m);%背景 i*pi的累加值[threshold m]
        end
    end
    miu1=miu1/omega1;%目标的平均灰度值
    miu2=miu2/omega2;%背景的平均灰度值
    xigmaB21=omega1*(miu1-miuT)^2+omega2*(miu2-miuT)^2;%最大方差
    xigma(mindex)=xigmaB21;%先设定一个值 再遍历所有灰度级
    %找到xigmaB21的值最大
    if xigmaB21>xigmaB2
        finalT=threshold;%找到阈值 灰度级
        xigmaB2=xigmaB21;%方差为最大
    end
end
%阈值归一化
fT=finalT/255;
for i=1:wid
     for j=1:len
         if I_double(i,j)>finalT %大于所设定的均值 则为目标
             bin(i,j)=0;
         else
             bin(i,j)=1;
         end
     end
end
subplot(122),imshow(bin);

se=strel('disk',20);
fc=imclose(bin,se);%直接闭运算
fco=imopen(fc,se);%先闭后开运算
figure;imshow(fco);
title('先闭后开运算');
A4=fco;
I_sky(:,:,1)=double(I(:,:,1)).*A4;%天空R
I_sky(:,:,2)=double(I(:,:,2)).*A4;%G
I_sky(:,:,3)=double(I(:,:,3)).*A4;%B
figure;imshow(I_sky)
title('分割后的天空');

B4=~A4;%非天空区域
I_back(:,:,1)=double(I(:,:,1)).*B4;%背景
I_back(:,:,2)=double(I(:,:,2)).*B4;
I_back(:,:,3)=double(I(:,:,3)).*B4;
figure;imshow(I_back);title('分割后的背景');

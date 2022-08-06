clc;clear;close all;
I=imread('0219_0.8_0.1.jpg');       %读取图像
I_C=imread('0219.jpg');

R = I(:, :, 1);              %R通道的二维图像
G = I(:, :, 2);              %G通道的二维图像
B = I(:, :, 3);              %B通道的二维图像
R0 = im2double(R);        %将图像的数据类型转换为double类型
G0 = im2double(G);
B0 = im2double(B);
[N1, M1] = size(R);

a = 50;                %MSRCR算法中的调整参数
II = imadd(R0, G0);             
II = imadd(II, B0);       %将R、G、B三个通道的图叠加在一起
Ir = immultiply(R0, a);    %R通道的图像乘以调整参数
Ig = immultiply(G0, a);    %G通道的图像乘以调整参数
Ib = immultiply(B0, a);    %B通道的图像乘以调整参数

Rlog = log(R0+1);
Rfft2 = fft2(R0);

sigma1 = 128;          %尺度参数之一
F1 = fspecial('gaussian', [N1,M1], sigma1);       %建立高斯低通滤波算子
Efft1 = fft2(double(F1));
DR0 = Rfft2.* Efft1; %滤波算子和原始R通道图像进行卷积，得到空间平滑图像
DR = ifft2(DR0);
DRlog = log(DR +1);
Rr1 = Rlog - DRlog;  %R通道图像减去空间平滑图像，得到R通道的物体反射特性 
 

sigma2 = 256;        %尺度参数之一，同sigma1
F2 = fspecial('gaussian', [N1,M1], sigma2);
Efft2 = fft2(double(F2));
DR0 = Rfft2.* Efft2;
DR = ifft2(DR0);
DRlog = log(DR +1);
Rr2 = Rlog - DRlog;

sigma3 = 512;
F3 = fspecial('gaussian', [N1,M1], sigma3);
Efft3 = fft2(double(F3));
DR0 = Rfft2.* Efft3;
DR = ifft2(DR0);
DRlog = log(DR +1);
Rr3 = Rlog - DRlog;

Rr = (Rr1 + Rr2 +Rr3)/3;  %为三个尺度取权重因子
       
alpha = imdivide(Ir, II);   % alpha为彩色恢复因子
alpha = log(alpha+1);    

Rr = immultiply(alpha, Rr);  %将彩色恢复因子与得到的R通道物体反射特性相乘
EXPRr = exp(Rr);
MIN = min(min(EXPRr));
MAX = max(max(EXPRr));
EXPRr = (EXPRr - MIN)/(MAX - MIN);   %将输出量化
EXPRr = adapthisteq(EXPRr);     %进行直方图均衡

%G通道与R通道实现思路相同
Glog = log(G0+1);
Gfft2 = fft2(G0);

DG0 = Gfft2.* Efft1;
DG = ifft2(DG0);
DGlog = log(DG +1);
Gg1 = Glog - DGlog;

DG0 = Gfft2.* Efft2;
DG = ifft2(DG0);
DGlog = log(DG +1);
Gg2 = Glog - DGlog;

DG0 = Gfft2.* Efft3;
DG = ifft2(DG0);
DGlog = log(DG +1);
Gg3 = Glog - DGlog;

Gg = (Gg1 + Gg2 +Gg3)/3;

alpha = imdivide(Ig, II);
alpha = log(alpha+1);

Gg = immultiply(alpha, Gg);
EXPGg = exp(Gg);
MIN = min(min(EXPGg));
MAX = max(max(EXPGg));
EXPGg = (EXPGg - MIN)/(MAX - MIN);
EXPGg = adapthisteq(EXPGg);

%B通道与R通道实现思路相同
Blog = log(B0+1);
Bfft2 = fft2(B0);

DB0 = Bfft2.* Efft1;
DB = ifft2(DB0);
DBlog = log(DB +1);
Bb1 = Blog - DBlog;

DB0 = Bfft2.* Efft2;
DB = ifft2(DB0);
DBlog = log(DB +1);
Bb2 = Blog - DBlog;

DB0 = Bfft2.* Efft3;
DB = ifft2(DB0);
DBlog = log(DB +1);
Bb3 = Blog - DBlog;
Bb = (Bb1 + Bb2 +Bb3)/3;

alpha = imdivide(Ib, II);
alpha = log(alpha+1);

Bb = immultiply(alpha, Bb);
EXPBb = exp(Bb);
MIN = min(min(EXPBb));
MAX = max(max(EXPBb));
EXPBb = (EXPBb - MIN)/(MAX - MIN);
EXPBb = adapthisteq(EXPBb);

result = cat(3, EXPRr, EXPGg, EXPBb);  %将R、G、B三个图像的矩阵连结在一起
figure; imshow(I);title('原图')   %输出原图像
figure; imshow(result); title('多尺度Retinex理论去雾后') %输出处理后的图 
J=result;
NIQE = niqe(J);
FADE=FADE(J);
MSE = immse(J,I_C);  % matlab 自带函数
PSNR = psnr(I_C,J); 
[SSIM,SSM]=ssim(I_C, J);

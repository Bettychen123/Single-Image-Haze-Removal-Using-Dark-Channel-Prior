clc;clear;close all;
I=imread('0219_0.8_0.1.jpg');       %��ȡͼ��
I_C=imread('0219.jpg');

R = I(:, :, 1);              %Rͨ���Ķ�άͼ��
G = I(:, :, 2);              %Gͨ���Ķ�άͼ��
B = I(:, :, 3);              %Bͨ���Ķ�άͼ��
R0 = im2double(R);        %��ͼ�����������ת��Ϊdouble����
G0 = im2double(G);
B0 = im2double(B);
[N1, M1] = size(R);

a = 50;                %MSRCR�㷨�еĵ�������
II = imadd(R0, G0);             
II = imadd(II, B0);       %��R��G��B����ͨ����ͼ������һ��
Ir = immultiply(R0, a);    %Rͨ����ͼ����Ե�������
Ig = immultiply(G0, a);    %Gͨ����ͼ����Ե�������
Ib = immultiply(B0, a);    %Bͨ����ͼ����Ե�������

Rlog = log(R0+1);
Rfft2 = fft2(R0);

sigma1 = 128;          %�߶Ȳ���֮һ
F1 = fspecial('gaussian', [N1,M1], sigma1);       %������˹��ͨ�˲�����
Efft1 = fft2(double(F1));
DR0 = Rfft2.* Efft1; %�˲����Ӻ�ԭʼRͨ��ͼ����о�����õ��ռ�ƽ��ͼ��
DR = ifft2(DR0);
DRlog = log(DR +1);
Rr1 = Rlog - DRlog;  %Rͨ��ͼ���ȥ�ռ�ƽ��ͼ�񣬵õ�Rͨ�������巴������ 
 

sigma2 = 256;        %�߶Ȳ���֮һ��ͬsigma1
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

Rr = (Rr1 + Rr2 +Rr3)/3;  %Ϊ�����߶�ȡȨ������
       
alpha = imdivide(Ir, II);   % alphaΪ��ɫ�ָ�����
alpha = log(alpha+1);    

Rr = immultiply(alpha, Rr);  %����ɫ�ָ�������õ���Rͨ�����巴���������
EXPRr = exp(Rr);
MIN = min(min(EXPRr));
MAX = max(max(EXPRr));
EXPRr = (EXPRr - MIN)/(MAX - MIN);   %���������
EXPRr = adapthisteq(EXPRr);     %����ֱ��ͼ����

%Gͨ����Rͨ��ʵ��˼·��ͬ
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

%Bͨ����Rͨ��ʵ��˼·��ͬ
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

result = cat(3, EXPRr, EXPGg, EXPBb);  %��R��G��B����ͼ��ľ���������һ��
figure; imshow(I);title('ԭͼ')   %���ԭͼ��
figure; imshow(result); title('��߶�Retinex����ȥ���') %���������ͼ 
J=result;
NIQE = niqe(J);
FADE=FADE(J);
MSE = immse(J,I_C);  % matlab �Դ�����
PSNR = psnr(I_C,J); 
[SSIM,SSM]=ssim(I_C, J);

clc ;clear;close all;
I=imread('0054_0.8_0.16.jpg');
% I=imread('0179_0.8_0.2.jpg');
% I_C=imread('2586.jpg');
I=double(I)./255;           %��ͼ������ֵת����0-1�ڵ�double����
dim=size(I);

B1=zeros(dim);
B2=zeros(dim);

% I1=quwu(I);            %���÷�����ȥ����
% a=double(I1);
% for i=1:dim(1)
%     for j=1:dim(2)
%         B1(i,j,:)=1.3*a(i,j,:); 
%     end 
% end  
 
I2=quwu_plus(I);           %��������ȥ����
a=double(I2);
for i=1:dim(1)
    for j=1:dim(2)
        B2(i,j,:)=1.3*a(i,j,:); 
    end 
end  
J=uint8(double(B2.*255));
% 
 FADE=FADE(J);
 NIQE = niqe(J);
% MSE = immse(J,I_C);  % matlab �Դ�����
% PSNR = psnr(I_C,J); 
% 
% [SSIM,SSM]=ssim(J,I_C);
figure(1)                                       %��ʾͼ��
imshow(I,[]);title('ԭʼͼ��');
figure(2)
imshow(B1,[]);title('��������Ӧ˫���˲��ķ�����ȥ��ͼ��');
figure(3)
imshow(B2)
 AINAL=zeros(1,5);
%  AINAL(1,1)=PSNR;
%  AINAL(1,2)=MSE;
%  AINAL(1,3)=SSIM;
 AINAL(1,1)=FADE;
 AINAL(1,2)=NIQE;

                                    

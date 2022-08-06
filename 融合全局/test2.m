clear all; close all;
I = imread('traffic.jpg');
I=rgb2gray(I)
[m, n, p] = size(I);
k = 7;
[C, label, J] = kmeans(I, k);
I_seg = reshape(C(label, :), m, n, p);%��ԭ���󱻷�Ϊͬһ����������ֵ�滻��
figure
subplot(1, 2, 1), imshow(I, []), title('ԭͼ')
subplot(1, 2, 2), imshow(uint8(I_seg), []), title('����ͼ')
figure
plot(1:length(J), J), xlabel('#iterations')

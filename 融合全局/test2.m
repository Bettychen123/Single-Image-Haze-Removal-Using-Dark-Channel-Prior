clear all; close all;
I = imread('traffic.jpg');
I=rgb2gray(I)
[m, n, p] = size(I);
k = 7;
[C, label, J] = kmeans(I, k);
I_seg = reshape(C(label, :), m, n, p);%将原矩阵被分为同一类别的用中心值替换掉
figure
subplot(1, 2, 1), imshow(I, []), title('原图')
subplot(1, 2, 2), imshow(uint8(I_seg), []), title('聚类图')
figure
plot(1:length(J), J), xlabel('#iterations')

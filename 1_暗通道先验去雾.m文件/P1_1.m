%--------------------------------------
%���ͼ-��ͨ������ȥ�����͸����ͼ������ϸ�����⣬���������󣬺����ĵ����˲��Ľ����Խ��������
%���ߣ������ʵ��ѧͼ�����Ŷ�-�º�
clc;
clear;
close all;

img = imread('88.png');
figure;imshow(img);title('��ͼ');
De_img = anyuanse(img);
figure;imshow(De_img);title('ȥ��ͼ');

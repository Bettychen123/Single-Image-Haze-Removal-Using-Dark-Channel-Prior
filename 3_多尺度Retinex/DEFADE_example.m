% DEFADE example

clear all; close all; clc; 

image = imread('0001_0.8_0.2.jpg'); 
defogged_image = DEFADE(image);

figure; imshow(image); title('Input');
figure; imshow(defogged_image); title('Output');


%% For other test images, please use below:
% image2 = imread('test_image2.jpg'); 
% defogged_image2 = DEFADE(image2);

% image3 = imread('test_image3.jpg'); 
% defogged_image3 = DEFADE(image3);


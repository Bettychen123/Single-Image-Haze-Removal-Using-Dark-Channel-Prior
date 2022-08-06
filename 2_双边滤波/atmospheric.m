function B=atmospheric(I)
dark=darkChannel(I);  %获取图像暗通道
dim=size(I);         
imsize=dim(1)*dim(2); %计算图片尺寸
numpx=floor(imsize/1000); %计算雾化图像暗通道的0.1%像素
JDarkVec=reshape(dark,imsize,1); %重定暗通道义像素矩阵
ImVec=reshape(I,imsize,3);  %重定义原图像像素矩阵

[JDarkVec,indices]=sort(JDarkVec); %重新排列像素，并记录像素原来的位置
indices=indices(imsize-numpx+1:end); %选取最大的像素

atmSum=zeros(1,3);
for ind=1:numpx
    atmSum=atmSum+ImVec(indices(ind),:); %对像素群所对应的原图进行求和
end
B=atmSum/numpx; %求得大气光强   


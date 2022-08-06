function B=quwu(I)
dim = size(I);     %获取图片的尺寸
r=1;               %预设图片处理窗口半径
t0=0.1;            %防止t趋于0时噪声放大，预设下限值
p=0.9;             %去雾程度调整因子
w=0.95;            %去雾程度调整因子
A=atmospheric(I);  %调用计算大气光强函数
W=darkChannel(I);

Vb=bilateral_filter_plus(W,1);           %获取图像的局部对比度
Dt=bilateral_filter_plus(Vb-W,1);
for i= 1:dim(1)
   for j = 1:dim(2)      
         D=Vb(i,j)-3*Vb(i,j).*Dt(i,j)./A;  %估算大气耗散函数
         V=max(min(p*D,W(i,j)),0);
         t=1-w*V/A;                         %介质传播函数
        B(i,j,:)=A(1)+(I(i,j,:)-A(1))/max(t,t0);   %复原图像   
   end  
end

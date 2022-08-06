function B=quwu_plus(I)
dim = size(I);     %获取图片的尺寸
r=1;               %预设图片处理窗口半径
t0=0.1;            %防止t趋于0时噪声放大，预设下限值
p=0.9;             %去雾程度调整因子
w=0.95;            %去雾程度调整因子
R0=190/255;        %弱化阈值
s=0.3;            %弱化力度系数
A=atmospheric(I);  %调用计算大气光强函数
W=darkChannel(I);

Vb=bilateral_filter_plus(W,1);           %获取图像的局部对比度
Dt=bilateral_filter_plus(Vb-W,1);
for i= 1:dim(1)
   for j = 1:dim(2)
         R=0;
         D=Vb(i,j)-3*Vb(i,j).*Dt(i,j)./A; %估算大气耗散函数
         V=max(min(p*D,W(i,j)),0);
         t=1-w*V/A;                         %介质传播函数
         
         for x = 1:3
             R=R+abs(I(i,j,x)-A);       %像素I(x)与大气光强A的接近程度
         end
         if(R(3)>R0)                  %求取弱化因子
             DD=0;
         else
             DD=s*(1-R(3)/R0);
         end
       B(i,j,:)=A(3)+(I(i,j,:)-A(3))/max(t+DD,t0);   %复原图像    
   end  
end

   
   
   
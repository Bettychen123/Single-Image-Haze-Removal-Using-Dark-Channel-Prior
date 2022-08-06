clear all
I = imread('22.png');

%figure(1)
subplot(221)
imshow(I);
title('原图');
I=rgb2gray(I);%先把彩色图变灰度图
subplot(222)
imshow(I);
title('灰度图');
level = graythresh(I);%寻找方差最大时的阈值
BW = imbinarize(I,level);
[h,w]=size(BW);
subplot(223)
%figure(2)
imshow(BW);
title('matlab自带函数');
IMAX = max(max(I));
IMIN = min(min(I));

T=IMIN:IMAX;
ISIZE=size(I);  %图像大小

muxSize = ISIZE(1) * ISIZE(2);

Tmp=0;%zeros(1,length(T));
mid=0;
for i=1:length(T)  %从MIN到MAX
    TK =T(1,i);
    ifground=0;
    ibground=0;
    FgroundS=0;
    BgroundS=0;
    for j=1:ISIZE(1)
        for k=1:ISIZE(2)
            tmp = I(j,k);
            if(tmp>=TK)
                ifground=ifground+1;%像素个数
                FgroundS=FgroundS+double(tmp);%总的前景色灰度
            else
               ibground=ibground+1;
               Bground=BgroundS+double(tmp);
            end
        end
    end

    w0=ifground/muxSize;
    w1=ibground/muxSize;
    u0=FgroundS/ifground;
    u1=BgroundS/ibground;

    tmp=w0*w1*(u0-u1)*(u0-u1);
    if(Tmp<tmp)
        mid=TK;
        Tmp=tmp;
    end
end

for j=1:ISIZE(1)
   for k=1:ISIZE(2)
       if(I(j,k)>=mid)
           I(j,k)=255;
       else
           I(j,k)=0;
       end
   end
end
subplot(224)
%figure(3)
imshow(I);
title('编程实现大津阈值法');
clear all
I = imread('22.png');

%figure(1)
subplot(221)
imshow(I);
title('ԭͼ');
I=rgb2gray(I);%�ȰѲ�ɫͼ��Ҷ�ͼ
subplot(222)
imshow(I);
title('�Ҷ�ͼ');
level = graythresh(I);%Ѱ�ҷ������ʱ����ֵ
BW = imbinarize(I,level);
[h,w]=size(BW);
subplot(223)
%figure(2)
imshow(BW);
title('matlab�Դ�����');
IMAX = max(max(I));
IMIN = min(min(I));

T=IMIN:IMAX;
ISIZE=size(I);  %ͼ���С

muxSize = ISIZE(1) * ISIZE(2);

Tmp=0;%zeros(1,length(T));
mid=0;
for i=1:length(T)  %��MIN��MAX
    TK =T(1,i);
    ifground=0;
    ibground=0;
    FgroundS=0;
    BgroundS=0;
    for j=1:ISIZE(1)
        for k=1:ISIZE(2)
            tmp = I(j,k);
            if(tmp>=TK)
                ifground=ifground+1;%���ظ���
                FgroundS=FgroundS+double(tmp);%�ܵ�ǰ��ɫ�Ҷ�
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
title('���ʵ�ִ����ֵ��');
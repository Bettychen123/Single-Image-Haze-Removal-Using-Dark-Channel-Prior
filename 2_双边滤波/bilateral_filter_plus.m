function B=bilateral_filter_plus(IM,w)
r = 0;
N=[1,-2,1];   %��������˹�˲�����صĸ�ͨ�˲���
M=[1;-2;1];  
dim=size(IM);
for i=1:(dim(1)/2)            %���Ʊ�׼��
    for j=1:(dim(2)/2)
        p=abs(conv(M,conv(N,IM(i,j))));
        r=p+r;
    end
end
q=0.18*r/(dim(1)*dim(2));
sigma = [3 q]; %�ռ����ƶ�Ӱ�����Ӧ�d��ΪSIGMA(1),�������ƶ�Ӱ�����Ӧ�r��ΪSIGMA(2)
% Ӧ�ûҶȻ��ɫ˫���˲�
if size(IM,3) ==1
   B = bfltGray(IM,w,sigma(1),sigma(2));
  else if size(IM,3) ==3
   B = bfltColor(IM,w,sigma(1),sigma(2));
end

if exist('applycform','file')
   B = applycform(B,makecform('lab2srgb'));
else  
   B = colorspace('RGB<-Lab',B);
end
end
function B=quwu(I)
dim = size(I);     %��ȡͼƬ�ĳߴ�
r=1;               %Ԥ��ͼƬ�����ڰ뾶
t0=0.1;            %��ֹt����0ʱ�����Ŵ�Ԥ������ֵ
p=0.9;             %ȥ��̶ȵ�������
w=0.95;            %ȥ��̶ȵ�������
A=atmospheric(I);  %���ü��������ǿ����
W=darkChannel(I);

Vb=bilateral_filter_plus(W,1);           %��ȡͼ��ľֲ��Աȶ�
Dt=bilateral_filter_plus(Vb-W,1);
for i= 1:dim(1)
   for j = 1:dim(2)      
         D=Vb(i,j)-3*Vb(i,j).*Dt(i,j)./A;  %���������ɢ����
         V=max(min(p*D,W(i,j)),0);
         t=1-w*V/A;                         %���ʴ�������
        B(i,j,:)=A(1)+(I(i,j,:)-A(1))/max(t,t0);   %��ԭͼ��   
   end  
end

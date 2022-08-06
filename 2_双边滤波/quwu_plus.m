function B=quwu_plus(I)
dim = size(I);     %��ȡͼƬ�ĳߴ�
r=1;               %Ԥ��ͼƬ�����ڰ뾶
t0=0.1;            %��ֹt����0ʱ�����Ŵ�Ԥ������ֵ
p=0.9;             %ȥ��̶ȵ�������
w=0.95;            %ȥ��̶ȵ�������
R0=190/255;        %������ֵ
s=0.3;            %��������ϵ��
A=atmospheric(I);  %���ü��������ǿ����
W=darkChannel(I);

Vb=bilateral_filter_plus(W,1);           %��ȡͼ��ľֲ��Աȶ�
Dt=bilateral_filter_plus(Vb-W,1);
for i= 1:dim(1)
   for j = 1:dim(2)
         R=0;
         D=Vb(i,j)-3*Vb(i,j).*Dt(i,j)./A; %���������ɢ����
         V=max(min(p*D,W(i,j)),0);
         t=1-w*V/A;                         %���ʴ�������
         
         for x = 1:3
             R=R+abs(I(i,j,x)-A);       %����I(x)�������ǿA�Ľӽ��̶�
         end
         if(R(3)>R0)                  %��ȡ��������
             DD=0;
         else
             DD=s*(1-R(3)/R0);
         end
       B(i,j,:)=A(3)+(I(i,j,:)-A(3))/max(t+DD,t0);   %��ԭͼ��    
   end  
end

   
   
   
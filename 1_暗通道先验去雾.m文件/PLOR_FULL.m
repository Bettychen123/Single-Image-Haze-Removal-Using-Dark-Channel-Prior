clc;clear
x=1:1:20;%x���ϵ����ݣ���һ��ֵ�������ݿ�ʼ���ڶ���ֵ��������������ֵ������ֹ
% name={'2','8','16','24','30'}; %�������ַ�

s=zeros(20,4);
figure('color',[1 1 1]);%���ñ���Ϊ��ɫ
plot(x,s(:,1),'--+','Color',[0.5,0,0],'lineWidth',1);
hold on
% plot(x,s(:,2),'--+','Color',[0.76,0.068,0.1944],'lineWidth',1);
%  hold on
plot(x,s(:,2),'->','Color',[0,0.543,0.543],'lineWidth',1);
hold on
plot(x,s(:,3),'-s','Color',[0.3,0.3,0.35],'lineWidth',1); %���ԣ���ɫ����ǣ���ϸ
hold on
plot(x,s(:,4),'-d','Color',[1,0.54902,0],'lineWidth',1); %���ԣ���ɫ����ǣ���ϸ
axis([0,21,1.5,5.0])  %ȷ��x����y���ͼ��С
set(gca,'FontName','Times New Roman','FontSize',13,'LineWidth',1);%���������������С
set(gca,'XTick',[0:5:20]) %x�᷶Χ1-5�����1
% set(gca, 'XTickLabel', name); %���ú������ַ���ǩ
set(gca,'YTick',[1.5:0.4:5.0]) %y�᷶Χ0-1�����0.2
legend('He','Light','Bilateral filter','Current work','location','Southeast');   %���ϽǱ�ע
% xlabel('Number')  %x����������
ylabel('NIQE') %y����������

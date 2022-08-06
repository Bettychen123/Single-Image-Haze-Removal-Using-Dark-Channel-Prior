clc;clear
x=1:1:20;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止
% name={'2','8','16','24','30'}; %横坐标字符

s=zeros(20,4);
figure('color',[1 1 1]);%设置背景为白色
plot(x,s(:,1),'--+','Color',[0.5,0,0],'lineWidth',1);
hold on
% plot(x,s(:,2),'--+','Color',[0.76,0.068,0.1944],'lineWidth',1);
%  hold on
plot(x,s(:,2),'->','Color',[0,0.543,0.543],'lineWidth',1);
hold on
plot(x,s(:,3),'-s','Color',[0.3,0.3,0.35],'lineWidth',1); %线性，颜色，标记，粗细
hold on
plot(x,s(:,4),'-d','Color',[1,0.54902,0],'lineWidth',1); %线性，颜色，标记，粗细
axis([0,21,1.5,5.0])  %确定x轴与y轴框图大小
set(gca,'FontName','Times New Roman','FontSize',13,'LineWidth',1);%设置坐标轴字体大小
set(gca,'XTick',[0:5:20]) %x轴范围1-5，间隔1
% set(gca, 'XTickLabel', name); %设置横坐标字符标签
set(gca,'YTick',[1.5:0.4:5.0]) %y轴范围0-1，间隔0.2
legend('He','Light','Bilateral filter','Current work','location','Southeast');   %右上角标注
% xlabel('Number')  %x轴坐标描述
ylabel('NIQE') %y轴坐标描述

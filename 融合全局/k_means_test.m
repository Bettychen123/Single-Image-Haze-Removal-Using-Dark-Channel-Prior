clear all;
close all;
clc;
% 第一组数据
mu1=[0 0 ];  %均值(是需要生成的数据的均值)
S1=[.1 0 ;0 .1];  %协方差(需要生成的数据的自相关矩阵（相关系数矩阵）)
data1=mvnrnd(mu1,S1,100);   %产生高斯分布数据
%第二组数据
mu2=[1.25 1.25 ];
S2=[.1 0 ;0 .1];
data2=mvnrnd(mu2,S2,100);
% 第三组数据
mu3=[-1.25 1.25 ];
S3=[.1 0 ;0 .1];
data3=mvnrnd(mu3,S3,100);
% 显示数据
plot(data1(:,1),data1(:,2),'b+');
hold on;%不覆盖原图，要关闭则使用hold off；
plot(data2(:,1),data2(:,2),'r+');
plot(data3(:,1),data3(:,2),'g+');
grid on;%显示表格
%  三类数据合成一个不带标号的数据类
data=[data1;data2;data3];
N=6;%设置聚类数目
[m,n]=size(data);%表示矩阵data大小，m行n列
pattern=zeros(m,n+1);%生成0矩阵
center=zeros(N,n);%初始化聚类中心
pattern(:,1:n)=data(:,:);
for x=1:N
    center(x,:)=data( randi(300,1),:);%第一次随机产生聚类中心
end
while 1 %循环迭代每次的聚类簇；
    distence=zeros(1,N);%最小距离矩阵
    num=zeros(1,N);%聚类簇数矩阵
    new_center=zeros(N,n);%聚类中心矩阵
    
    for x=1:m
        for y=1:N
            distence(y)=norm(data(x,:)-center(y,:));%计算到每个类的距离
        end
        [~, temp]=min(distence);%求最小的距离
        pattern(x,n+1)=temp;%划分所有对象点到最近的聚类中心；标记为1,2,3；
    end
    k=0;
    for y=1:N
        for x=1:m
            if pattern(x,n+1)==y
                new_center(y,:)=new_center(y,:)+pattern(x,1:n);
                num(y)=num(y)+1;
            end
        end
        new_center(y,:)=new_center(y,:)/num(y);%求均值，即新的聚类中心；
        if norm(new_center(y,:)-center(y,:))<0.1%检查集群中心是否已收敛。如果是则终止。
            k=k+1;
        end
    end
    if k==N
        break;
    else
        center=new_center;
    end
end
[m, n]=size(pattern);

%最后显示聚类后的数据
figure;
hold on;
for i=1:m
    if pattern(i,n)==1
        plot(pattern(i,1),pattern(i,2),'r*');
        plot(center(1,1),center(1,2),'ko');%用小圆圈标记中心点；
    elseif pattern(i,n)==2
        plot(pattern(i,1),pattern(i,2),'g*');
        plot(center(2,1),center(2,2),'ko');
    elseif pattern(i,n)==3
        plot(pattern(i,1),pattern(i,2),'b*');
        plot(center(3,1),center(3,2),'ko');
    elseif pattern(i,n)==4
        plot(pattern(i,1),pattern(i,2),'y*');
        plot(center(4,1),center(4,2),'ko');
    else
        plot(pattern(i,1),pattern(i,2),'m*');
        plot(center(4,1),center(4,2),'ko');
    end
end
grid on;

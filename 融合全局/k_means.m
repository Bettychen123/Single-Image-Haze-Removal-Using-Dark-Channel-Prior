N=10;%设置聚类数目
[m,n]=size(dark_I);%表示矩阵data大小，m行n列
pattern=zeros(m,2*n);%生成0矩阵 之后用于存储对应的所处的类
center=zeros(N,2);%初始化聚类中心 存储随机生成的坐标
pattern(:,1:2:2*n)=dark_I(:,:);%取得暗通道图像并存在前n个向量,并为每一个向量留下空位以便装其对于的类别编号
for x=1:N
    center(x,1)= randi(m,1);%第一次随机产生聚类中心 (m,1)保证了其在m行中随机选取,获得中心横坐标
end

for x=1:N
    center(x,2)= randi(n,1);%第一次随机产生聚类中心 (m,1)保证了其在n列中随机选取，获得中心纵坐标
end

while 1
    distence=zeros(1,N);%最小距离矩阵 存储每一个像素和中心的位置信息
    num=zeros(1,N);%聚类簇数矩阵
    new_center=zeros(N,2);%聚类中心矩阵
    
    for x=1:m
      for q=1:n
        for y=1:N
            distence(y)=norm(dark_I(x,q)-dark_I(center(y,1),center(y,2)));%计算到每个类的距离（即为论文所说的欧几里得范数,值得注意的是论文算的是像素值的范数，而非距离范数）
        end
        [~, temp]=min(distence);%求最小的距离
        pattern(x,y+1)=temp;%划分所有对象点到最近的聚类中心；标记为1,2,3；
      end
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
pattern_sort=sortrows(pattern,n);
for i=1:n
    for j=1:N
        

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

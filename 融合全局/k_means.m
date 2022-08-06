N=10;%���þ�����Ŀ
[m,n]=size(dark_I);%��ʾ����data��С��m��n��
pattern=zeros(m,2*n);%����0���� ֮�����ڴ洢��Ӧ����������
center=zeros(N,2);%��ʼ���������� �洢������ɵ�����
pattern(:,1:2:2*n)=dark_I(:,:);%ȡ�ð�ͨ��ͼ�񲢴���ǰn������,��Ϊÿһ���������¿�λ�Ա�װ����ڵ������
for x=1:N
    center(x,1)= randi(m,1);%��һ����������������� (m,1)��֤������m�������ѡȡ,������ĺ�����
end

for x=1:N
    center(x,2)= randi(n,1);%��һ����������������� (m,1)��֤������n�������ѡȡ���������������
end

while 1
    distence=zeros(1,N);%��С������� �洢ÿһ�����غ����ĵ�λ����Ϣ
    num=zeros(1,N);%�����������
    new_center=zeros(N,2);%�������ľ���
    
    for x=1:m
      for q=1:n
        for y=1:N
            distence(y)=norm(dark_I(x,q)-dark_I(center(y,1),center(y,2)));%���㵽ÿ����ľ��루��Ϊ������˵��ŷ����÷���,ֵ��ע������������������ֵ�ķ��������Ǿ��뷶����
        end
        [~, temp]=min(distence);%����С�ľ���
        pattern(x,y+1)=temp;%�������ж���㵽����ľ������ģ����Ϊ1,2,3��
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
        new_center(y,:)=new_center(y,:)/num(y);%���ֵ�����µľ������ģ�
        if norm(new_center(y,:)-center(y,:))<0.1%��鼯Ⱥ�����Ƿ������������������ֹ��
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
        

%�����ʾ����������
figure;
hold on;
for i=1:m
    if pattern(i,n)==1
        plot(pattern(i,1),pattern(i,2),'r*');
        plot(center(1,1),center(1,2),'ko');%��СԲȦ������ĵ㣻
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

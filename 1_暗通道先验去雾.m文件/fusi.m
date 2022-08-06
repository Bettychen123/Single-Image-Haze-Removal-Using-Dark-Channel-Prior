%% imerode腐蚀

  %A1=imread('.\images\dipum_images_ch09\Fig0908(a)(wirebond-mask).tif');
  BW=bin;
  A1=BW;
 figure;
 subplot(221),imshow(BW);
 title('腐蚀原始图像');

%strel函数的功能是运用各种形状和大小构造结构元素
se1=strel('disk',5);%这里是创建一个半径为5的平坦型圆盘结构元素
A2=imerode(BW,se1);
subplot(222),imshow(A2);
title('使用结构原始disk(5)腐蚀后的图像');
se2=strel('disk',10);
A3=imerode(A1,se2);
subplot(223),imshow(A3);
title('使用结构原始disk(10)腐蚀后的图像'); 
se3=strel('disk',50);
A4=imerode(A1,se3);
subplot(224),imshow(A4);
title('使用结构原始disk(50)腐蚀后的图像');

%图像腐蚀处理过程运行结果如下：
%% 开运算和闭运算

 %f=imread('.\images\dipum_images_ch09\Fig0910(a)(shapes).tif');
 se=strel('square',5');%方型结构元素
  %se=strel('disk',5');%圆盘型结构元素
  f=BW;
  imshow(f);%原图像
  title('开闭运算原始图像')
 %运行结果如下：


 
  %开运算数学上是先腐蚀后膨胀的结果
  %开运算的物理结果为完全删除了不能包含结构元素的对象区域，平滑
  %了对象的轮廓，断开了狭窄的连接，去掉了细小的突出部分
  fo=imopen(f,se);%直接开运算
  figure;imshow(fo);
  title('直接开运算');
  
  %闭运算在数学上是先膨胀再腐蚀的结果
  %闭运算的物理结果也是会平滑对象的轮廓，但是与开运算不同的是，闭运算
  %一般会将狭窄的缺口连接起来形成细长的弯口，并填充比结构元素小的洞
  fc=imclose(f,se);%直接闭运算
  figure;imshow(fc);
  title('直接闭运算');
  
  foc=imclose(fo,se);%先开后闭运算
  figure;imshow(foc);
  title('先开后闭运算');
  
  fco=imopen(fc,se);%先闭后开运算
  figure;imshow(fco);
  title('先闭后开运算');
 %开闭运算结果如下：

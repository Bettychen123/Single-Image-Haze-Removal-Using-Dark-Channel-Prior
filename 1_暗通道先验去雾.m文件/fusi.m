%% imerode��ʴ

  %A1=imread('.\images\dipum_images_ch09\Fig0908(a)(wirebond-mask).tif');
  BW=bin;
  A1=BW;
 figure;
 subplot(221),imshow(BW);
 title('��ʴԭʼͼ��');

%strel�����Ĺ��������ø�����״�ʹ�С����ṹԪ��
se1=strel('disk',5);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��
A2=imerode(BW,se1);
subplot(222),imshow(A2);
title('ʹ�ýṹԭʼdisk(5)��ʴ���ͼ��');
se2=strel('disk',10);
A3=imerode(A1,se2);
subplot(223),imshow(A3);
title('ʹ�ýṹԭʼdisk(10)��ʴ���ͼ��'); 
se3=strel('disk',50);
A4=imerode(A1,se3);
subplot(224),imshow(A4);
title('ʹ�ýṹԭʼdisk(50)��ʴ���ͼ��');

%ͼ��ʴ����������н�����£�
%% ������ͱ�����

 %f=imread('.\images\dipum_images_ch09\Fig0910(a)(shapes).tif');
 se=strel('square',5');%���ͽṹԪ��
  %se=strel('disk',5');%Բ���ͽṹԪ��
  f=BW;
  imshow(f);%ԭͼ��
  title('��������ԭʼͼ��')
 %���н�����£�


 
  %��������ѧ�����ȸ�ʴ�����͵Ľ��
  %�������������Ϊ��ȫɾ���˲��ܰ����ṹԪ�صĶ�������ƽ��
  %�˶�����������Ͽ�����խ�����ӣ�ȥ����ϸС��ͻ������
  fo=imopen(f,se);%ֱ�ӿ�����
  figure;imshow(fo);
  title('ֱ�ӿ�����');
  
  %����������ѧ�����������ٸ�ʴ�Ľ��
  %�������������Ҳ�ǻ�ƽ������������������뿪���㲻ͬ���ǣ�������
  %һ��Ὣ��խ��ȱ�����������γ�ϸ������ڣ������ȽṹԪ��С�Ķ�
  fc=imclose(f,se);%ֱ�ӱ�����
  figure;imshow(fc);
  title('ֱ�ӱ�����');
  
  foc=imclose(fo,se);%�ȿ��������
  figure;imshow(foc);
  title('�ȿ��������');
  
  fco=imopen(fc,se);%�ȱպ�����
  figure;imshow(fco);
  title('�ȱպ�����');
 %�������������£�

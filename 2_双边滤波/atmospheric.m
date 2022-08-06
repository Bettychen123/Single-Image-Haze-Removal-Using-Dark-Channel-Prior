function B=atmospheric(I)
dark=darkChannel(I);  %��ȡͼ��ͨ��
dim=size(I);         
imsize=dim(1)*dim(2); %����ͼƬ�ߴ�
numpx=floor(imsize/1000); %������ͼ��ͨ����0.1%����
JDarkVec=reshape(dark,imsize,1); %�ض���ͨ�������ؾ���
ImVec=reshape(I,imsize,3);  %�ض���ԭͼ�����ؾ���

[JDarkVec,indices]=sort(JDarkVec); %�����������أ�����¼����ԭ����λ��
indices=indices(imsize-numpx+1:end); %ѡȡ��������

atmSum=zeros(1,3);
for ind=1:numpx
    atmSum=atmSum+ImVec(indices(ind),:); %������Ⱥ����Ӧ��ԭͼ�������
end
B=atmSum/numpx; %��ô�����ǿ   


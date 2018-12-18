%ROOT_MUSIC ALOGRITHM
%DOA ESTIMATION BY ROOT_MUSIC
clc;
clear all;
close all;

K=2; %信源数
M=8; %阵元数
L=200; %信号长度
w=[pi/4 pi/6].';  %信号频率
lamda=((2*pi*3e8)/w(1)+(2*pi*3e8)/w(2))/2;  %信号波长  
d_lamda=0.5;  %阵元间距
snr=20;  %信噪比
theta1=[45,60];   %信号入射角

for k=1:K
    A(:,k)=exp(-1j*[0:M-1]'*d_lamda*2*pi*sin(theta1(k)*pi/180)); %阵列流型
end

for kk=1:L
    s(:,kk)=sqrt(10.^((snr/2)/10))*exp(1j*w*(kk-1));  %仿真信号
end
x=A*s+(1/sqrt(2))*(randn(M,L)+1j*randn(M,L));  %加入高斯白噪声
R=(x*x')/L;  %协方差矩阵

%%%%%%第一种方法%%%%%%%%%%
[V,D]=eig(R);   %对协方差矩阵进行特征分解
Un=V(:,1:M-K);   %取噪声子空间
Gn=Un*Un'; a = zeros(2*M-1,1)';   %找出多项式的系数，并按阶数从高至低排列
for i=-(M-1):(M-1)
    a(i+M) = sum( diag(Gn,i) );
end
a1=roots(a);   %使用ROOTS函数求出多项式的根                            
a2=a1(abs(a1)<1);   %找出在单位圆里且最接近单位圆的N个根
[lamda,I]=sort(abs(abs(a2)-1));   %挑选出最接近单位圆的N个根
f=a2(I(1:K));   %计算信号到达方向角
source_doa=[asin(angle(f(1))/pi)*180/pi asin(angle(f(2))/pi)*180/pi];
source_doa=sort(source_doa);
disp('source_doa');
disp(source_doa);

%%%%%%%第二种方法%%%%%%%%%
% [V,D]=eig(R);
% Un=V(:,1:M-K);    %(4.5.7）
% Un1=Un(1:M,:);
% Un2=Un(K+1:M,:);
% T=[1 0 0 0 0 0]';  %（阵元数-信源数）*1
% c=Un1*inv(Un2)*T;  % (K*(M-K))*((M-K)*(M-K))*((M-K)*1)=K*1
% c=[1,c(2,1),c(1,1)];  %（4.5.8）
% f=roots(c);
% source_doa=[asin(angle(f(1))/pi)*180/pi asin(angle(f(2))/pi)*180/pi]; 
% source_doa=sort(source_doa);
% disp('source_doa');
% disp(source_doa);

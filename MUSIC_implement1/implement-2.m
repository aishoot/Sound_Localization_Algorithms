% 阵元间隔为半波长的均匀分布16元线阵,预成指向arcsin（(2i-1)/16）(i=1,2,…,16)的16个均匀加权常规波束,远场有2个互
% 不相关的目标源发射信号,每个源相对于基阵的方位为-45和-40,且每个信号源到达基阵的信噪比相同,快拍数为1000.
% 进行波束域方法和阵元域方法的比较
clc
clear all 
close all

C=340;                                      %声速 
num=16;                                     %阵元数 
k=1000;                                     %快拍数 
Bearings=[-45 -40];                         %入射信号方位角
d=length(Bearings);                         %声源数 
D=0.1;                                      %阵元间距 
fc=1000;                                    %信号频率 
fs=2*fc;                                    %采样频率 
snr=10;                                     %信噪比 
e_position=[0:num-1]'; 
s_position=[0:d-1]'; 

%波束形成 
as=-13/16:1/8:-9/16;                        %波束指向角,正弦值[-0.8125, -0.6875, -0.5625]
as=asin(as);  %弧度数[-0.9484, -0.7580, -0.5974]
vs=exp(j*2*pi*fc*e_position*D*sin(as)/C);   %16*3 complex double
w=1/num*vs';                                %波束形成矩阵 

%入射信号 
aa=90*[-1:0.002:1];                         %从-90到90采样1001个点 
s=exp(j*pi*[1:d].'*sin(aa/180*pi));   
%s=exp(j*pi*sin(aa/180*pi));  
%s=repmat(s,[d 1]);                          %声源信号 

%方向向量 
Bearings=Bearings*pi/180; 
TimeDelay=D*[0:num-1].'*sin(Bearings)/C;    %线阵的延迟,(16,2)
A=exp(sqrt(-1)*2*pi*fc*TimeDelay);          %方向向量,(16,2)复数矩阵

%基阵接收信号 
X=A*s;                                      %阵列输出信号 
X=awgn(X,snr);                              %加噪声,(16,1001)复数矩阵

%% 阵元域MUSIC算法 
Rxx=(X*X')/k;                               %协方差矩阵,(16,16)复数矩阵
[EigenVectors,EigenValues]=eig(Rxx);        
Lemda=diag(EigenValues);                    %上面计算出的特征值为16*16的对角阵,该步提取对角阵上的值            
[SortedLemda,Index]=sort(Lemda);            %将特征值降序排列
Index=flipud(Index);                        %(16,1),上下翻转,也就是把Index倒序排列
NoiseSubspace_Z(1:num,1:num-d)=EigenVectors(1:num,Index(d+1:num));%把噪声空间分成两部分,分别加入信号空间的一部分和噪声,(16,14)

%%在-150到150之间进行搜索 
for  i=-900:900 
     az=exp(sqrt(-1)*2*pi*fc*D*[0:num-1]'*sin(i/10*pi/180)/C);   %(16,1)复数矩阵
     MUSIC_Spec_Z(i+901)=az'*az/(az'*NoiseSubspace_Z*NoiseSubspace_Z'*az);   %最后(1,1801)复数矩阵
end 

%波束输出 
Y=w*X;                                      %方位估计,(3,1001)复数矩阵 

%% 波束域MUSIC算法 
B=3;                                        %波束数 
Ryy=(Y*Y')/k;                               %协方差矩阵 
[EigenVectors,EigenValues]=eig(Ryy); 
Lemda=diag(EigenValues);                    %计算矩阵特征值 
[SortedLemda,Index]=sort(Lemda); 
Index=flipud(Index);                        %将特征值降序排列 
NoiseSubspace(1:B,1:B-d)=EigenVectors(1:B,Index(d+1:B)); %把噪声空间分成两部分,分别为加入信号空间的一部分和噪声,(3,1)

% 在20到50之间进行搜索 
for i=-600:1:-250 
    a=exp(sqrt(-1)*2*pi*fc*D*[0:num-1]'*sin((i/10)*pi/180)/C); 
    MUSIC_Spec_B(i+601)=a'*w'*w*a/(a'*w'*NoiseSubspace*(w'*NoiseSubspace)'*a);   %(1,351)复数矩阵
end 

%% 画波束
figure(1); 
MUSIC_B=abs(MUSIC_Spec_B)/max(abs(MUSIC_Spec_B)); 
Delta1=[-60:0.1:-25]; 
plot(Delta1,10*log10(MUSIC_B),'r');  %NonNormative Spatial Spectrum 
xlabel('角度（度）'),ylabel('空间方位谱(dB)'); 
hold on 
Delta=[-90:0.1:90]; 
MUSIC_Z=abs(MUSIC_Spec_Z)/max(abs(MUSIC_Spec_Z)); 
plot(Delta,10*log10(MUSIC_Z)); 

figure(2); 
ss=exp(j*pi*e_position*sin(aa/180*pi));  %%  入射信号 
plot(aa,20*log10(abs(w*ss))),xlabel('角度（度）'),ylabel('波束(dB)'); 
axis([-90 90 -40 0]); 
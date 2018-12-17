% DOA MUSIC
% 初始化参数 initial parameter
clc
close all
clear all

source=2;        % 信源 signal number 期望信号
sensor=7;        % array number
theta=[20 60];   % DOA of signal
ss=1024;         % snapshot  快拍数
snr=[40 60];     % SNR  信噪比
j=sqrt(-1);

% 信号复包络 SIGNAL
w=[pi/6 pi/5]';
for m=1:source
    S(m,:)=10.^(snr(m)/10)*exp(-j*w(m)*[0:ss-1]);  %S:signal matrix, (2,1024)
end

% 阵列流形  STEERING VECTOR
A=exp(-j*(0:sensor-1)'*pi*sin(theta/180*pi));  %A:(7,2)

% 噪声  NOISE
N=randn(sensor,ss)+j*randn(sensor,ss);  %N:(7,1024)

% 观测信号  SIGNAL RECEIVED
Y=A*S+N;   %(7,1024)

% 阵列协方差矩阵  COVIARIANCE MATRIX
R=Y*Y'/ss;  %R:(7,7) complex matrix

% 特征分解 eigen-decomposition
[E,X,V]=svd(R);   %E=V,7*7, E是特征向量; X是特征值,7*7,特征值在对角线上，其余为0
%在不知道源的个数的情况下需要估计出p的值，方法是假设为某个值，出来的能量谱和真实的能量谱可能很接近
p=length(theta);  %已知源个数
En=E(:,p+1:sensor);   %X特征值由大到小降序排列,所以大特征值在前,即信号特征值在前,(7,5)

% [V,D]=eig(R);   %[特征向量,特征值]
% D=diag(D);
% Es=V(:,sensor-p+1:sensor);
% En=V(:,1:sensor-p);  %噪声特征向量,特征值由小到大,升序排列,所以大特征值在后,即信号特征值在后

search_doa=[0:1:90];
for i=1:length(search_doa)
    a_theta=exp(-j*pi*(0:sensor-1)'*sin(search_doa(i)*pi/180));   %a_theta:(7,1), d = half-wavelength
    Q=(a_theta)'*En*En'*a_theta;   % a complex
    Pmusic(i)=1./Q;
end

P_music=10*log10(Pmusic);
plot(search_doa, P_music, 'linewidth', 2);
title('MUSIC beamforming');
xlabel('angle/degree');
ylabel('magnitude/dB');
grid;
% Pmusic(i)=1./abs(Q);%abs(1./((a_theta)'*En*En'*a_theta));

close all
clear
clc

N = 10;  %number of sensors
M = 2;
c = 1500;
f = 1000;
d = c/f/2;  %distance between sensors-half wavelength
B = 62.5;
snr = 5;
temp = 0:N-1;
theta = [60;45];  %两个来波方向
fs = 8192;

% theta = [10;60;50];
tempr = repmat(temp,2,1);
theta = repmat(theta,1,N);

t = 1/fs:1/fs:0.1;
v = exp(j*2*pi*f/c*d.*cos(theta*pi/180).*tempr);
s = zeros(M,length(temp));
s1 = sqrt(2*10^(snr/10))*exp(j*2*pi*f*t);
s2 = sqrt(2*10^(snr/10))*exp(j*2*pi*f*t);

% s3 = sqrt(2*10^(snr/10))*exp(j*2*pi*f*t);
% s = [s1;s2;s3];
%noise = rand()
s = [s1+awgn(s1,5,'measured');s2+awgn(s2,5,'measured')];
% 
% for i = 1:length(v)
%     x(i,:) = x(i,:)+rand(1,length(s))+i*rand(1,length(s));
% end
x = v'*s;
r = x*x';
lmin = 0;
lmax = 90;
output=zeros(1,(lmax-lmin+1));
output1 = output;
jl = 1;

for thets = lmin:lmax
    vs = exp(j*2*pi*f/c*d*cos(thets*pi/180)*temp);
    output(jl) = vs*r*vs';
    jl = jl+1;
end

figure;
plot(lmin:lmax,abs(output))
[eigv eig1] = eig(r);
[rol col]=size(eigv);
[eigord point]= sort(diag(eig1));
%[valb,point] = find(diag(eig1)==eigord);
u = eigv(:,point);
% eigord = sort(diag(eig1));
% for l1 = 1:N-M
% [valb,point] = find(eig1==eigord(l1));
% u(:,l1) = eigv(:,point);
% end
jl = 1;
P1=zeros(1,length(lmin:lmax));

for thets = lmin:lmax
    vs = exp(j*2*pi*f/c*d*cos(thets*pi/180)*temp);
    output1(jl) = sum((vs*u(:,1:(N-M))).^2);
%     for n=1:N-M
%     P1(jl)= P1(jl)+(vs*u(:,n)).^2;
%  end
    jl = jl+1;
end

figure;
plot(lmin:lmax,1./abs(output1))
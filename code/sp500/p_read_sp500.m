clear;
clc;
clear global ;

%% ���ݶ�ȡ
 filename = 'final_sp500_09-20'  ;         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��������
 load([filename , '.mat']);
   benchmark_file='benchmark_sp500';
load([benchmark_file , '.mat']);
%% ���ݺ˲�:��������쳣��Ҫ�õ�
site=[]
ms=1;
for iii=2:length(z_ST(:,1))
    for jjj=2:length(z_ST(1,:))-1
        if z_ST(iii,jjj+1)-z_ST(iii,jjj)>10*z_ST(iii,jjj)
            site(ms,1)=iii;
            site(ms,2)=jjj;
            ms=ms+1;
        end
    end
end
check=unique(site(:,1))
for ck=1:length(check)
    site_ck=find(z_stock()==check(ck))-1;
    z_stock(site_ck)=[];
    z_ST(site_ck+1,:)=[];
    z_19kc_rate(site_ck+1,:)=[];
    z_high(site_ck+1,:)=[];
    z_low(site_ck+1,:)=[];
    z_open(site_ck+1,:)=[];
    z_vol(site_ck+1,:)=[];
end
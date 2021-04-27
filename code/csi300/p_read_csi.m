clear;
clc;
clear global ;

%% 数据读取
 filename = 'final_csi_09-20-2'  ;         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%数据名称
 load([filename , '.mat']);
    benchmark_file='benchmark_csi';
load([benchmark_file , '.mat']);
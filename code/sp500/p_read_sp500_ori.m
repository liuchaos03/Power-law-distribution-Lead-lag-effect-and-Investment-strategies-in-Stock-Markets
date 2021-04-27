clear;
clc;
clear global ;

%% 数据读取
 filename = 'final_sp500_09-20'  ;         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%数据名称
 load([filename , '.mat']);
   benchmark_file='benchmark_sp500';
load([benchmark_file , '.mat']);
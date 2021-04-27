
clear;
clc;
clear global ;

%% 数据读取
 filename = 'final_csi_09-20'  ;         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%数据名称
 load([filename , '.mat']);
 %% 参数区
%时间段
t_time=20090901;%训练开始日期
initTime = 20100101; %回测开始时间
lastTime = 20110101; %回测结束时间
site_temp=find(z_date>=initTime);
site_date_ini=site_temp(1);  %确定开始时间的位置，如果使用处理好的数据，此参数为固定
daynum = 0;                            %时间计数
%lead-lag参数
derta=0.001;                          %显著性水平
shareNum=10000000;                         %设置初始金额；
cost=0.0025;
fai=0.1;
%alpha参数
long=20;
short=5;
freq = 1;
fix_count=20;
%% 计算指标初始化
daily_income=zeros(2,length(date_valid)); %收入
daily_income(1,1:end)=date_valid;         %

final_shareNum=zeros(2,length(date_valid)); %每日总金额
final_shareNum(1,1:end)=date_valid;
final_shareNum(2,1:site_date_ini)=shareNum;

consac_sig=0;    %交易信号
%% %%准备策略部分
%说明：以天为单位，按照刷新频率进行循环
    month_info=[];
    month_info_begin=[];
    %计算交易情况，并记录购买股票的手数
    %1：标的代码；2：昨天单价；3：今天单价；4.昨天总金额；5：今天总金额；6：昨天手数；7：今天手数
    target_calculate_structure=zeros(length(z_stock),7);
    target_calculate_structure(1:end,1)=z_stock;
    %
    abc_bcd=zeros(length(z_stock),3);
    abc_bcd(1:end,1)=z_stock;
    cost_sum=0;
    left_money=0;
    %最终信号：1.股票代码；2.lead-lag信号；3.交易钱数
    final_table = zeros(length(z_stock(:,1)),3);
    final_table(:,1)=z_stock;
hold_money=shareNum;
for ii=1:length(date_valid)-site_date_ini+1
    %% 计算区：
    current_date=z_date(site_date_ini+daynum) %当天日期
    current_month=floor(current_date/100);     %当月月份
    daynum = daynum+1;                         %记录时间。
    % 计算lead-lag开始月份
    if current_date==[20110204]
        current_date;
    end
    
    if current_month-floor(current_month/100)*100 > p_len_time
            begin_month=current_month-p_len_time;
        elseif current_month-floor(current_month/100)*100 <= p_len_time
            begin_month=current_month-100+12-p_len_time;
    end  
    target_calculate_structure(1:end,3)=z_ST(find(ismember(z_ST(:,1),target_calculate_structure(:,1))),site_date_ini+daynum);

    LongLine = f_ma_calculate(z_ST,site_date_ini,daynum,long);       % 长均线
    ShortLine = f_ma_calculate(z_ST,site_date_ini,daynum,short);     % 短均线
    
     total_coi=hold_money/200;
    for coi=1:length(z_stock)
        
        %% 仓位
%         if left_money==0
%             total_coi=floor(shareNum/length(find(~isnan(z_ST(2:end,site_date_ini+daynum)))));
%         elseif left_money>0
%              total_coi=floor(left_money/length(find(~isnan(z_ST(2:end,site_date_ini+daynum)))));
%         end
%         if total_coi>shareNum/100
%             total_coi=shareNum/100;
%             left_money=left_money-length(find(~isnan(z_ST(2:end,site_date_ini+daynum))))*total_coi
%         else
%             left_money=0
%         end
       if target_calculate_structure(coi,7) == 0
            if isnan(target_calculate_structure(coi,3))
                continue;
            elseif isnan(ShortLine(coi))||isnan(LongLine(coi))
                
                target_calculate_structure(coi,5)=0;
                target_calculate_structure(coi,7)=0;
            elseif ShortLine(coi)>LongLine(coi) && ~isnan(target_calculate_structure(coi,3))
                target_calculate_structure(coi,7)=floor(( total_coi/target_calculate_structure(coi,3))/100);
                target_calculate_structure(coi,5)=target_calculate_structure(coi,7)*target_calculate_structure(coi,3)*100;
                left_money=left_money +  total_coi - target_calculate_structure(coi,5); %没买成整手数的钱存入现金
                hold_money=hold_money-total_coi;
                target_calculate_structure(coi,6)=fix_count;
            elseif  ShortLine(coi)<=LongLine(coi)
                continue;
            end
        elseif target_calculate_structure(coi,7)>0
            if   target_calculate_structure(coi,6)>0
                target_calculate_structure(coi,6)=target_calculate_structure(coi,6)-1;
                continue;            
           
            elseif ~isnan(target_calculate_structure(coi,3))&&  ShortLine(coi)<LongLine(coi)
                hold_money=hold_money+target_calculate_structure(coi,7)*target_calculate_structure(coi,3)*100;
                 target_calculate_structure(coi,5)=0;
                 target_calculate_structure(coi,7)=0;
            end
        end
          
    end
                
         [money_total_hold, daily_income(2,site_date_ini+daynum-1)]=f_daily_calculate(target_calculate_structure,z_ST,site_date_ini,daynum);
          final_shareNum(2 ,site_date_ini+daynum-1 )=money_total_hold+left_money+hold_money;
          hold_money=hold_money+left_money;
          left_money=0;        
        
end


  x=1:length(final_shareNum(1,:));
    plot(x,final_shareNum(2,:))
    
    sum(cost_sum)
    rate_final=(final_shareNum(2,end)-final_shareNum(2,1))/final_shareNum(2,1)













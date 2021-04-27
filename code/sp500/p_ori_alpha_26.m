

 %% 参数区
%时间段
t_time=20090901;%训练开始日期
initTime = 20100101; %回测开始时间
lastTime = 20200101; %回测结束时间
site_temp=find(z_date>=initTime);
site_date_ini=site_temp(1);  %确定开始时间的位置，如果使用处理好的数据，此参数为固定
daynum = 0;                            %时间计数
%lead-lag参数
derta=0.001;                          %显著性水平
shareNum=10000000;                        %设置初始金额；
cost=0.0025;
fai=0.1;
%alpha参数
len20=20;
len6=6;
len5=5;
len12=12;
len_A13=5;
freq = 1;
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

for ii=1:length(date_valid)-site_date_ini+1
    %% 计算区：
    current_date=z_date(site_date_ini+daynum) %当天日期
    current_month=floor(current_date/100);     %当月月份
    daynum = daynum+1;                         %记录时间。
    % 计算lead-lag开始月份
    if current_month-floor(current_month/100)*100 > p_len_time
            begin_month=current_month-p_len_time;
        elseif current_month-floor(current_month/100)*100 <= p_len_time
            begin_month=current_month-100+12-p_len_time;
    end  
     
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %% 交易频率信号
        if isempty(month_info_begin)||month_info_begin ~= current_month    %以月为频率进行交易
            month_info_begin=current_month;
            
            if current_month==201508
                current_month;
            end
            %% 交易准备：
              getAlpha =  f_Alpha026(z_high,z_vol,current_date,len5); %获取alpha001因子

             % 1.进行资金分配：两种方式（1）如果纯alpha 或者 MA：均分（2）加入lead-lag：按照lead-lag计算后的比例
            sum_share=1;                                %资金分配的分母
              
            if consac_sig==1
                [money_total_hold, daily_income(2,site_date_ini+daynum-1)]=f_daily_calculate(target_calculate_structure,z_ST,site_date_ini,daynum);
                final_shareNum(2 ,site_date_ini+daynum-1 )=money_total_hold+left_money-cost_sum(end);
            end
            total=final_shareNum(2 ,site_date_ini+daynum-1 )/length(find(getAlpha>0));
                     
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %% 交易开始
            if consac_sig==0 %第一次交易
                 consac_sig=1;
%                  final_shareNum(2,)=final_shareNum(2,-1)
                target_calculate_structure(1:end,3)=z_ST(find(ismember(z_ST(:,1),target_calculate_structure(:,1))),site_date_ini+daynum);
                target_calculate_structure(1:end,2)=target_calculate_structure(1:end,3);
                 if length(find(getAlpha>0))==0
%                       target_calculate_structure(:,)=0;
                        target_calculate_structure(:,5)=0;
                        target_calculate_structure(:,7)=0;
                        left_money= final_shareNum(2 ,site_date_ini+daynum-2 );
                 else
                    % 开始循环，每只股票循环一次
                    for coi=1:length(z_stock)
                        total_coi=0;                   
                        if getAlpha(coi)<0
                            target_calculate_structure(coi,5)=0;
                            target_calculate_structure(coi,7)=0;
                        elseif getAlpha(coi)>0 && isnan(target_calculate_structure(coi,3)) % 应该买，但没买成
                            left_money=left_money+total;
                            target_calculate_structure(coi,5)=0;
                            target_calculate_structure(coi,7)=0;
                        elseif getAlpha(coi)>0 && ~isnan(target_calculate_structure(coi,3))
                            target_calculate_structure(coi,7)=floor(( total/target_calculate_structure(coi,3))/100);
                            target_calculate_structure(coi,6)= target_calculate_structure(coi,7);
                            target_calculate_structure(coi,5)=target_calculate_structure(coi,7)*target_calculate_structure(coi,3)*100;
                            target_calculate_structure(coi,4)=target_calculate_structure(coi,5);            
                            left_money=left_money +  total - target_calculate_structure(coi,5); %没买成整手数的钱存入现金
                        end
                    end
                    cost_sum = cost_sum + cost*sum(target_calculate_structure(find(~isnan(target_calculate_structure(:,5))),5));
                 end
            elseif consac_sig==1  %不是第一次交易了，要先清算，再买卖
%                  [money_total_hold, daily_income(2,site_date_ini+daynum-1)]=f_daily_calculate(target_calculate_structure,z_ST,site_date_ini,daynum);
%                  final_shareNum(2 ,site_date_ini+daynum-1 )=money_total_hold+left_money;
                 target_calculate_structure(1:end,2)= target_calculate_structure(1:end,3);
                 target_calculate_structure(1:end,3)=z_ST(find(ismember(z_ST(:,1),target_calculate_structure(:,1))),site_date_ini+daynum);
                 target_calculate_structure(1:end,6)= target_calculate_structure(1:end,7);  
                 target_calculate_structure(:,7)=0;
                 target_calculate_structure(1:end,4)= target_calculate_structure(1:end,5);
                 target_calculate_structure(:,5)=0;
                 target_calculate_structure(1:end,3)=z_ST(find(ismember(z_ST(:,1),target_calculate_structure(:,1))),site_date_ini+daynum);
                 left_money=0;
                 if length(find(getAlpha>0))==0
%                       target_calculate_structure(:,)=0;
                        target_calculate_structure(:,5)=0;
                        target_calculate_structure(:,7)=0;
                        left_money= final_shareNum(2 ,site_date_ini+daynum-2 );
                 else
                    % 开始循环，每只股票循环一次
                    for coi=1:length(z_stock)
                        total_coi=0;                   
                        if getAlpha(coi)<0
                            target_calculate_structure(coi,5)=0;
                            target_calculate_structure(coi,7)=0;
                        elseif getAlpha(coi)>0 && isnan(target_calculate_structure(coi,3)) % 应该买，但没买成
                            left_money=left_money+total;
                            target_calculate_structure(coi,5)=0;
                            target_calculate_structure(coi,7)=0;
                        elseif getAlpha(coi)>0 && ~isnan(target_calculate_structure(coi,3))
                            target_calculate_structure(coi,7)=floor(( total/target_calculate_structure(coi,3))/100);
                            target_calculate_structure(coi,5)=target_calculate_structure(coi,7)*target_calculate_structure(coi,3)*100;
                            left_money=left_money +  total - target_calculate_structure(coi,5); %没买成整手数的钱存入现金
                        end
                    end
                    
                    shou=target_calculate_structure(:,7)-target_calculate_structure(:,6);
                    costly_today=0;
                    for cc=1:length(shou)
                        if shou(cc)>0
                            costly_today=costly_today+cost*shou(cc)*target_calculate_structure(cc,3)*100;
                        end
                    end
                    target_calculate_structure(:,6)=target_calculate_structure(:,7);                                       
                    cost_sum = [cost_sum,costly_today]  ;
                 end
                 
            end
            
        else  %还在本月，不交易           
            %% 日常核算区：
            
                 [money_total_hold, daily_income(2,site_date_ini+daynum-1)]=f_daily_calculate(target_calculate_structure,z_ST,site_date_ini,daynum);
                  final_shareNum(2 ,site_date_ini+daynum-1 )=money_total_hold+left_money;
        end
            
           
end



%   x=1:length(final_shareNum(1,site_date_ini:end));
  x=1:length(index_daily(2:end,2))
  for fi=2:length(x)+1
    ss_shareNum(fi-1)=find(final_shareNum(1,:)==index_daily(fi,1));
  end
    plot(x-1,final_shareNum(2,ss_shareNum))
    hold on;
    plot(x,shareNum*index_daily(2:end,2))
    
    sum(cost_sum)
    rate_final=(final_shareNum(2,end)-final_shareNum(2,1))/final_shareNum(2,1)















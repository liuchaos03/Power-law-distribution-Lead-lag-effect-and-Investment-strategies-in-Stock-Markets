
 %% ������
%ʱ���
t_time=20090901;%ѵ����ʼ����
initTime = 20100101; %�ز⿪ʼʱ��
lastTime = 20110101; %�ز����ʱ��
site_temp=find(z_date>=initTime);
site_date_ini=site_temp(1);  %ȷ����ʼʱ���λ�ã����ʹ�ô���õ����ݣ��˲���Ϊ�̶�
daynum = 0;                            %ʱ�����
%lead-lag����
derta=0.001;                          %������ˮƽ
shareNum=10000000;                         %���ó�ʼ��
cost=0;
fai=0.1;
%alpha����
len20=20;
len5=5;
freq = 1;
%% ����ָ���ʼ��
daily_income=zeros(2,length(date_valid)); %����
daily_income(1,1:end)=date_valid;         %

final_shareNum=zeros(2,length(date_valid)); %ÿ���ܽ��
final_shareNum(1,1:end)=date_valid;
final_shareNum(2,1:site_date_ini)=shareNum;

consac_sig=0;    %�����ź�
%% %%׼�����Բ���
%˵��������Ϊ��λ������ˢ��Ƶ�ʽ���ѭ��
    month_info=[];
    month_info_begin=[];
    %���㽻�����������¼�����Ʊ������
    %1����Ĵ��룻2�����쵥�ۣ�3�����쵥�ۣ�4.�����ܽ�5�������ܽ�6������������7����������
    target_calculate_structure=zeros(length(z_stock),7);
    target_calculate_structure(1:end,1)=z_stock;
    %
    abc_bcd=zeros(length(z_stock),3);
    abc_bcd(1:end,1)=z_stock;
    cost_sum=0;
    left_money=0;
    %�����źţ�1.��Ʊ���룻2.lead-lag�źţ�3.����Ǯ��
    final_table = zeros(length(z_stock(:,1)),3);
    final_table(:,1)=z_stock;

for ii=1:length(date_valid)-site_date_ini+1
    %% ��������
    current_date=z_date(site_date_ini+daynum) %��������
    current_month=floor(current_date/100);     %�����·�
    daynum = daynum+1;                         %��¼ʱ�䡣
    % ����lead-lag��ʼ�·�
    if current_month-floor(current_month/100)*100 > p_len_time
            begin_month=current_month-p_len_time;
        elseif current_month-floor(current_month/100)*100 <= p_len_time
            begin_month=current_month-100+12-p_len_time;
    end  
    if current_date==20100101
        current_date;
    end
    %% lead-lag������������ÿ���µ��µĵ��
        if isempty(month_info)
           month_info=current_month;
            data_train_current=f_data_inputs(us2,begin_month*100,current_month*100);
           [~,~,data_train_re_current]=f_recode(data_train_current);
           [sum2,point_pair]=f_calculateF_sy(data_train_re_current,fai,derta);          
           pair_sort=sortrows(point_pair,-3); 
        elseif month_info ~= current_month%%���뵽��һ���£����µ�����Ʊ��
           month_info=current_month;    
           data_train_current=f_data_inputs(us2,begin_month*100,current_month*100);
           [~,~,data_train_re_current]=f_recode(data_train_current);
           [sum2,point_pair]=f_calculateF_sy(data_train_re_current,fai,derta);          
           pair_sort=sortrows(point_pair,-3);         
        end 
        target_copy=f_lead_lag(pair_sort,z_ST,site_date_ini,daynum);
            final_table = zeros(length(z_stock(:,1)),3);
            final_table(:,1)=z_stock;
        for f_t=1:length(final_table(:,1))
            if ~isempty(find(target_copy(:,1)==final_table(f_t,1,1), 1))
                final_table(f_t,2)=final_table(f_t,2)+target_copy(find(target_copy(:,1)==final_table(f_t,1,1)),2);
            end
        end
        
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %% ����Ƶ���ź�
        if isempty(month_info_begin)||month_info_begin ~= current_month    %����ΪƵ�ʽ��н���
           if  sum(length(find(~isnan(z_ST(2:end,site_date_ini+daynum)))))<100
                final_shareNum(2 ,site_date_ini+daynum-1 )=final_shareNum(2,site_date_ini+daynum-2 )
            else    
            month_info_begin=current_month;
            %% ����׼����
              getAlpha = f_Alpha033(z_open,z_ST,current_date,10); %��ȡalpha001����
             % 1.�����ʽ���䣺���ַ�ʽ��1�������alpha ���� MA�����֣�2������lead-lag������lead-lag�����ı���
            sum_share=0;                                %�ʽ����ķ�ĸ
              for  t_f_t=1:length(final_table)            %�����ź�
                  if getAlpha(t_f_t)<=0
                      final_table(t_f_t,2)=0;
                  end
              end    
            for t_f_t=1:length(final_table)             %������Ȩ��
                if final_table(t_f_t,2)>0
                    sum_share=sum_share+final_table(t_f_t,2);                
                end
            end
            if consac_sig==1
                [money_total_hold, daily_income(2,site_date_ini+daynum-1)]=f_daily_calculate(target_calculate_structure,z_ST,site_date_ini,daynum);
                final_shareNum(2 ,site_date_ini+daynum-1 )=money_total_hold+left_money-cost_sum(end);
            else
                final_shareNum(2 ,site_date_ini+daynum-1 )=final_shareNum(2 ,site_date_ini+daynum-2 );
            end
            for t_f_t=1:length(final_table)             %������
                if final_table(t_f_t,2)>0
                    final_table(t_f_t,3)=final_shareNum(2 , site_date_ini+daynum-1)*final_table(t_f_t,2)/sum_share;
                end
            end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %% ���׿�ʼ
            if consac_sig==0 %��һ�ν���
                 consac_sig=1;
%                  final_shareNum(2,)=final_shareNum(2,-1)
                target_calculate_structure(1:end,3)=z_ST(find(ismember(z_ST(:,1),target_calculate_structure(:,1))),site_date_ini+daynum);
                target_calculate_structure(1:end,2)=target_calculate_structure(1:end,3);
                 if sum_share==0
%                       target_calculate_structure(:,)=0;
                        target_calculate_structure(:,5)=0;
                        target_calculate_structure(:,7)=0;
                        left_money= final_shareNum(2 ,site_date_ini+daynum-2 );
                 else
                    % ��ʼѭ����ÿֻ��Ʊѭ��һ��
                    for coi=1:length(z_stock)
                        total_coi=0;                   
                        if final_table(coi,3)<0
                            target_calculate_structure(coi,5)=0;
                            target_calculate_structure(coi,7)=0;
                        elseif final_table(coi,3)>0 && isnan(target_calculate_structure(coi,3)) % Ӧ���򣬵�û���
                            left_money=left_money+final_table(coi,3);
                            target_calculate_structure(coi,5)=0;
                            target_calculate_structure(coi,7)=0;
                        elseif final_table(coi,3)>0 && ~isnan(target_calculate_structure(coi,3))
                            target_calculate_structure(coi,7)=floor(( final_table(coi,3)/target_calculate_structure(coi,3))/100);
                            target_calculate_structure(coi,6)= target_calculate_structure(coi,7);
                            target_calculate_structure(coi,5)=target_calculate_structure(coi,7)*target_calculate_structure(coi,3)*100;
                            target_calculate_structure(coi,4)=target_calculate_structure(coi,5);            
                            left_money=left_money +  final_table(coi,3) - target_calculate_structure(coi,5); %û�����������Ǯ�����ֽ�
                        end
                    end
                    cost_sum = cost_sum + cost*sum(target_calculate_structure(find(~isnan(target_calculate_structure(:,5))),5));
                 end
            elseif consac_sig==1  %���ǵ�һ�ν����ˣ�Ҫ�����㣬������
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
                 if sum_share==0
%                       target_calculate_structure(:,)=0;
                        target_calculate_structure(:,5)=0;
                        target_calculate_structure(:,7)=0;
                        left_money= final_shareNum(2 ,site_date_ini+daynum-2 );
                 else
                    % ��ʼѭ����ÿֻ��Ʊѭ��һ��
                    for coi=1:length(z_stock)
                        total_coi=0;                   
                        if final_table(coi,3)<0
                            target_calculate_structure(coi,5)=0;
                            target_calculate_structure(coi,7)=0;
                        elseif final_table(coi,3)>0 && isnan(target_calculate_structure(coi,3)) % Ӧ���򣬵�û���
                            left_money=left_money+final_table(coi,3);
                            target_calculate_structure(coi,5)=0;
                            target_calculate_structure(coi,7)=0;
                        elseif final_table(coi,3)>0 && ~isnan(target_calculate_structure(coi,3))
                            target_calculate_structure(coi,7)=floor(( final_table(coi,3)/target_calculate_structure(coi,3))/100);
                            target_calculate_structure(coi,5)=target_calculate_structure(coi,7)*target_calculate_structure(coi,3)*100;                                   
                            left_money=left_money +  final_table(coi,3) - target_calculate_structure(coi,5); %û�����������Ǯ�����ֽ�
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
            end
        else  %���ڱ��£�������           
            %% �ճ���������
            
                 [money_total_hold, daily_income(2,site_date_ini+daynum-1)]=f_daily_calculate(target_calculate_structure,z_ST,site_date_ini,daynum);
                  final_shareNum(2 ,site_date_ini+daynum-1 )=money_total_hold+left_money;
        end
            
           
end



common_date=intersect(index_daily(:,1),final_shareNum(1,:));
for fi=1:length(common_date)
    site_index(fi)=find(index_daily(:,1)==common_date(fi));

    site_shareNum(fi)=find(final_shareNum(1,:)==common_date(fi));
end
    
    
  
    plot(1:length(common_date),final_shareNum(2,site_shareNum))
    hold on;
    plot(1:length(common_date),shareNum*index_daily(site_index,2))
    
 
    rate_final=(final_shareNum(2,end)-final_shareNum(2,1))/final_shareNum(2,1)
% find()













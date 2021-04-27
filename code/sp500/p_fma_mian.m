
clear;
clc;
clear global ;

%% ���ݶ�ȡ
 filename = 'final_csi_09-20'  ;         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��������
 load([filename , '.mat']);
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
cost=0.0025;
fai=0.1;
%alpha����
long=20;
short=5;
freq = 1;
fix_count=20;
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
hold_money=shareNum;
for ii=1:length(date_valid)-site_date_ini+1
    %% ��������
    current_date=z_date(site_date_ini+daynum) %��������
    current_month=floor(current_date/100);     %�����·�
    daynum = daynum+1;                         %��¼ʱ�䡣
    % ����lead-lag��ʼ�·�
    if current_date==[20110204]
        current_date;
    end
    
    if current_month-floor(current_month/100)*100 > p_len_time
            begin_month=current_month-p_len_time;
        elseif current_month-floor(current_month/100)*100 <= p_len_time
            begin_month=current_month-100+12-p_len_time;
    end  
    target_calculate_structure(1:end,3)=z_ST(find(ismember(z_ST(:,1),target_calculate_structure(:,1))),site_date_ini+daynum);

    LongLine = f_ma_calculate(z_ST,site_date_ini,daynum,long);       % ������
    ShortLine = f_ma_calculate(z_ST,site_date_ini,daynum,short);     % �̾���
    
     total_coi=hold_money/200;
    for coi=1:length(z_stock)
        
        %% ��λ
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
                left_money=left_money +  total_coi - target_calculate_structure(coi,5); %û�����������Ǯ�����ֽ�
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













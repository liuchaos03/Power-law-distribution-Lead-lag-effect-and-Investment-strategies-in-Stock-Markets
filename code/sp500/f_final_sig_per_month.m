function [final_table]=f_final_sig_per_month(pair_sort,current_date,z_stock,z_ST)

%% 计算时间长度：一个月

    final_table = zeros(length(z_stock(:,1)),3);
    final_table(:,1)=z_stock;
    current_month=floor(current_date/100);     %当月月份
    if current_month-floor(current_month/100)*100 > 1
            begin_month=current_month-1;
        elseif current_month-floor(current_month/100)*100 <= 1
            begin_month=current_month-100+12-1;
    end
    bigger=find(z_ST(1,:)<current_month*100);
    date_train=find(z_ST(1,bigger)>begin_month*100);
%     z_ST(1,date_train+1)
    for i=1:length(date_train)
        

        target_copy=f_lead_lag(pair_sort,z_ST,date_train(1),i);
%             
        for f_t=1:length(final_table(:,1))
            if ~isempty(find(target_copy(:,1)==final_table(f_t,1,1), 1))
                final_table(f_t,2)=final_table(f_t,2)+target_copy(find(target_copy(:,1)==final_table(f_t,1,1)),2);
            end
        end
    end






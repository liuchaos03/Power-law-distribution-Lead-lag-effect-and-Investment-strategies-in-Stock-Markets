function [target_copy]=f_lead_lag(pair_sort,z_ST,site_date_ini,daynum)

 %% ¼ÆËãlead-lag
          leader_info=unique(pair_sort(:,1));
          main_strctre=struct('leader', {},'yesterday_close',{},'today_close',{},'rate',{},'rate100',{},'level',{});
          for sum_abc=1:length(leader_info(:,1))
            main_strctre(sum_abc).leader=leader_info(sum_abc,1);
            %find(recode_list(:,2)==str2num(cell2mat(leader_info(sum_abc,1))))
%             main_strctre(find(recode_list(:,2)==str2num(cell2mat(leader_info(sum_abc,1))))).yesterday_close=close_info(sum_abc,1);
%             main_strctre(find(recode_list(:,2)==str2num(cell2mat(leader_info(sum_abc,1))))).today_close=close_info(sum_abc,2);
%             main_strctre(sum_abc).rate=(main_strctre(sum_abc).today_close - main_strctre(sum_abc).yesterday_close)/ main_strctre(sum_abc).yesterday_close;
             main_strctre(sum_abc).yesterday_close=z_ST(find(z_ST(:,1)==leader_info(sum_abc,1)),site_date_ini+daynum-1);
             main_strctre(sum_abc).today_close=z_ST(find(z_ST(:,1)==leader_info(sum_abc,1)),site_date_ini+daynum);
            main_strctre(sum_abc).rate=(main_strctre(sum_abc).today_close - main_strctre(sum_abc).yesterday_close)/ main_strctre(sum_abc).yesterday_close;
            main_strctre(sum_abc).rate100=main_strctre(sum_abc).rate*100;
          end 
         del_num=1;
        del_site=[];
        
        
         for sum_abc_l=1:length(main_strctre)
          
            if main_strctre(sum_abc_l).rate==0
                    main_strctre(sum_abc_l).level=main_strctre(sum_abc_l).rate;
            elseif main_strctre(sum_abc_l).rate > 0
%                      main_strctre(sum_abc_l).level=floor(main_strctre(sum_abc_l).rate*100);    
                     main_strctre(sum_abc_l).level=main_strctre(sum_abc_l).rate*100;
            else 
%                          main_strctre(sum_abc_l).level=ceil(main_strctre(sum_abc_l).rate*100);
                         main_strctre(sum_abc_l).level=main_strctre(sum_abc_l).rate*100;
            end  
        end
        %% %%
        point_copy=pair_sort;   
         target_transaction_table=struct('leader', {},'level',{},'follower',{},'weight',{},'share_rate',{});
   
        for t_t_t=1:length(point_copy(:,1))
            target_transaction_table(t_t_t).leader=unique(point_copy(t_t_t,1));           
            target_transaction_table(t_t_t).follower=unique(point_copy(t_t_t,2));
            target_transaction_table(t_t_t).weight=point_copy(t_t_t,3) ;
        end
        for compr1=1:length(target_transaction_table)
            for compr2=1:length(main_strctre)
                if target_transaction_table(compr1).leader==main_strctre(compr2).leader                  
                    
                    target_transaction_table(compr1).level=main_strctre(compr2).level;
                    break;
                end
            end
        end
        for s_r=1:length(target_transaction_table)
            target_transaction_table(s_r).share_rate=target_transaction_table(s_r).level*target_transaction_table(s_r).weight;
        end
        targetList=unique(pair_sort(:,2));
        target_copy=zeros(length(targetList),2);
        for ll=1:length(targetList)
            target_copy(ll,1)=targetList(ll);            
        end
        for tar_c=1:length(target_copy)
            for t_v_t=1:length(target_transaction_table)
                if target_copy(tar_c,1)==target_transaction_table(t_v_t).follower && ~isempty(target_transaction_table(t_v_t).share_rate) && ~isnan((target_transaction_table(t_v_t).share_rate))
                        target_copy(tar_c,2)=target_copy(tar_c,2)+ target_transaction_table(t_v_t).share_rate;
                   
                end
            end
        end
        target_copy;
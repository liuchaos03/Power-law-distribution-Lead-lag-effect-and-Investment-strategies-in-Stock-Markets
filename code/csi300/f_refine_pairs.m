function [final]=f_refine_pairs(pair_sort,current_date,z_ST)

   final_sta_sig_monthly=[];
     %% 计算时间，一个月
      current_month=floor(current_date/100);     %当月月份
     if current_month-floor(current_month/100)*100 > 1
            begin_month=current_month-1;
        elseif current_month-floor(current_month/100)*100 <= 1
            begin_month=current_month-100+12-1;
    end  
     
     date_bigger=find(z_ST(1,:)<current_month*100)
     date_test_site=find(z_ST(1,date_bigger)>=begin_month*100)
     date_test=z_ST(1,date_test_site)
     
%% 开始计算准确率
     sig_set=zeros(length(pair_sort(:,1)),6);
     sig_set(:,1)=pair_sort(:,1);
     sig_set(:,3)=pair_sort(:,2);
     sig_set(:,5)=sign(pair_sort(:,3));
    for ii=1:length(date_test)
        ii;
       
        for iii=1:length(sig_set(:,1))
            iii;
            l_site=find(z_ST(:,1)==sig_set(iii,1));
            f_site=find(z_ST(:,1)==sig_set(iii,3));
            if ii~=length(date_test)-1 && ~isempty(l_site)&& ~isempty(f_site)
            
                if (isnan(z_ST(l_site,ii+1)-z_ST(l_site,ii))||z_ST(l_site,ii+1)-z_ST(l_site,ii)==0)
                    sig_set(iii,2)=0;
                elseif z_ST(l_site,ii+1)-z_ST(l_site,ii)>0
                    sig_set(iii,2)=1;
                elseif z_ST(l_site,ii+1)-z_ST(l_site,ii)<0
                    sig_set(iii,2)=-1;
                end

                if isnan(z_ST(f_site,ii+2)-z_ST(f_site,ii+1))||z_ST(f_site,ii+2)-z_ST(f_site,ii+1)==0
                    sig_set(iii,4)=0;
                elseif z_ST(f_site,ii+2)-z_ST(f_site,ii+1)>=0
                    sig_set(iii,4)=1;
                elseif z_ST(f_site,ii+2)-z_ST(f_site,ii+1)<0
                    sig_set(iii,4)=-1;
                end
                if sig_set(iii,5)>0&&sig_set(iii,2)>0
                    if sig_set(iii,4)>=0
                        sig_set(iii,6)=1;
                    elseif sig_set(iii,4)<0
                        sig_set(iii,6)=-1;
                    else
                        sig_set(iii,6)=0;
                    end
%                   sig_set(iii,6)=sig_set(iii,4)* sig_set(iii,2);
                elseif sig_set(iii,5)<0&&sig_set(iii,2)<0
%                     sig_set(iii,6)=sig_set(iii,4)* sig_set(iii,2);
                    if sig_set(iii,4)>=0
                        sig_set(iii,6)=1;
                    elseif sig_set(iii,4)<0
                        sig_set(iii,6)=-1;
                    else
                        sig_set(iii,6)=0;
                    end
                else
                    sig_set(iii,6)=0;
                end
            end
        end
         final_sta_sig_monthly=[final_sta_sig_monthly,sig_set(:,6)];
    end
   final_sta_sig_monthly
   find(final_sta_sig_monthly==1)
    find(sum(final_sta_sig_monthly,2)>0)
    final=pair_sort(find(sum(final_sta_sig_monthly,2)>0),:)
    
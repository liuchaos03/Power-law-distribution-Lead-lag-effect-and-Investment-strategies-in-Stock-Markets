function alpha =f_Alpha004(z_low,current_date,len)


site_date_st=find(z_low(1,:)==current_date);
alpha=nan(1,length(z_low(:,1))-1);
% value_a=nan(1,length(z_low(:,1))-1);
low_a=nan(1,length(z_low(:,1))-1);
sum_low=nan(length(z_low(:,1))-1,len);
% % (current_site-1:site_date_st-len5);
 SITE=find(~isnan(z_low(2:end,site_date_st)));
 targetNum=length(SITE);

 
 
 for i=2:length(z_low(:,1))
     if (1==isnan(z_low(i,site_date_st)))
           continue;
     else
         low_a(i-1)=z_low(i,site_date_st)   ;     
%         value_a(i-1)=f_rank(low_s);
     end       
 end
 for t=1:len
    for i=2:length(z_low(:,1))
        if (1==isnan(z_low(i,site_date_st)))
           continue;
        else 
            sum_low(i-1,t)=z_low(i,site_date_st-t);
        end
    end
     
 end
 value_a=f_tool_ts_rank(sum_low,low_a,'ascend');
 value_site=find(~isnan(value_a));
 abs_value=value_a(value_site);
 value_rank=f_rank(abs_value);
 for j=1:length(value_rank)
     alpha(value_site(j))=value_rank(j);
 end
 
alpha=-alpha+0.5;
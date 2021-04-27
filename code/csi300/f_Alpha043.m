function alpha =f_Alpha043(z_ST,z_vol,current_date,len1,len2)


site_date_st=find(z_ST(1,:)==current_date);
alpha=nan(1,length(z_ST(:,1))-1);


 SITE=find(~isnan(z_ST(2:end,site_date_st)));
 targetNum=length(SITE);
 

 for i=2:length(z_ST(:,1))
     if (1==isnan(z_ST(i,site_date_st)))
         value_a(i-1,1:len1)=nan;
           continue;
     else
         adv_s=f_tool_adv20_len(i,z_vol,current_date,len1); 
         for j=1:len1
            value_a(i-1,j)=z_vol(i,site_date_st)/adv_s(j);
         end
     end       
 end
 for m=1:length(value_a(:,1))
     
    value_adv20(m)=f_tool_ts_rank(value_a(m,:),value_a(m,1),'ascend');
 end
 
    for i=2:length(z_ST(:,1))
        if (1==isnan(z_ST(i,site_date_st)))
            close_s(i-1,1:len2)=nan;
           continue;
        else 
             for t=1:len2
                close_s(i-1,t)=  z_ST(i,site_date_st-t+1) -z_ST(i,site_date_st-t+1-len2);
                
             end
        end
    end
     
 for m=1:length(close_s(:,1))
    value_st(m)=f_tool_ts_rank(close_s(m,:),close_s(m,1),'ascend');
 end

 for s=1:length(value_adv20)
  value(s)=value_st(s)*value_adv20(s);
 end
 value_site=find(~isnan(value));
 abs_value=value(value_site);
 value_rank=f_rank(abs_value);
 for j=1:length(value_rank)
     alpha(value_site(j))=value_rank(j);
 end
  alpha=-alpha+0.5;
  
  
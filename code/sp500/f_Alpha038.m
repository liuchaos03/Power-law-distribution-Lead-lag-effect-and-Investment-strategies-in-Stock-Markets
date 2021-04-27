function alpha =f_Alpha038(z_open,z_ST,current_date,len)


site_date_st=find(z_ST(1,:)==current_date);
alpha=nan(1,length(z_ST(:,1))-1);
alpha_s=nan(1,length(z_ST(:,1))-1);
value_a=nan(1,length(z_ST(:,1))-1);
value_close_open_s=nan(1,length(z_ST(:,1))-1);
% % (current_site-1:site_date_st-len5);
 SITE=find(~isnan(z_ST(2:end,site_date_st)));
 targetNum=length(SITE);

 
 
 for i=2:length(z_ST(:,1))
     if (1==isnan(z_ST(i,site_date_st)))
           continue;
     else
        close_s=z_ST(i,site_date_st-len:site_date_st-1);
        
        
        value_a(i-1)=f_tool_ts_rank(close_s,z_ST(i,site_date_st),'descend');

     end
 end
for i=2:length(z_ST(:,1))
     if (1==isnan(z_ST(i,site_date_st)))
           continue;
     else
             
         value_close_open_s(i-1)=z_ST(i,site_date_st)/z_open(i,site_date_st);
     end
 end
 
 value_site=find(~isnan(value_a));
 abs_value=value_a(value_site);
 value_rank=f_rank(abs_value);
 value_site2=find(~isnan(value_close_open_s));
 abs_value_o=value_a(value_site2);
 value_rank_o=f_rank(abs_value_o);
 for j=1:length(value_site2)
     alpha_s(value_site(j))=-1*value_rank(j)*value_rank_o(j);
 end
 alpha=f_rank(alpha_s);
alpha=alpha-0.5;
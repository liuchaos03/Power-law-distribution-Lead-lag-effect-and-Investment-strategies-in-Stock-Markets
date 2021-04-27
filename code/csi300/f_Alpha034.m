function alpha =f_Alpha034(z_open,z_ST,current_date,len1,len2)


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
        close_2(i-1)=std(z_ST(i,site_date_st-len1:site_date_st-1));
        close_7(i-1)=std(z_ST(i,site_date_st-len2:site_date_st-1));
        close_final(i-1)=close_2(i-1)/close_7(i-1);
     end
 end

for i=2:length(z_ST(:,1))
     if (1==isnan(z_ST(i,site_date_st)))
           continue;
     else             
         close_cha(i-1)=z_ST(i,site_date_st)-z_ST(i,site_date_st-1);
     end
 end
  value_a=(f_rank(close_final))+(f_rank(close_cha));
 value_site=find(~isnan(value_a));
 abs_value=value_a(value_site);
 value_rank=f_rank(abs_value);
 value_site=find(~isnan(value_rank));
 abs_value_o=value_a(value_site);
 value_rank_o=f_rank(abs_value_o);
 for j=1:length(value_rank)
     alpha_s(value_site(j))=-1*value_rank(j)*value_rank_o(j);
 end
 alpha=f_rank(alpha_s);
alpha=alpha-0.5;
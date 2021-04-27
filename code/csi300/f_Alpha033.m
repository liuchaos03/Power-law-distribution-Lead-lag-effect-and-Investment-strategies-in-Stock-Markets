function alpha =f_Alpha033(z_open,z_ST,current_date,len)


site_date_st=find(z_ST(1,:)==current_date);
alpha=nan(1,length(z_ST(:,1))-1);
value_a=nan(1,length(z_ST(:,1))-1);
% % (current_site-1:site_date_st-len5);
 SITE=find(~isnan(z_ST(2:end,site_date_st)));
 targetNum=length(SITE);

 
 
 for i=2:length(z_ST(:,1))
     if (1==isnan(z_ST(i,site_date_st)))
           continue;
     else
        close_s=mean(z_ST(i,site_date_st-len:site_date_st-1));
        open_s=mean(z_open(i,site_date_st-len:site_date_st-1));
        value_a(i-1)=-(1-(open_s/close_s));
     end       
 end
 
 value_site=find(~isnan(value_a));
 abs_value=value_a(value_site);
 value_rank=f_rank(abs_value);
 for j=1:length(value_rank)
     alpha(value_site(j))=value_rank(j);
 end
 
alpha=-alpha+0.5;
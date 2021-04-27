function alpha =f_Alpha003(z_open,z_vol,current_date,len)
% len=20;
% current_date=20110104;
site_date_st=find(z_open(1,:)==current_date);
alpha=nan(1,length(z_open(:,1))-1);
value_a=nan(1,length(z_open(:,1))-1);
% % (current_site-1:site_date_st-len5);
 SITE=find(~isnan(z_open(2:end,site_date_st)));
 targetNum=length(SITE);

 for i=2:length(z_open(:,1))
     if (1==isnan(z_open(i,site_date_st)))
           continue;
       else
     open_s=z_open(i,site_date_st-len:site_date_st-1);
     vlomume_s=z_vol(i,site_date_st-len:site_date_st-1);
     corr_value=corrcoef(f_rank(open_s),f_rank(vlomume_s));
     value_a(i-1)=corr_value(1,2);
     end
       
     
 end
 
 
 
 
value_site=find(~isnan(value_a));
 abs_value=value_a(value_site);
 value_rank=f_rank(abs_value);
 for j=1:length(value_rank)
     alpha(value_site(j))=value_rank(j);
 end
 
alpha=-alpha+0.5;

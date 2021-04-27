function alpha =f_Alpha037(z_ST,z_open,current_date,len)
% len=20;
% current_date=20110104;
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
         for j=1:len
             close_open(j)=(z_open(i,site_date_st-j+1)-z_ST(i,site_date_st-j+1))-(z_open(i,site_date_st-j)-z_ST(i,site_date_st-j));
         end
             close_s=z_ST(i,site_date_st-len:site_date_st-1);
         corr_value=corrcoef(close_open,close_s);
        value_a(i-1)=corr_value(1,2);
     end
 end
 for i=2:length(z_ST(:,1))
     o_c(i-1)=z_open(i,site_date_st)-z_ST(i,site_date_st);
 end
        
 value_site=find(~isnan(value_a));
 abs_value=value_a(value_site);

 
 if isempty(abs_value)
     alpha(1:end)=0;
     
 else
     value_rank=f_rank(abs_value);
%      oc_rank=f_rank(o_c); 
     for j=1:length(value_rank)
        alpha(value_site(j))=value_rank(j);
     end
     alpha=-alpha+0.5;
 end
function alpha =f_Alpha055(z_ST,z_vol,z_low,z_high,current_date,len6,len12)

site_date_st=find(z_ST(1,:)==current_date);
alpha=nan(1,length(z_ST(:,1))-1);

 SITE=find(~isnan(z_ST(2:end,site_date_st)));
 
  for i=2:length(z_ST(:,1))
       if (1==isnan(z_ST(i,site_date_st)))
           continue;
       else
          
               low_s=z_low(i,site_date_st-len6-len12+2:site_date_st);
               high_s=z_high(i,site_date_st-len6-len12+2:site_date_st);
               close_s=z_ST(i,site_date_st);
               for j=1:len6
                   ran_low(j)=close_s-min(low_s(j:j+len12-1));
                   ran_hig(j)=max(high_s(j:j+len12-1))-min(low_s(j:j+len12-1));
                   ran_final(j)=ran_low(j)/ran_hig(j);
               end
               vol_s=z_vol(i,site_date_st-len6+1:site_date_st);
               corr_value=corrcoef(f_rank(ran_final),f_rank(vol_s)) ;
               value_a(i)=corr_value(1,2);
       end
  end
value_site=find(~isnan(value_a));
 abs_value=value_a(value_site);
 value_rank=f_rank(abs_value);
 for j=1:length(value_rank)
     alpha(value_site(j))=value_rank(j);
 end
 
alpha=-alpha+0.5;            
               
               
               
               
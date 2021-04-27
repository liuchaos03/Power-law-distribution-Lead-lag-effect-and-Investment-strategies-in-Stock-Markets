function alpha =f_Alpha053(z_ST,z_vol,z_low,z_high,current_date,len)

site_date_st=find(z_ST(1,:)==current_date);
alpha=nan(1,length(z_ST(:,1))-1);

 SITE=find(~isnan(z_ST(2:end,site_date_st)));
 
  for i=2:length(z_ST(:,1))
       if (1==isnan(z_ST(i,site_date_st)))
           continue;
       else
          
               low_s=z_low(i,site_date_st);
               high_s=z_high(i,site_date_st);
               close_s=z_ST(i,site_date_st);
               low_9=z_low(i,site_date_st-len+1);
               high_9=z_high(i,site_date_st-len+1);
               close_9=z_ST(i,site_date_st-len+1);
              
               
               value_a(i)=((2*close_s-low_s-high_s)/(close_s-low_s))-((2*close_9-low_9-high_9)/(close_9-low_9));
       end
  end
value_site=find(~isnan(value_a));
 abs_value=value_a(value_site);
 value_rank=f_rank(abs_value);
 for j=1:length(value_rank)
     alpha(value_site(j))=value_rank(j);
 end
 
alpha=-alpha+0.5;            
               
               
               
               
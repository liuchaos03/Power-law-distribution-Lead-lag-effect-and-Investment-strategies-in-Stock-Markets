function alpha =f_Alpha028(z_ST,z_vol,z_low,z_high,current_date,len)




site_date_st=find(z_ST(1,:)==current_date);
alpha=nan(1,length(z_ST(:,1))-1);


 SITE=find(~isnan(z_ST(2:end,site_date_st)));
 targetNum=length(SITE);
for i=2:length(z_ST(:,1))
    cha(i-1)=(z_high(i,site_date_st)+z_low(i,site_date_st))/2-z_ST(i,site_date_st);
end
    
    
 for i=2:length(z_ST(:,1))
     if (1==isnan(z_ST(i,site_date_st)))
          value_a(i-1)=-1;
           continue;
       else
     adv_s=f_tool_adv20_len(i,z_vol,current_date,len);
     low_s=z_low(i,site_date_st-len:site_date_st-1);
     
     if ~isempty(find(isnan(low_s))==1)==1||~isempty(find(isnan(adv_s))==1)==1
         value_a(i-1)=-1;
         continue;
     else
         corr_value=corrcoef(adv_s,low_s);
         value_a(i-1)=corr_value(1,2)+cha(i-1);
     end
     end      
 end
      value_site=find(~isnan(value_a));
 abs_value=value_a(value_site);
 value_rank=f_rank(abs_value);
 for j=1:length(value_rank)
     alpha(value_site(j))=value_rank(j);
 end
 
alpha=-alpha+0.5;
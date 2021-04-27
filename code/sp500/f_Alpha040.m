function alpha =f_Alpha040(z_high,z_vol,current_date,len)


site_date_st=find(z_high(1,:)==current_date);
alpha=nan(1,length(z_high(:,1))-1);
value_a=nan(1,length(z_high(:,1))-1);
% % (current_site-1:site_date_st-len5);
 SITE=find(~isnan(z_high(2:end,site_date_st)));
 targetNum=length(SITE);
rank_a=nan(1,length(z_high(:,1))-1);
 
 
 for i=2:length(z_high(:,1))
     if (1==isnan(z_high(i,site_date_st)))
           continue;
     else
        vol_s=z_vol(i,site_date_st-len:site_date_st-1);
        high_s=z_high(i,site_date_st-len:site_date_st-1);
       
        if ~isempty(find(isnan(vol_s))==1)==1||~isempty(find(isnan(high_s))==1)==1
         value_a(i-1)=nan;
         continue;
        else
        corr_value=corrcoef(vol_s,high_s);
        value_a(i-1)=corr_value(1,2);
        end
        
     end
 end
for  i=2:length(z_high(:,1))
     if (1==isnan(z_high(i,site_date_st)))
           continue;
     else
                
           std_a(i-1)=std(z_high(i,site_date_st-len:site_date_st-1));
       
     end
end
value_site=find(~isnan(value_a));
 abs_value1=value_a(value_site);
 value_site2=find(~isnan(std_a));
 abs_value2=std_a(value_site2);
 
 if isempty(abs_value1)|| isempty(abs_value2)
     alpha(1:end)=0;
     
 else
     value_rank1=f_rank(abs_value1);
     value_rank2=f_rank(abs_value2);
     for j=1:length(value_rank1)
        alpha(value_site(j))=value_rank1(j)*value_rank2(j);
     end
     alpha=-alpha+0.5;
 end




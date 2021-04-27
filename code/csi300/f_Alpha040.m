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
rank_a=f_rank(std_a);
 for i=1:length(rank_a)
    final_value(i)=rank_a(i)*value_a(i);
end
        
 value_site=find(~isnan(final_value));
 abs_value=final_value(value_site);
 value_rank=f_rank(abs_value);
 for j=1:length(value_rank)
     alpha(value_site(j))=value_rank(j);
 end
 
alpha=-alpha+0.5;
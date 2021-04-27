function alpha =f_Alpha014(z_open,z_19kc_rate,z_vol,current_date,len,len2)


site_date_st=find(z_open(1,:)==current_date);
rank_a=nan(1,length(z_open(:,1))-1);
alpha=nan(1,length(z_open(:,1))-1);
final_value=nan(1,length(z_open(:,1))-1);
value_a=nan(1,length(z_open(:,1))-1);
% % (current_site-1:site_date_st-len5);
 SITE=find(~isnan(z_open(2:end,site_date_st)));
 targetNum=length(SITE);

 
 
 for i=2:length(z_open(:,1))
     if (1==isnan(z_open(i,site_date_st)))
           continue;
     else
        vol_s=z_vol(i,site_date_st-len:site_date_st-1);
        open_s=z_open(i,site_date_st-len:site_date_st-1);
        st_s=-1*f_rank(z_19kc_rate(i,site_date_st-1)-z_19kc_rate(i,site_date_st-len2));
     if ~isempty(find(isnan(vol_s))==1)==1||~isempty(find(isnan(open_s))==1)==1
         value_a(i-1)=nan;
         continue;
     else
        corr_value=corrcoef(vol_s,open_s);
        value_a(i-1)=corr_value(1,2);
     end
     end
 end
for  i=2:length(z_open(:,1))
     if (1==isnan(z_open(i,site_date_st)))
           continue;
     else
         
        if ~isempty(find(isnan(vol_s))==1)==1
             rank_a(i-1)=-1;
             continue;
        else
            rank_a(i-1)=-1*f_rank(z_19kc_rate(i,site_date_st-1)-z_19kc_rate(i,site_date_st-len2));
        end
     end
end
for i=1:length(rank_a)
    final_value(i)=-1*rank_a(i)*value_a(i);
end
        
        
        
        
 value_site=find(~isnan(value_a));
 abs_value=value_a(value_site);
 value_rank=f_rank(abs_value);
 for j=1:length(value_rank)
     alpha(value_site(j))=value_rank(j);
 end
 
alpha=-alpha+0.5;
function alpha =f_Alpha015(z_high,z_vol,current_date,len)
% len=20;
% current_date=20110104;
site_date_st=find(z_high(1,:)==current_date);
alpha=nan(1,length(z_high(:,1))-1);
value_a=nan(1,length(z_high(:,1))-1);
high_s=zeros(length(z_high(:,1))-1,len);
vlomume_s=zeros(length(z_high(:,1))-1,len);
% % (current_site-1:site_date_st-len5);
 SITE=find(~isnan(z_high(2:end,site_date_st)));
 targetNum=length(SITE);

 for i=2:length(z_high(:,1))
     if (1==isnan(z_high(i,site_date_st)))
          high_s(i-1,:)=nan; 
          vlomume_s(i-1,:)=0;
         continue;
       else
     high_s(i-1,:)=z_high(i,site_date_st-5:site_date_st-1);
     vlomume_s(i-1,:)=z_vol(i,site_date_st-5:site_date_st-1);
     end
 end
 
 
  for i= 1:length(z_high(:,1))-1
      rank_high=f_rank(high_s(i,:));
      rank_vol=f_rank(vlomume_s(i,:));
      if length(find(isnan(high_s(i,:))))==5
          value_a(i)=nan;
      else
          i;
        corr_value=corrcoef( rank_high,rank_vol);
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

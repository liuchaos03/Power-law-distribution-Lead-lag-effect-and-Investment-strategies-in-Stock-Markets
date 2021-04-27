function alpha =f_Alpha012(z_ST,z_vol,current_date)
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
     close_s=       z_ST(i,site_date_st) -z_ST(i,site_date_st-1);
     vlomume_s=sign(z_vol(i,site_date_st)-z_vol(i,site_date_st-1));
   
     value_a(i-1)=close_s*vlomume_s;
     end
       
     
 end
 
 
 
 
value_site=find(~isnan(value_a));
 abs_value=value_a(value_site);
 value_rank=f_rank(abs_value);
 for j=1:length(value_rank)
     alpha(value_site(j))=value_rank(j);
 end
 
alpha=-alpha+0.5;

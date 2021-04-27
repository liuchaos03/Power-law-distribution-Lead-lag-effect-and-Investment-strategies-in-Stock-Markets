function [return_value]=f_tool_adv20_len(i,z_vol,current_date,len)



site_date_st=find(z_vol(1,:)==current_date);
return_value=zeros(len,1);

for j=0:len-1
    return_value(j+1)=mean(z_vol(i,site_date_st-20-j:site_date_st-1-j));
end


















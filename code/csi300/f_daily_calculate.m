% ÇåËãº¯Êý


function [money_total_hold,cha_value]=f_daily_calculate(target_calculate_structure,z_ST,site_date_ini,daynum)

    money_total_hold=0;
    cha_value=0;
             for money_i=1:length(target_calculate_structure(:,1))
                 if target_calculate_structure(money_i,7)>0
                     if ~isnan(z_ST(money_i+1,site_date_ini+daynum))
                          money_total_hold = money_total_hold + target_calculate_structure(money_i,7)* z_ST(money_i+1,site_date_ini+daynum)*100;
                     elseif isnan(z_ST(money_i+1,site_date_ini+daynum))
                         z_st_nansite= find(~isnan(z_ST(money_i+1,2:site_date_ini+daynum)));
                         money_total_hold = money_total_hold + target_calculate_structure(money_i,7)* z_ST(money_i+1,z_st_nansite(end)+1)*100;
                     end
                                  
                    if ~isnan( z_ST(money_i+1,site_date_ini+daynum))&&~isnan( z_ST(money_i+1,site_date_ini+daynum-1))
                        cha_value=cha_value+( z_ST(money_i+1,site_date_ini+daynum)- z_ST(money_i+1,site_date_ini+daynum-1))*target_calculate_structure(money_i,7)*100;
                    end
                 end
             end    

end
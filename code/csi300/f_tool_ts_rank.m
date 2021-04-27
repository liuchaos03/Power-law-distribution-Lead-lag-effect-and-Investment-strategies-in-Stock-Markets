function [return_value]=f_tool_ts_rank(sum_low,low_a,direction)
%'descend','ascend'
all_=length(sum_low(1,:));

for i=1:length(low_a)
    temp=[sum_low(i,:),low_a(i)];
    sort_temp=sort(temp(find(~isnan(temp))),direction);
    if isempty(sort_temp)
        return_value(i)=nan;
    else
        site=find(sort_temp==low_a(i));
        if isempty(site)
            return_value(i)=nan;
        else
            return_value(i)=site(1);
        end
    end
end
% 1-f_rank(return_value)
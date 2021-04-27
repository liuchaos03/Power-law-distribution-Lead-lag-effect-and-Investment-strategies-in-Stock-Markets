function [return_value]=f_tool_scale(s)

l=abs(s);
ab_s=l/sum(l);
sig=sign(s);
for i=1:length(s)   
    return_value(i)=sig(i)*ab_s(i)
end


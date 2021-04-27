function [return_value]=f_rank(s)

        s(find(isnan(s)))=-1;
        return_value=zeros(1,length(s));
        [B,l] = sort(s);
        A=find(B~=-inf);
        b = 1:length(A);
        return_value(l(A(1):end)) = b;    %alpha001Òò×ÓÖµ
        return_value = return_value/max(b);
        
%         for i=1:length(s)-1
%             if s(i)==s(i+1)
%                 return_value(i+1)=return_value(i);
%             end
%         end
%             
        
        
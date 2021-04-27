function alpha = f_Alpha001(z_ST,z_19kc_rate,current_date,len,len1)



site_date_st=find(z_ST(1,:)==current_date);
site_date_rate=find(z_19kc_rate(1,:)==current_date);


SITE=find(~isnan(z_ST(:,site_date_st)));
targetNum=length(find(~isnan(z_ST(:,site_date_st))))-1;
s = nan(1,length(z_ST(:,1))-1);      %每只股票最大值的索引（权重）
alpha = nan(1,length(z_ST(:,1)));
Klen=len+len1;
for i=2:targetNum+1
      x1 = nan(1,len1); %收盘价或前20天的回报率的标准差
      if (1==isnan(z_ST(SITE(i),site_date_st)))
          continue;
      else
          returns = z_19kc_rate(SITE(i),site_date_rate-25+1:site_date_rate);
          for j=1:len1
                    if(returns(end-j)<0)
                        x1(j) = std(returns(end-j-len+1:end-j));  %前20天的回报率的标准差
                    else
                        x1(j) = z_ST(SITE(i),site_date_st); %收盘价
                    end
          end
           x2 = sign(x1).*(abs(x1).^2);
%                 disp(['打印输出第',num2str(i),'只证券的5天的收盘价或标准差：'])  %调试专用
%                 x2
                %step4:找出x2的最大值，并返回索引：
                p = find(max(x2)==x2);
                SITE(i)
                if isempty(p)
                    continue;
                else
                    s(SITE(i)) = p(end);
                end
%                 disp(['打印输出第',num2str(i),'只证券的5天的最大值索引序号：'])  %调试专用
%                 s
      end
end
if (sum(isnan(s(SITE))) > targetNum/2) %过半数nan
%         disp(['打印输出第',num2str(i),'只证券的5天的最大值索引序号：'])  %调试专用
%         s
        return;
else
        p =find(isnan(s)==1);
        s(p) = -inf;%nan赋值负无穷
        %step5:排序并返回其对应排名的boolean值：
        [B,l] = sort(s);
        A=find(B~=-inf);
        find(B==-inf)
        b = 1:length(A);
        alpha=nan(1,length(z_ST(:,1))); 
        alpha(l(A(1):end)) = b;    %alpha001因子值
        alpha = alpha/max(b);
        alpha = alpha - 0.5;
%         disp(['打印输出第',num2str(i),'只证券的alpha001因子值：'])  %调试专用
%         alpha
end
end

          
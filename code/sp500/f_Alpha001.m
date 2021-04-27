function alpha = f_Alpha001(z_ST,z_19kc_rate,current_date,len,len1)



site_date_st=find(z_ST(1,:)==current_date);
site_date_rate=find(z_19kc_rate(1,:)==current_date);


SITE=find(~isnan(z_ST(:,site_date_st)));
targetNum=length(find(~isnan(z_ST(:,site_date_st))))-1;
s = nan(1,length(z_ST(:,1))-1);      %ÿֻ��Ʊ���ֵ��������Ȩ�أ�
alpha = nan(1,length(z_ST(:,1)));
Klen=len+len1;
for i=2:targetNum+1
      x1 = nan(1,len1); %���̼ۻ�ǰ20��Ļر��ʵı�׼��
      if (1==isnan(z_ST(SITE(i),site_date_st)))
          continue;
      else
          returns = z_19kc_rate(SITE(i),site_date_rate-25+1:site_date_rate);
          for j=1:len1
                    if(returns(end-j)<0)
                        x1(j) = std(returns(end-j-len+1:end-j));  %ǰ20��Ļر��ʵı�׼��
                    else
                        x1(j) = z_ST(SITE(i),site_date_st); %���̼�
                    end
          end
           x2 = sign(x1).*(abs(x1).^2);
%                 disp(['��ӡ�����',num2str(i),'ֻ֤ȯ��5������̼ۻ��׼�'])  %����ר��
%                 x2
                %step4:�ҳ�x2�����ֵ��������������
                p = find(max(x2)==x2);
                SITE(i)
                if isempty(p)
                    continue;
                else
                    s(SITE(i)) = p(end);
                end
%                 disp(['��ӡ�����',num2str(i),'ֻ֤ȯ��5������ֵ������ţ�'])  %����ר��
%                 s
      end
end
if (sum(isnan(s(SITE))) > targetNum/2) %������nan
%         disp(['��ӡ�����',num2str(i),'ֻ֤ȯ��5������ֵ������ţ�'])  %����ר��
%         s
        return;
else
        p =find(isnan(s)==1);
        s(p) = -inf;%nan��ֵ������
        %step5:���򲢷������Ӧ������booleanֵ��
        [B,l] = sort(s);
        A=find(B~=-inf);
        find(B==-inf)
        b = 1:length(A);
        alpha=nan(1,length(z_ST(:,1))); 
        alpha(l(A(1):end)) = b;    %alpha001����ֵ
        alpha = alpha/max(b);
        alpha = alpha - 0.5;
%         disp(['��ӡ�����',num2str(i),'ֻ֤ȯ��alpha001����ֵ��'])  %����ר��
%         alpha
end
end

          
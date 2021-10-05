% clear all; final_shareNum=[];plus=[];plus2=[]
 plus=(final_shareNum-[10000000])*1/2


% final_shareNum=final_shareNum
fi=length(final_shareNum(:,1))/2

 initTime = 20100101;
 site=find(final_shareNum(1,:)>=initTime)
for ss= 1:fi
 
 shareNum=final_shareNum(2,1);
 final_shareNum_real=[];
 final_shareNum_real(1,:)=final_shareNum(2*ss-1,site)
 final_shareNum_real(2,:)=final_shareNum(2*ss,site)-plus(2*ss,site)
 
 final_shareNum_real(3,1)=0
for i =2:length(final_shareNum_real(1,:)) 
    final_shareNum_real(3,i)=(final_shareNum_real(2,i)-final_shareNum_real(2,i-1))/final_shareNum_real(2,i-1);
    final_shareNum_real(4,i)=final_shareNum_real(2,i)-final_shareNum_real(2,1);
end

final_shareNum_real(4,:)=final_shareNum_real(4,:)/final_shareNum_real(2,1);
 
%% （1）日平均收益：每月总收益/当月天数；所有月做平均
final_shareNum_real_monthly=floor(final_shareNum_real(1,:)/10000);
unique_month=unique(floor(final_shareNum_real(1,:)/10000));
Return=zeros(length(unique_month),1);
for j=1:length(unique_month)
  
    sitt_month=[];
    sitt_month=find(final_shareNum_real_monthly==unique_month(j))
    % Return是年化
    Return(j)=((final_shareNum_real(4,sitt_month(end))-final_shareNum_real(4,sitt_month(1)))/length(sitt_month))*365;
end
    find(Return>1)
    R_m_=sum(Return)/length(Return);
    R_y_=(final_shareNum_real(4,end)-final_shareNum_real(4,1))

performance(1,ss*2)=(final_shareNum_real(4,end)-final_shareNum_real(4,1))/length(final_shareNum_real(1,:))
%% std
 performance(2,ss*2)=std(final_shareNum_real(3,:));
 performance(3,ss*2)=min(final_shareNum_real(3,:));
 performance(4,ss*2)=quantile(final_shareNum_real(3,find(final_shareNum_real(3,:)~=0)),0.25);
 performance(5,ss*2)=quantile(final_shareNum_real(3,find(final_shareNum_real(3,:)~=0)),0.5);
 performance(6,ss*2)=quantile(final_shareNum_real(3,find(final_shareNum_real(3,:)~=0)),0.75);
 performance(7,ss*2)=max(final_shareNum_real(3,:));
 performance(8,ss*2)=skewness(final_shareNum_real(3,:))
 performance(9,ss*2)=kurtosis(final_shareNum_real(3,:)) 
 performance(10,ss*2)=((R_y_/length(final_shareNum_real(1,:)))*365)/std(Return)
%  sharpe=((R_y_/length(final_shareNum_real(1,:)))*365)/std(Return)
 performance(11,ss*2)=maxdrawdown(final_shareNum_real(2,:))
%  performance(12,1)= length(find(final_shareNum_real(3,:)>=0))/length(final_shareNum_real(3,:))
end
 
 performance=performance'
 
function [pair_sum,point_pair]=f_calculateF_sy(inputs,fai,derta)
z_stock=unique(inputs(:,1));   
z_date=unique(inputs(:,2));    

z_SST=zeros(length(z_stock)+1,length(z_date)+1)*nan;
z_SST(2:end,1)=z_stock;
z_SST(1,2:end)=z_date;

for i=1:length(inputs)
    z_S=find(z_SST(:,1)==inputs(i,1));
    z_T=find(z_SST(1,:)==inputs(i,2));
    z_SST(z_S,z_T)=inputs(i,3);
end

z_19kc_rate=zeros(length(z_stock)+1,length(z_date));
z_19kc_rate(2:end,1)=z_stock;
z_19kc_rate(1,2:end)=z_date(2:end);


for j=2:length(z_stock)+1
    for i=2:length(z_date)
      ss=(z_SST(j,i+1)-z_SST(j,i))/z_SST(j,i);
      %if isnan(ss)
      %     C_rate(j,i)=0;
      %else 
           z_19kc_rate(j,i)=ss;
      %end
      
    end
end
%计算边数

[m,n]=size(z_SST);
z_follow_matrix=zeros(length(z_stock)+1,length(z_stock)+1);
z_follow_matrix(2:end,1)=z_stock;
z_follow_matrix(1,2:end)=z_stock;
z_follow_matrix2=zeros(length(z_stock)+1,length(z_stock)+1);
z_follow_matrix2(2:end,1)=z_stock;
z_follow_matrix2(1,2:end)=z_stock;
reco_p=zeros(length(z_date)-2,1);
reco_p2=zeros(length(z_date)-2,1);
p_per_day=zeros(length(z_date)-2,1);
p_per_day2=zeros(length(z_date)-2,1);

point_sta=zeros(n-3,2);
for i=2:n-2
     t=1;
     z_follow_matrix_daily=zeros(length(z_stock)+1,length(z_stock)+1);
     for j=2:m
         for l=2:m
             if ~isnan(z_19kc_rate(j,i+1)) && ~isnan(z_19kc_rate(l,i)) && z_19kc_rate(j,i+1)~=0%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 if  z_19kc_rate(j,i+1)*z_19kc_rate(l,i)>0
%                   if  (z_19kc_rate(j,i+1)<=z_19kc_rate(l,i)*(1+fai)&&z_19kc_rate(j,i+1)>=z_19kc_rate(l,i)*(1-fai))||(z_19kc_rate(j,i+1)<=z_19kc_rate(l,i)*(1-fai)&&z_19kc_rate(j,i+1)>=z_19kc_rate(l,i)*(1+fai))
% %                    why=why+1;
%                      reco_p(i-1)=reco_p(i-1)+1;
%                      z_follow_matrix(l,j)=z_follow_matrix(l,j)+1;
%                      z_follow_matrix_daily(l,j)= z_follow_matrix_daily(l,j)+1;
%                      
%                  end
                    if z_19kc_rate(l,i)>0 && z_19kc_rate(j,i+1)<=z_19kc_rate(l,i)*(1+fai) && z_19kc_rate(j,i+1)>=z_19kc_rate(l,i)*(1-fai)
                            %&&z_19kc_rate(j,i+1)>=z_19kc_rate(l,i)*(1-fai))||(z_19kc_rate(j,i+1)<=z_19kc_rate(l,i)*(1-fai)&&z_19kc_rate(j,i+1)>=z_19kc_rate(l,i)*(1+fai))
        %                      why=why+1;
                                 reco_p(i-1)=reco_p(i-1)+1;
                                 z_follow_matrix(l,j)=z_follow_matrix(l,j)+1;
                                 z_follow_matrix_daily(l,j)= z_follow_matrix_daily(l,j)+1;
                           
                    elseif z_19kc_rate(l,i)<0 && z_19kc_rate(j,i+1)<=-z_19kc_rate(l,i)*(1+fai) && z_19kc_rate(j,i+1)>=-z_19kc_rate(l,i)*(1-fai)
                                 reco_p2(i-1)=reco_p2(i-1)+1;
                                 z_follow_matrix2(l,j)=z_follow_matrix2(l,j)+1;
                                 z_follow_matrix_daily(l,j)= z_follow_matrix_daily(l,j)+1;  
                    end
             end
         end
     end
     point_sta(i-1,1)=sum(sum(z_follow_matrix_daily));
     point_sta(i-1,2)=length(unique([find(sum(z_follow_matrix_daily)~=0),find(sum(z_follow_matrix_daily')~=0)]));
     p_per_day(i-1)=reco_p(i-1)/((m-1)*(m-2));
     p_per_day2(i-1)=reco_p2(i-1)/((m-1)*(m-2));
 end

siz=[m-1,m-1];
z_simu_accumulate=[0,0,0;1,0,0;2,0,0;3,0,0;4,0,0;5,0,0];
z_simu=zeros(siz);
z_simu2=zeros(siz);

%% 循环仿真
 for ppqq=1:500%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%仿真次数调整
for i=1:length(z_date)-2
    a=rand(siz);
    k=find(p_per_day(i)>a);
    k2=find(p_per_day2(i)>a);
    b=zeros(siz);
    b2=zeros(siz);
    b(k)=1;
    b2(k2)=1;
    z_simu=z_simu+b;
    z_simu2=z_simu2+b2;
end
    z_statis_simu=tabulate(z_simu(:));
    z_statis_simu2=tabulate(z_simu2(:));
 end
z_statis_simu2(:,2)=z_statis_simu2(:,2)/sum(z_statis_simu2(:,2));
  z_statis_simu(:,2)=z_statis_simu(:,2)/sum(z_statis_simu(:,2));
   curve1= z_statis_simu(:,1);
   curve2= z_statis_simu(:,2);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%绘图拟合
   x=-0.6:0.01:20;
        a1 =     0.1829  ;
        b1 =       4.806 ;
        c1 =     3.084  ;
   y =  a1*exp(-((x-b1)/c1).^2);
%  
%  figure(1);
%  bar(z_statis_simu(:,1),z_statis_simu(:,2))
   hold on;
   plot(x,y)

%%%%计算大于百分之90，小概率事件的跟随次数
z_ff=zeros(m-1,m-1);
z_ff=z_follow_matrix(2:end,2:end);
z_statis=tabulate(z_ff(:));
 z_statis(:,2)=z_statis(:,2)/sum(z_statis(:,2));
%  courve1=z_statis(:,1);
% courve2=z_statis(:,2)

% figure(10);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%绘图部分，拟合
%  x=-0.6:0.01:12
%   a1 =      0.6077  ;
%        b1 =     -0.3835  ;
%        c1 =       1.715;
%  y = a1*exp(-((x-b1)/c1).^2);
%  
% %  %bar(z_statis(:,1),z_statis(:,2))
%  hold on;
%  plot(x,y)


S=sum(z_statis);
S_simu=sum(z_statis_simu);
S_simu2=sum(z_statis_simu2);
temp=0;
h=0;
while temp<S(3)*(1-derta)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&******************************************0.95/0.9
    h=h+1;
    temp=temp+z_statis(h,3);
end
%%%%%%

temp_simu=0;
h_simu=0;
temp_simu2=0;
h_simu2=0;
while temp_simu<=S_simu(3)*(1-derta)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&******************************************0.95/0.9
    h_simu=h_simu+1;
    temp_simu=temp_simu+z_statis_simu(h_simu,3);
end
while temp_simu2<=S_simu2(3)*(1-derta)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&******************************************0.95/0.9
    h_simu2=h_simu2+1;
    temp_simu2=temp_simu2+z_statis_simu2(h_simu2,3);
end
%%拟合开始
%把矩阵的统计散点写入一维数组
%真实拟合
z_x=z_statis(:,1);
z_y=z_statis(:,2);
%仿真拟合
z_x_s=z_statis_simu(:,1);
z_y_s=z_statis_simu(:,2);   


%查找股票对位置
  site=z_follow_matrix(2:m,2:m)>=h_simu;
  [p,q]=find(site==1);
%  pp=find(p==q)    %准备自跟随位置
%  sum(sum(site))
 %=z_follow_matrix(i2,j2);
 point_pair=zeros(length(p),3);
 point_pair(:,1)=z_stock(p);
 point_pair(:,2)=z_stock(q);
[p,q]= find (z_follow_matrix(2:m,2:m)>=h_simu);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p=p+1;q=q+1;
pp=find(p==q);    %准备自跟随位置
for i=1:length(p)
    point_pair(i,1)=z_follow_matrix(p(i),1);
    point_pair(i,2)=z_follow_matrix(1,q(i));
    point_pair(i,3)=z_follow_matrix(p(i),q(i));

end
%% 另一组
 site2=z_follow_matrix2(2:m,2:m)>=h_simu2;
  [p2,q2]=find(site2==1);

 point_pair2=zeros(length(p2),3);
 point_pair2(:,1)=z_stock(p2);
 point_pair2(:,2)=z_stock(q2);
[p2,q2]= find (z_follow_matrix2(2:m,2:m)>=h_simu2);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p2=p2+1;q2=q2+1;
pp2=find(p2==q2);    %准备自跟随位置
for i=1:length(p2)
    point_pair2(i,1)=z_follow_matrix2(p2(i),1);
    point_pair2(i,2)=z_follow_matrix2(1,q2(i));
    point_pair2(i,3)=-z_follow_matrix2(p2(i),q2(i));

end
%% 查有无重复点对，，要去掉
siit1=[];
siit2=[];
for sa=1:length(point_pair(:,1))
    samee=find(point_pair2(:,1)==point_pair(sa,1));
    sa2=find(point_pair2(samee,2)==point_pair(sa,2));
    if ~isempty(sa2)
        siit2=[siit2;sa2];
        siit1=[siit1;sa];
    end
end
if ~isempty(siit1)
    point_pair(siit1,:)=[];
    point_pair2(siit2,:)=[];
end       
point_pair=[point_pair;point_pair2]
%% 查找自跟随节点
% point_self=zeros(length(pp),2);
% point_self(:,1)=z_stock(p(pp));
% point_self(:);
pair_sum=length(point_pair);

point_total=[point_pair(:,1);point_pair(:,2)];
%point_pair_sta=tabulate(point_pair(:));
point_unique=unique(point_total);

m_unique=unique(point_pair(:,1:2));
length(m_unique)

%%找到循环跟随点对（a跟随b h次且b也跟随a h次）
% point_cycle_no=[];
% for i=2:length(z_follow_matrix)
%     for j=2:length(z_follow_matrix)
%         if i~=j
%             if z_follow_matrix(i,j)>h&&z_follow_matrix(i,j)==z_follow_matrix(j,i)
%                 rr=[i,j]
%                 point_cycle_no=[point_cycle_no;rr];
%             end
%         end
%     end
% end
% point_cycle=zeros(length(point_cycle_no(:,1)):2);
% point_cycle(:,1)=z_follow_matrix(point_cycle_no(:,1),1);
% point_cycle(:,2)=z_follow_matrix(1,point_cycle_no(:,2));
 end

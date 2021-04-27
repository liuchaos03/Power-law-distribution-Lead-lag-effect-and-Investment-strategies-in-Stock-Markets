function [no_stock,u_stock,inputs_re]=f_recode(inputs)
% if class(inputs.id)
if isa(inputs(1).id,'double')==1
    all_stock_1= cat(1,inputs.id);
else
    all_stock_1= cellstr(cat(1,inputs.id));
end
all_date_1 = cat(1,inputs.date);
all_value_1= cat(1,inputs.value);
all_volume_1= cat(1,inputs.volume);
% all_high_1=cat(1,inputs.high);
% all_low_1=cat(1,inputs.low);

all_stock=[all_stock_1];

u_stock=unique(all_stock);
no_stock=zeros(length (u_stock),1);
for i=1:length(u_stock)
    no_stock(i)=i;
end
%% inputs ÷ÿ±‡¬Î
inputs_re=zeros(length(inputs),6);
inputs_re(:,2)=all_date_1;
inputs_re(:,3)=all_value_1;
inputs_re(:,4)=all_volume_1;
%  inputs_re(:,5)=all_high_1;
%  inputs_re(:,6)=all_low_1;
 if isa(inputs(1).id,'double')==1
     for i=1:length(u_stock)
        inputs_re(find(u_stock(i)==all_stock_1),1)=no_stock(i);
     end
 else
     for i=1:length(u_stock)
        inputs_re(find(strcmp(u_stock(i),all_stock_1)==1),1)=no_stock(i);
     end
 end

    
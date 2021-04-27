function [final]=f_data_inputs(inputs,begintime,endtime)
global total;
date_all = cat(1,inputs.date);
date_all_unique=unique(date_all(:));
% all_date = cat(1,inputs.date)

% date_all_=unique(all_date(:))
date_bigger_no=find(date_all_unique<endtime) ;                                    %获取有效日期
date_test_no=find(date_all_unique(date_bigger_no)>=begintime);                        %获取有效日期
outputs=date_all_unique(date_test_no)     ;                                     %获取有效日期

final=inputs;
final(find(ismember(date_all,outputs)==0))=[];

function [final]=f_data_inputs(inputs,begintime,endtime)
global total;
date_all = cat(1,inputs.date);
date_all_unique=unique(date_all(:));
% all_date = cat(1,inputs.date)

% date_all_=unique(all_date(:))
date_bigger_no=find(date_all_unique<endtime) ;                                    %��ȡ��Ч����
date_test_no=find(date_all_unique(date_bigger_no)>=begintime);                        %��ȡ��Ч����
outputs=date_all_unique(date_test_no)     ;                                     %��ȡ��Ч����

final=inputs;
final(find(ismember(date_all,outputs)==0))=[];

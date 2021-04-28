
%------Calculating the following relation
%--------load data
[~,~,csi_09_20]= xlsread("matrix_csi_09-20.csv");
[~,~,sp_09_20]= xlsread("matrix_sp500_09-20.csv");
datelist_csi=(cell2mat(csi_09_20(1,2:end)));
datelist_sp=(cell2mat(sp_09_20(1,2:end)));
% startdate=20100000;
% enddate=20200000;
% delta=0.20;
tmp=((datelist_csi<=enddate) .* (datelist_csi>=startdate))==1;
datecsi_10_19=unique(datelist_csi(tmp));
Gprice_csi=cell2mat(csi_09_20(2:end,2:end));                %Price matrix, behavior stock, listed as date
Gprice_csi=Gprice_csi(:,tmp);

tmp=((datelist_sp<=enddate) .* (datelist_sp>=startdate))==1;
datesp_10_19=unique(datelist_sp(tmp));
Gprice_sp=cell2mat(sp_09_20(2:end,2:end));
Gprice_sp=Gprice_sp(:,tmp);

stocklist_csi=unique(cell2mat(csi_09_20(2:end,1)));
stocklist_sp=unique(cellstr(sp_09_20(2:end,1)));

%%
%---Calculate the growth rate matrix
Grate_csi=zeros(size(Gprice_csi,1),size(Gprice_csi,2));
for i=1:size(Gprice_csi,1)
    for j=2:size(Gprice_csi,2)
        if Gprice_csi(i,j)==0 || Gprice_csi(i,j)==Gprice_csi(i,j-1)
            continue;   %Zero in the gprice matrix means there is no data
        end
        Grate_csi(i,j)=(Gprice_csi(i,j)-Gprice_csi(i,j-1))/Gprice_csi(i,j-1);
    end
end

Grate_sp=zeros(size(Gprice_sp,1),size(Gprice_sp,2));
for i=1:size(Gprice_sp,1)
    for j=2:size(Gprice_sp,2)
        if Gprice_sp(i,j)==0 || Gprice_sp(i,j)==Gprice_sp(i,j-1)
            continue;   % Zero in the gprice matrix means there is no data
        end
        Grate_sp(i,j)=(Gprice_sp(i,j)-Gprice_sp(i,j-1))/Gprice_sp(i,j-1);
    end
end

%%
%------Compute follow---------
G_ledlag_csi=zeros(size(Grate_csi,1),size(Grate_csi,1));    %Rows and columns are stocks
G_ledlag_sp=zeros(size(Grate_sp,1),size(Grate_sp,1));

dayEdges_csi=zeros(size(Grate_csi,2),1);
dayEdges_sp=zeros(size(Grate_sp,2),1);

for j=2:size(Grate_csi,2)  %2418
    for i=1:size(Grate_csi,1)
        if Grate_csi(i,j)==0
            continue;
        end
        tmp=Grate_csi(:,j-1);
        if Grate_csi(i,j)>0
           tmk=((tmp.*(1-delta))<=Grate_csi(i,j)).*(Grate_csi(i,j)<=(tmp.*(1+delta)));
        else
           tmk=((tmp.*(1+delta))<=Grate_csi(i,j)).*(Grate_csi(i,j)<=(tmp.*(1-delta))); 
        end
        G_ledlag_csi(i,tmk==1)=G_ledlag_csi(i,tmk==1)+1;
        dayEdges_csi(j)=dayEdges_csi(j)+sum(tmk==1);
    end
end


for j=2:size(Grate_sp,2)  %2601
    for i=1:size(Grate_sp,1)
        if Grate_sp(i,j)==0
            continue;
        end
        tmp=Grate_sp(:,j-1);
        if Grate_sp(i,j)>0
           tmk=((tmp.*(1-delta))<=Grate_sp(i,j)).*(Grate_sp(i,j)<=(tmp.*(1+delta)));
        else
           tmk=((tmp.*(1+delta))<=Grate_sp(i,j)).*(Grate_sp(i,j)<=(tmp.*(1-delta))); 
        end
        G_ledlag_sp(i,tmk==1)=G_ledlag_sp(i,tmk==1)+1;
        dayEdges_sp(j)=dayEdges_sp(j)+sum(tmk==1);
    end
end

clearvars csi_09_20 sp_09_20

csi_loglog=tabulate(G_ledlag_csi(:));
sp_loglog=tabulate(G_ledlag_sp(:));

x_csi=csi_loglog(:,1);
y_csi=csi_loglog(:,2)./sum(csi_loglog(:,2));
x_sp=sp_loglog(:,1);
y_sp=sp_loglog(:,2)./sum(sp_loglog(:,2));

figure(1)
loglog(x_csi,y_csi,'.');
title('CSI');

figure(2)
loglog(x_sp,y_sp,'.');
title('SP');

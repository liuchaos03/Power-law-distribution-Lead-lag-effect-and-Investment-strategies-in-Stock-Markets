
%------Computational random network---------------------------
out500=zeros();
for si=1:500
    %%
    %- Configuration model 
    G_ledlag_csi=G;  % G is a matrix whose size is the number of nodes 
    G_date_csi=G_Simu;   % G_ Simu is a cell vector, and a matrix is stored in each cell
    G_ledlag_conf_csi=zeros(length(G_ledlag_csi));
    for k=1:length(G_date_csi)  %2418
        G=G_date_csi{1,k};
        Gout=sum(G,1);
        Gint=sum(G,2);
        tmp=zeros(length(G_ledlag_csi));
       while sum(Gout)~=0
           L=find(Gout~=0);
           R=find(Gint~=0);
           L=L(randperm(length(L),1));
           R=R(randperm(length(R),1));
           if tmp(L,R)==1
               continue
           else
               tmp(L,R)=1;
           end
           Gout(L)=Gout(L)-1;
           Gint(L)=Gint(L)-1;
       end
        G_ledlag_conf_csi=G_ledlag_conf_csi+tmp;
    end

    csi_loglog_conf=tabulate(G_ledlag_conf_csi(:));
    for ki =1:size(csi_loglog_conf,1)
        if size(csi_loglog_conf,1)>size(out500,1)
             out500(ki,1)=csi_loglog_conf(ki,2);
        else
            out500(ki,1)=out500(ki,1)+csi_loglog_conf(ki,2);
        end
    end
    disp(si)
end

out500=out500./sum(out500);

bar([0:1:(length(out500)-1)],out500)

% x_csi=csi_loglog_conf(:,1);
% y_csi=csi_loglog_conf(:,2)./sum(csi_loglog_conf(:,2));
% loglog(x_csi,y_csi,'.');
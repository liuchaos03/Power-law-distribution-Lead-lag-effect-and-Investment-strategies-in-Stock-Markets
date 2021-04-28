deltas=[0.10,0.15,0.20,0.25,0.30];  % Parameter setting is related to the following probability
Output3=zeros(5,6,2);   %Fitting results of power law distribution
startdate=20100000;   %Date range of stocks
enddate=20200000;

for de=1:length(deltas)
    delta=deltas(de);
    run('csisp_ledlag.m')
    save(['csi_sp_10_19_',num2str(delta),'.mat'])
    [~,Output3(de,:,1)]=fit_test(x_csi(2:end),smooth(y_csi(2:end)));
    [~,Output3(de,:,2)]=fit_test(x_sp(2:end),smooth(y_sp(2:end)));
    clearvars -except deltas de startdate Output3 enddate
end
disp('===done!===')
CSI=Output3(:,:,1);
SP=Output3(:,:,2);



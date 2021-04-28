function [fitness_P,Output] = fit_test(x,y)
numkey=floor(length(x)/2);
if (length(x)-numkey)>35
    numkey=length(x)-35;  %Keep 50 data, or keep 50% of the data for fitting
end
fitness_P=zeros(numkey,6);
for i =1:numkey
    x0=x(i:end);
    y0=y(i:end);
   % [f,g]=fit(x0,y0,'x^-b','StartPoint',[0.1]);
 
    [f, g] = fit_find_opts(x0, y0,3,-30);
%    [f, g] = createFit_law(x0, y0,'0');
    y1=f.a*x0.^f.b;
    [~,p]=kstest2(y0,y1);
    
    fitness_P(i,1:4)=[f.a,f.b,i,g.adjrsquare];
    fitness_P(i,5:6)=[length(x),p];
    
   disp(['==========',num2str(round(i/(length(x)-10),3)*100),'%========']);
end
disp(['Max P-value:',num2str(max(fitness_P(:,6)))]);
i=find(max(fitness_P(:,6))==fitness_P(:,6));
Output=fitness_P(i(1),:);
end


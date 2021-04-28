function [outputArg1,outputArg2] = fit_find_opts(x0,y0,a,b)

[xData, yData] = prepareCurveData( x0, y0 );

% Set up fittype and options.
ft = fittype( 'power1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'off';

tmp=linspace(a,b,25)';

for i =1 : length(tmp)
    opts.StartPoint = [5.38605111422321e+40, tmp(i)];
    % Fit model to data.
    [~, gof] = fit( xData, yData, ft, opts );
    tmp(i,2)=gof.adjrsquare;
%     disp(tmp(i))
end
    tmp = sortrows(tmp,2,'descend');
    if (abs(tmp(1,1)-tmp(2,1))<0.005) || (min(tmp(1:2,1))==a && max(tmp(1:2,1))==b)
        opts.StartPoint = [5.38605111422321e+40, tmp(1)];
        [outputArg1, outputArg2] = fit( xData, yData, ft, opts );
        return 
    else
        [outputArg1, outputArg2] =fit_find_opts(x0,y0,min(tmp(1:2,1)),max(tmp(1:2,1)));
    end

end


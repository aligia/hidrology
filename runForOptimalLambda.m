function [k_AM_est, y_AM_rec, y_AM_SNR, c_est, y_AM_coeff,  ...
    k_xcorr_est, y_xcorr_rec, y_xcorr_SNR, y_CorrCoeff_SNR,bestLambda ] =...
    runForOptimalLambda(x,k,y,constraints,algp,lambdas,params)
% the runForOptimalLambda tests the given inputs signals for all the
% lambdas in the lambda range and chooses the best lambda according to the
% correlation coefficient lambda choice strategy.

colorMapJet = jet(length(lambdas));

yCorrCoeffSnrs = zeros(size(lambdas));

k_AM_est_mat = zeros(length(k),length(lambdas));

for i = 1: length(lambdas)
    
    [k_AM_est, y_AM_rec, y_AM_SNR, c_est, y_AM_coeff,  ...
        k_xcorr_est, y_xcorr_rec, y_xcorr_SNR] =...
        runOneHydroTest(x,k,y,constraints,algp,lambdas(i),params);
     
    k_AM_est_mat(:,i) = k_AM_est;
    yCorrCoeffSnrs(i)= y_AM_coeff;
    
end

h = figure('units','normalized','outerposition',[0 0 1 1]);
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

[bestCorrCoeffValue, bestCorrCoeffIndex] = max(yCorrCoeffSnrs);

hline(1) = plot(k,'k','LineWidth',2); hold on
isVisible(1) = 1;
plotName{1} = 'true';


for i = 1: length(lambdas)
    txt = ['lambda = ' num2str(lambdas(i),'%10.1e')];
    if(i == bestCorrCoeffIndex)
        hline(i+1) = plot(k_AM_est_mat(:, i)+i*2, 'LineWidth',2, 'Color', colorMapJet(i,:));
        plotName{i+1} = 'best';
        isVisible(i+1) = 1;
    else
        hline(i+1) = plot(k_AM_est_mat(:, i)+i*2, 'Color', colorMapJet(i,:));
        plotName{i+1} = 'noshow';
        isVisible(i+1) = 0;
    end
    text(1,k_AM_est_mat(1, i)+i*2.05,txt)
end

finalHLine = [];
finalPlotName = cell(length(isVisible),1);

for i = 1:length(isVisible)
    if(isVisible(i))
        finalHLine = [finalHLine, hline(i)];
        finalPlotName{i} =  plotName{i};
    end
end

finalPlotName = finalPlotName(~cellfun('isempty',finalPlotName));

legend(finalHLine, finalPlotName);

saveas(h,'plots.eps');

[maxYCorrCoeff, maxYCorrCoeffIndex] = max(yCorrCoeffSnrs);

[k_AM_est, y_AM_rec, y_AM_SNR, c_est, y_AM_coeff,  ...
    k_xcorr_est, y_xcorr_rec, y_xcorr_SNR] =...
    runOneHydroTest(x,k,y,constraints,algp,lambdas(maxYCorrCoeffIndex),params);

y_CorrCoeff_SNR = SNR(y-c_est, y_AM_rec-c_est);

bestLambda = lambdas(maxYCorrCoeffIndex);
end

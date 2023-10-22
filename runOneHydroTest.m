function [k_AM_est, y_AM_rec, y_AM_SNR, c_est, y_AM_coeff,  ...
          k_xcorr_est, y_xcorr_rec, y_xcorr_SNR] =...
    runOneHydroTest(x,k,y,constraints,algp,lambda,params)                           
% the runOneHydroTest takes the inputs rainfall (x) and basin measurements
% (y) and runs the AM algorithm once for the given lambda. It also returns
% de results for the cross-correlation method.

if(params.k_length > params.x_length)
   error('The length of the estimated WRT (k) needs to be smaller than that of the input rainfal (x) and basin measurements (y).') 
end

% ===================================================================
% Verify Signals
if(params.make_single_test_plot)
    
	f1 = figure('units','normalized','outerposition',[0 0 1 1]);
    set(f1,'Units','Inches');
    pos = get(f1,'Position');
    set(f1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

	subplot(3,1,1)
	plot(x);
	hold on;
	title(['x, lambda =  ' num2str(lambda,'%10.3e')], 'FontSize', params.font_size_large);
	xlabel('time [hours]', 'FontSize', params.font_size_large);
	ylabel('Rainfall [mm]', 'FontSize', params.font_size_large);

    subplot(3,1,2)
	plot(k);
	hold on;
	title(['k, k_{est}' num2str(lambda,'%10.3e')], 'FontSize', params.font_size_large);
	xlabel('time [hours]', 'FontSize', params.font_size_large);
	ylabel('WRT [1]', 'FontSize', params.font_size_large);
    
	subplot(3,1,3)
	plot(y,'LineWidth',2);
	hold on;
	xlabel('time [hours]', 'FontSize', params.font_size_large);
	ylabel('Basin [mm]', 'FontSize', params.font_size_large);
end
% ===================================================================
% Deconvolution Algorithm

[k_AM_est, y_AM_rec, c_est] = deconv_AM(x,y,lambda,constraints,algp,params);

y_AM_coeff = corr2(y-c_est, y_AM_rec-c_est);
y_AM_SNR = SNR(y-c_est, y_AM_rec-c_est);
   
% ===================================================================
% Cross Correlation Test

[k_xcorr_est, y_xcorr_rec, c_est_xcorr] = deconv_XCorr(x,y,params);

y_xcorr_SNR = SNR(y-c_est_xcorr, y_xcorr_rec-c_est_xcorr);

% ===================================================================
% % Verify Results
if(params.make_single_test_plot)
	subplot(3,1,2)
	plot(k_AM_est,'r','LineWidth',2);
	hold on;
	plot(k_xcorr_est,'g','LineWidth',2);
	title('k_{est}', 'FontSize', params.font_size_large)
	xlabel('time [hours]', 'FontSize', params.font_size_large);
	ylabel('WRT [1/t]', 'FontSize', params.font_size_large);
	legend('AM','XCORR','Location','northwest');
    
    % put correct xthicks for k
    k_xTick = get(gca,'XTickLabel');
    k_xTick_num = str2double(k_xTick);
    k_xTick_num = k_xTick_num - params.k_length/2;
    k_xTick_final_str = num2str(k_xTick_num);
	set(gca, 'xTickLabel', k_xTick_final_str);

	subplot(3,1,3)
	plot(y_AM_rec,'r','LineWidth',2);
	plot(y_xcorr_rec,'g','LineWidth',2);
	title(['y_{rec}SNR-AM = ' num2str(y_AM_SNR) ' dB --  y_{rec}SNR-XCORR = '...
        num2str(y_xcorr_SNR) ' dB'], 'FontSize', params.font_size_large)
	legend('true','AM','XCORR','Location','northwest');
	
    drawnow;
    
	if(params.save_single_test_plot)
		saveas(gcf,[params.results_folder num2str(params.x_length) '/'...
        num2str(params.test_case_index) '_lambda_' num2str(round(lambda)) '.pdf']);
    end
    
    close(f1);
end
    
end

% This Demo takes the chosen test index and returns the resulted k_ests and 
% y_recs from the Aternating Minimization Algorithm and the Cross-Correlation
% method. The .mat input files are for fixed length synthetic generated
% rainfall tests 
% Multiple parameters can be set:
% - length of estimated k (default is 1000)
% - length of inputs rainfall (x) and basin measurements (y)
% (for other rainfall lengths than the ones provided in the .mat files, 
% some tweaking of the code is in order)
% - lambda range
% - Alternating Minimization and Projected Newton's Method limits
% - this demo presents four cases of estimating k_est with the AM algorithm:
% 1) no constraints applied
% 2) just positivity applied
% 3) just causality applied
% 4) both positivity and causality applied
% and a test for finding the best lambda with the correlation coefficient 
% strategy presented in the related article


%% =================== initialization =====================
clear variables; close all; clc;
% test parameters
params.no_averages = 30;
params.inputSnr = 15; % 0, 1, 5, 10, 15, 20, 25, 30;
rangeLambdas = 10;
lambdas_min= -3;
lambdas_max = 10;
lambdas = logspace(lambdas_max,lambdas_min,rangeLambdas);

% algo parameters
algp.maxIt_Newton = 1000;
algp.max_step_size_Newton = 1e-12;
algp.max_err_rel_Newton = 1e-7;
algp.maxIt_AM = 300;
algp.max_err_rel_AM = 1e-7;

% signal parameters
params.x_length = 1000;
params.data_to_load = ['rain' num2str(params.x_length) '.mat'];
params.x_type ='fixed_test_index'; % diracs, fixed_test_index, rand_test_index
params.test_case_index = 7;
params.k_type = 'beta'; % beta, gaussian
params.b_seed = 'noFixedSeed'; %fixedSeed0, noFixedSeed
params.k_length = 1000;
params.k_delay = 200;
params.x_midlle = floor(params.x_length/2);
params.k_midlle = floor(params.k_length/2);
params.level_constant = 100;
params.conv_type = 'convNonCirc'; % convNonCirc, convCirc
params.step_size = 1;
params.xcorr_type = 'none';
params.test_type = 'synthetic';

% plot settings
params.results_folder = 'Plots\';
params.make_single_test_plot = 0;
params.save_single_test_plot = 0;
params.font_size_medium = 13;
params.font_size_large = 20;
params.lw = 2;

constraints.causalInterval = params.k_midlle;
constraints.D = [-1;2;-1];
constraints.order = 1;

dir_path = [params.results_folder, num2str(params.x_length),'\'];

if (~exist(dir_path,'dir'))
   mkdir(dir_path) 
end

%% Synthetic signal creation (inputs) with the real life constraints
constraints.positivity = 1;
constraints.causality = 1;

[x,k,y,y_true, b,params] = chooseSignals(params, constraints, params.inputSnr);

%% 1. test algorithm with no constraints applied
% constraints.positivity = 0;
% constraints.causality = 0;
% 
% 
% [k_AM_est, y_AM_rec, y_AM_SNR, c_est, y_AM_coeff,  ...
%     k_xcorr_est, y_xcorr_rec, y_xcorr_SNR, y_CorrCoeff_SNR,bestLambda ] =...
%     runForOptimalLambda(x,k,y,constraints,algp,lambdas,params);
% 
% k_AM_est_no_constr = k_AM_est;
% y_AM_rec_no_constr = y_AM_rec;
% k_AM_Snrs(1,1) = SNR(k, k_AM_est);

%% 2. test algorithm with only positivity constraint applied
% constraints.positivity = 1;
% constraints.causality = 0;
% 
% [k_AM_est, y_AM_rec, y_AM_SNR, c_est, y_AM_coeff,  ...
%     k_xcorr_est, y_xcorr_rec, y_xcorr_SNR, y_CorrCoeff_SNR,bestLambda ] =...
%     runForOptimalLambda(x,k,y,constraints,algp,lambdas,params);
% 
% k_AM_est_just_pos = k_AM_est;
% y_AM_rec_just_pos = y_AM_rec;
% k_AM_Snrs(1,2) = SNR(k, k_AM_est);

%% 3. test algorithm with only causality constraint applied
% constraints.positivity = 0;
% constraints.causality = 1;
% 
% [k_AM_est, y_AM_rec, y_AM_SNR, c_est, y_AM_coeff,  ...
%     k_xcorr_est, y_xcorr_rec, y_xcorr_SNR, y_CorrCoeff_SNR,bestLambda ] =...
%     runForOptimalLambda(x,k,y,constraints,algp,lambdas,params);
% 
% k_AM_est_just_causal = k_AM_est;
% y_AM_rec_just_causal = y_AM_rec;
% k_AM_Snrs(1,3) = SNR(k, k_AM_est);

%% 4. test algorithm with both positivity and causality constraints applied
% case from related article
constraints.positivity = 1;
constraints.causality = 1;
params.make_single_test_plot = 0;
params.save_single_test_plot = 0;

[k_AM_est, y_AM_rec, y_AM_SNR, c_est, y_AM_coeff,  ...
    k_xcorr_est, y_xcorr_rec, y_xcorr_SNR, y_CorrCoeff_SNR,bestLambda ] =...
    runForOptimalLambda(x,k,y,constraints,algp,lambdas,params);

k_AM_est_both = k_AM_est;
y_AM_rec_both = y_AM_rec;
k_AM_Snrs(1,4) = SNR(k, k_AM_est);

k_xcorr_est = k_xcorr_est;
y_xcorr_rec = y_xcorr_rec;
k_AM_Snrs(1,5) = SNR(k, k_xcorr_est);

% %% ========================= Plots for tests 1-4 =========================
% % plot colors
% color_no_constraints = [0,0,0];
% color_just_pos = [255,106,106]./256;
% color_just_causal = [114,45,45]./256;
% color_both = [1,0,0];
% 
% %=========================================================
% f1 = figure('units','normalized','outerposition',[0 0 1 1]);
% set(f1,'Units','Inches');
% pos = get(f1,'Position');
% set(f1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% 
% plot(x);
% title(['x - test case: ' num2str(params.test_case_index)],'FontSize',params.font_size_large); 
% xlabel('t [hours]','FontSize',params.font_size_large);
% ylabel('Rainfall [mm]','FontSize',params.font_size_large);
% 
% %=========================================================
% f2 = figure('units','normalized','outerposition',[0 0 1 1]);
% set(f2,'Units','Inches');
% pos = get(f2,'Position');
% set(f2,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% 
% plot(k, 'LineWidth', params.lw);
% hold on;
% plot(k_AM_est_no_constr, 'k:', 'LineWidth', params.lw);
% plot(k_AM_est_just_pos, 'k--', 'LineWidth', params.lw);
% plot(k_AM_est_just_causal,'k-.', 'LineWidth', params.lw);
% plot(k_AM_est_both, 'Color', color_both, 'LineWidth', params.lw);
% plot(k_xcorr_est, 'g', 'LineWidth', params.lw);
% 
% k_Snr_no_constr = SNR(k,k_AM_est_no_constr);
% k_Snr_just_pos = SNR(k,k_AM_est_just_pos);
% k_Snr_just_causal = SNR(k,k_AM_est_just_causal);
% k_Snr_both = SNR(k,k_AM_est_both);
% k_Snr_xcorr = SNR(k,k_xcorr_est);
% 
% title(['k true, k_{est}s for an input SNR of ' num2str(params.inputSnr) ' dB'],'FontSize',params.font_size_large); 
% xlabel('t [hours]','FontSize',params.font_size_large);
% ylabel('WRT [1/t]','FontSize',params.font_size_large);
% legend('true',...
%     ['No Constr, SNR = ' num2str(k_Snr_no_constr,'%.3g')],...
%     ['Just Pos,  SNR = ' num2str(k_Snr_just_pos,'%.3g')],...
%     ['Just Causal, SNR = ' num2str(k_Snr_just_causal,'%.3g')],...
%     ['Pos And Causal, SNR = ' num2str(k_Snr_both,'%.3g')],...
%     ['XCORR, SNR = ', num2str(k_Snr_xcorr,'%.3g')]);
% set(gca, 'LineWidth', params.lw);
% k_xTick = get(gca,'XTickLabel');
% k_xTick_num = str2double(k_xTick);
% k_xTick_num = k_xTick_num - fix(params.k_length/2);
% k_xTick_final_str = num2str(k_xTick_num);
% set(gca, 'xTickLabel', k_xTick_final_str);
% 
% %=========================================================
% y_Snr_no_constr = SNR(y,y_AM_rec_no_constr);
% y_Snr_just_pos = SNR(y,y_AM_rec_just_pos);
% y_Snr_just_causal = SNR(y,y_AM_rec_just_causal);
% y_Snr_both = SNR(y,y_AM_rec_both);
% y_Snr_xcorr = SNR(y,y_xcorr_rec);
% 
% f3 = figure('units','normalized','outerposition',[0 0 1 1]);
% set(f3,'Units','Inches');
% pos = get(f3,'Position');
% set(f3,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% 
% plot(real(y), 'LineWidth', params.lw);
% hold on;
% plot(real(y_AM_rec_no_constr),'k:', 'LineWidth', params.lw);
% plot(real(y_AM_rec_just_pos),'k--', 'LineWidth', params.lw);
% plot(real(y_AM_rec_just_causal), 'k-.', 'LineWidth', params.lw);
% plot(real(y_AM_rec_both), 'Color', color_both, 'LineWidth', params.lw);
% plot(real(y_xcorr_rec), 'g', 'LineWidth', params.lw);
% 
% legend('true',...
%     ['No Constr, SNR = ' num2str(y_Snr_no_constr,'%.3g')],...
%     ['Just Pos,  SNR = ' num2str(y_Snr_just_pos,'%.3g')],...
%     ['Just Causal, SNR = ' num2str(y_Snr_just_causal,'%.3g')],...
%     ['Pos And Causal, SNR = ' num2str(y_Snr_both,'%.3g')],...
%     ['XCORR, SNR = ', num2str(y_Snr_xcorr,'%.3g')]);
% title(['y true, y_{rec}s for an input SNR of ' num2str(params.inputSnr) ' dB'],'FontSize',params.font_size_large); 
% xlabel('t [hours]','FontSize',params.font_size_large);
% ylabel('Basin [mm]','FontSize',params.font_size_large);
% 
% %% ========================= Plot for test 4 only =========================
% f1 = figure('units','normalized','outerposition',[0 0 1 1]);
%     set(f1,'Units','Inches');
%     pos = get(f1,'Position');
%     set(f1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% 
% 	subplot(3,1,1)
% 	plot(x);
% 	hold on;
% 	title(['x - test case: ' num2str(params.test_case_index) ', lambda =  ' num2str(bestLambda,'%10.3e')], 'FontSize', params.font_size_large);
% 	xlabel('time [hours]', 'FontSize', params.font_size_large);
% 	ylabel('Rainfall [mm]', 'FontSize', params.font_size_large);
% 
%     subplot(3,1,2)
% 	plot(k);
% 	hold on;
%     plot(k_AM_est,'r','LineWidth',2);
% 	plot(k_xcorr_est,'g','LineWidth',2);
% 	title(['k_{est}SNR-AM = ' num2str(k_AM_Snrs(1,4)) ' dB --  k_{est}SNR-XCORR = '...
%         num2str(k_AM_Snrs(1,5)) ' dB'], 'FontSize', params.font_size_large);
% 	xlabel('time [hours]', 'FontSize', params.font_size_large);
% 	ylabel('WRT [1/t]', 'FontSize', params.font_size_large);
% 	legend('true','AM','XCORR','Location','northwest');
%     % put correct xthicks for k
%     k_xTick = get(gca,'XTickLabel');
%     k_xTick_num = str2double(k_xTick);
%     k_xTick_num = k_xTick_num - params.k_length/2;
%     k_xTick_final_str = num2str(k_xTick_num);
% 	set(gca, 'xTickLabel', k_xTick_final_str);
%     
% 	subplot(3,1,3)
% 	plot(y,'LineWidth',2);
% 	hold on;    	
%     plot(y_AM_rec,'r','LineWidth',2);
%     plot(y_xcorr_rec,'g','LineWidth',2);
% 	xlabel('time [hours]', 'FontSize', params.font_size_large);
% 	ylabel('Basin [mm]', 'FontSize', params.font_size_large);
% 	title(['y_{rec}SNR-AM = ' num2str(y_AM_SNR) ' dB --  y_{rec}SNR-XCORR = '...
%         num2str(y_xcorr_SNR) ' dB'], 'FontSize', params.font_size_large)
% 	legend('true','AM','XCORR','Location','northwest');
%     
function [x,k,y,y_true,b,params] = chooseSignals(params, constraints, y_SNR)
% Function to choose a x,k,y set of synthetic signals for testing

% ===================================================================
% X
rainData = load(params.data_to_load);
    
if(strcmp(params.x_type,'diracs'))
    x = zeros(params.x_length,1);
    x(900,1) = 1.5;
    x(200,1) = 0.7;
    params.test_case_index = 1;
    
elseif(strcmp(params.x_type,'fixed_test_index'))
    rainIndex = params.test_case_index;
    x = eval(['rainData.rain' num2str(params.x_length) '(:,rainIndex)']);
    
elseif(strcmp(params.x_type,'rand_test_index'))
    rainIndex = ceil(rand(1,1)*98);
    x = eval(['rainData.rain' num2str(params.x_length) '(:,rainIndex)']);
    params.test_case_index = rainIndex;
    
end

% ===================================================================
% K
params.alpha = 2;
params.beta = 6;
params.sigma = 20;

switch params.k_type
    case 'gaussian'
        getSignal = @(params,constraints) ...
                                getSmoothSignal(params,constraints);
    case 'beta'
        getSignal = @(params,constraints)...
                      getBetaSignal(params,constraints);
end 

k = getSignal(params,constraints);

% ===================================================================
% convolution
switch params.conv_type
    case 'convCirc' 
        myConv = @(signal_1,signal_2) convCirc(signal_1,signal_2);
    case 'convNonCirc'
        myConv = @(signal_1,signal_2) convNonCirc(signal_1,signal_2);
end 


y_true = myConv(x,k);
b = getNoise(y_true,length(y_true),y_SNR,params.b_seed);

y = y_true + b + params.level_constant;

end
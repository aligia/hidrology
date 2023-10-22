function [k_est, y_est] = deconv_Newton (x,y,lambda,constraints,algp,params)
% The Projected Newton deconvolution method

switch params.conv_type
    case 'convCirc' 
        myConv = @(signal_1,signal_2) convCirc(signal_1,signal_2);
    case 'convNonCirc'
        myConv = @(signal_1,signal_2) convNonCirc(signal_1,signal_2);
end 

% Initialization - the first iteration will be the closed form l2 solution projected on constraints;
step_size = params.step_size; 
D = constraints.D;

k_noConst = deconv_L2(x,y,D,lambda,constraints);
k_proj = k_noConst;
k_proj(k_proj<0.0) = 0.0;
k_proj(1:constraints.causalInterval) = 0.0;

k_est = k_proj;
y_est = myConv(x,k_proj);

Fref = 1/2*norm(y)^2;

for it = 1:algp.maxIt_Newton
    
    k_old = k_est;
    
    while 1 && step_size > algp.max_step_size_Newton
        
        k_est = (1-step_size)*k_est + step_size * k_noConst;
        
        if constraints.positivity == 1
            k_est(k_est<0.0) = 0.0;
        end
        if constraints.causality == 1
            k_est(1:constraints.causalInterval) = 0.0;
        end
        
        k_est = real(k_est);
        y_est = real(myConv(x,k_est));
        
        data = 1/2*norm(y - y_est)^2;
        regu = 1/2*norm(smooth(k_est,D,constraints.order))^2;
        Fnew = data + lambda*regu;
        
        if Fnew > Fref
            k_est = k_old;
            step_size = step_size*0.9;
        else
            Fref = Fnew;
            break;
        end
    end
    
    err_rel = norm(k_old-k_est)^2/norm(k_est)^2;
%      fprintf('NEWTON: it = %d -- Fref = %8.2E -- err_rel = %8.2E -- step_size = %8.2E\n', it,  Fref,err_rel,step_size);
    
    if err_rel < algp.max_err_rel_Newton || step_size < algp.max_step_size_Newton
%           fprintf('NEWTON: it = %d -- Fref = %8.2E -- err_rel = %8.2E -- step_size = %8.2E\n', it,  Fref,err_rel,step_size);
        break;
    end

end


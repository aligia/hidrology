function [k_est, y_est, c_est, bad_test_case] = deconv_AM(x,y,lambda,constraints,algp, params)
% Alternating Minimization algorithm
% contains the estimation of k_est and of c_est

c_est = mean(y);
c_est_old = c_est;
y_est = ones(size(y));

stoppingCrtierion = 1;
it = 0;

bad_test_case = 0;

while ( stoppingCrtierion > algp.max_err_rel_AM && it < algp.maxIt_AM )
    
    y_est_old = y_est;
    
    % estim k
    y_hat = y - c_est;
    [k_est, y_hat_est] = deconv_Newton(x,y_hat,lambda,constraints,algp,params);

    % estim c
    c_est = mean(y - y_hat_est);
    
    % update of y_rec
    y_est = y_hat_est + c_est;

    stoppingCrtierion = (norm(y_est-y_est_old)^2/(norm(y_est)^2));
    
    divergenceCriterionForC = abs(c_est - c_est_old);
    
    if(divergenceCriterionForC > 10^(3))
         bad_test_case = 1;
    end
    
    c_est_old = c_est;
    it = it +1;
%   fprintf('          AM: it = %d -- SC = %8.2E \n', it, stoppingCrtierion);

end

end

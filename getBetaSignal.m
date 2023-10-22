function [k] = getBetaSignal (params, constraints)

delay = params.k_delay;
betaNoSamples = (params.k_length/4);
X = 0:1/(betaNoSamples-1):1;
Y1 = betapdf(X,params.alpha,params.beta);
k = zeros( params.k_length,1);
middle = floor(params.k_length/2);

if(constraints.causality == 1)
    if(delay+betaNoSamples-1 > middle)
        error('The delay is to big: middle = %f, delay = %f',middle,delay);
    end
    k(middle+delay:middle+delay+length(Y1)-1) = Y1(:).*3;
else
    k(delay:delay+length(Y1)-1) = Y1(:).*3;
end

if(constraints.positivity == 0)
    k = -k;
end

k = k/max(k);
end
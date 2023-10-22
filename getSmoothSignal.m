function k = getSmoothSignal(params,constraints)

noSamples = params.k_length;
s = exp(- (linspace(-30,30,60).^2/params.sigma^2));

k = zeros(noSamples,1);
start_index = fix(noSamples/2)+params.k_delay;
end_index = start_index +length(s)-1;
k(start_index:end_index) = s(:);

end
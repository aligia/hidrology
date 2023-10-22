function s = getNoise(x,noSamples,outputSNR, seed_type)

if(strcmp(seed_type,'noFixedSeed'))
    sigma_noise = norm(x)^2*10^(-outputSNR/10)/noSamples;
    % generate the corresponding variance of the nosie
    s = sqrt(sigma_noise)*randn(noSamples,1); % generate the noise
else
    s = RandStream('mcg16807', 'Seed',0);
    RandStream.setDefaultStream(s);
    
    sigma_noise = norm(x)^2*10^(-outputSNR/10)/noSamples;
    % generate the corresponding variance of the nosie
    s = sqrt(sigma_noise)*randn(noSamples,1); % generate the noise
end
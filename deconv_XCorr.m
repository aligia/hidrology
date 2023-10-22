function  [k_xcorr_norm, y_xcorr_norm, c_est_xcorr] = deconv_XCorr(x,y,params)
%The cross correlation deconvolution method

switch params.conv_type
    case 'convCirc' 
        myConv = @(signal_1,signal_2) convCirc(signal_1,signal_2);
    case 'convNonCirc'
        myConv = @(signal_1,signal_2) convNonCirc(signal_1,signal_2);
end

meanY = mean(y);
c_est_xcorr = meanY;
y_basic = y - c_est_xcorr;

k_est_cc= flipud(xcorr(x,y_basic,params.xcorr_type));

% if k_est_cc has bigger length than allowed, trim around center
if(length(k_est_cc) > params.k_length)
    k_midlle = fix(length(k_est_cc)/2);
    half_k = fix(params.k_length/2); 
    index1 = k_midlle - half_k;
    index2 = k_midlle + half_k;
    k_est_cc_n = k_est_cc(index1:index2-1,1);
    k_xcorr_est = k_est_cc_n;
else
    k_xcorr_est = k_est_cc;
end

y_est_cc = myConv(x,k_xcorr_est);

% if y_est_cc has bigger length than allowed, trim around center
if(length(y_est_cc) > params.x_length)
    y_midlle = floor(length(y_est_cc)/2);
    half_y = fix(params.x_length/2);
    index3 = y_midlle - half_y;
    index4 = y_midlle + half_y;
    y_est_cc_n = y_est_cc(index3:index4-1);
    y_xcorr_rec = y_est_cc_n;
else
    y_xcorr_rec = y_est_cc;
end

% renormalize by same stddev
factor = std(real(y_basic)) / std(real(y_xcorr_rec));
k_xcorr_norm = k_xcorr_est * factor;

y_xcorr_norm = myConv(x, k_xcorr_norm);

y_xcorr_norm = y_xcorr_norm + c_est_xcorr;

end
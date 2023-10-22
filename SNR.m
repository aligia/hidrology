function res = SNR(sig_1,sig_2)

res = 20* log10(norm(sig_1)/norm(sig_1-sig_2));

end
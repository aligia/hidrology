function [smooth_k] = smooth(k,D,order)

k = k(:);
D = D(:);
smooth_k = real(fftshift(fft((ifft(D,length(k)).^order).*ifft(k))));

end
function y = convCirc(signal_1, signal_2)
% takes signal_1 and signal_2 in the time domain

l_1 = length(signal_1);
l_2 = length(signal_2);

if l_1 > l_2
    l = l_1;
    signal_2_pad = zeros(l,1);
    signal_2_shifted = fftshift(signal_2);
    signal_2_pad(1:fix(l_2/2)) = signal_2_shifted(1:fix(l_2/2));
    signal_2_pad(end-fix(l_2/2)+1:end) = signal_2_shifted(end-fix(l_2/2)+1:end);
    signal_2_pad =  fftshift(signal_2_pad);
    y = fftshift(ifft(fft(signal_1).*fft(signal_2_pad)));
elseif l_2 > l_1
    l = l_2;
    signal_1_pad = zeros(l,1);
    signal_1_shifted = fftshift(signal_1);
    signal_1_pad(1:fix(l_1/2)) = signal_1_shifted(1:fix(l_1/2));
    signal_1_pad(end-fix(l_1/2)+1:end) = signal_1_shifted(end-fix(l_1/2)+1:end);
    signal_1_pad =  fftshift(signal_1_pad);
    y = fftshift(ifft(fft(signal_1_pad).*fft(signal_2)));
else
    y = fftshift(ifft(fft(signal_1).*fft(signal_2)));
end

y = real(y);

end
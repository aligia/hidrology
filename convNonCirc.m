function y = convNonCirc(signal_1, signal_2)
% takes signal_1 and signal_2 in the time domain

l_1_i = length(signal_1);
l_2_i = length(signal_2);

buffer_length_l_1 = floor(l_1_i/2);
buffer_length_l_2 = floor(l_2_i/2);

buffer_1 = zeros(buffer_length_l_1,1);
buffer_2 = zeros(buffer_length_l_2,1);

signal_1 = [buffer_1; signal_1; buffer_1];
signal_2 = [buffer_2; signal_2; buffer_2];

l_1 = length(signal_1);
l_2 = length(signal_2);

if l_1 > l_2
    l = l_1;
    signal_pad_left = zeros(fix((l-l_2+1)/2),1);
    signal_pad_right = zeros(fix((l-l_2)/2),1);
    padded_signal = [signal_pad_left; signal_2; signal_pad_right];
    long_signal = signal_1;
    y = fftshift(ifft(fft(padded_signal).*fft(long_signal)));
    y = y(buffer_length_l_1:buffer_length_l_1+l_1_i-1);
elseif l_2 > l_1
    l = l_2;
    signal_pad_left = zeros(fix((l-l_1+1)/2),1);
    signal_pad_right = zeros(fix((l-l_1)/2),1);
    padded_signal = [signal_pad_left; signal_1; signal_pad_right];
    long_signal = signal_2;
    y = fftshift(ifft(fft(padded_signal).*fft(long_signal)));
    y = y(buffer_length_l_2:buffer_length_l_2+l_2_i-1);
else
    y = fftshift(ifft(fft(signal_1).*fft(signal_2)));
    y = y(buffer_length_l_2:buffer_length_l_2+l_2_i-1);
end

y = real(y);

end
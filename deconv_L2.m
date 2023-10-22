function [k] = deconv_L2(x,y,D, lambda_m,constraints)
% [ke]=dec1D_cg(x,y,D,lambda_m,constraints)
% deconvolution by  minimizing 1/2*|y - k*x|^2 + lambda_m_2/2 * |D*k|^2;
% Analytic solution in Fourier domain: k_hat = x_hat^* / (|x|^2+lambda_m D'D) y
% Input :
%   y : the resulted signal after convolution
%   x : the initial signal
%   D : smoothing operator
% Output :
%   k : deconvolved kernel signal

y = y(:);
N = length(y);
xx = zeros(N,1);
xx(1:length(x)) = x(:);
x = xx;
dd = zeros(N,1);
dd(1:length(D)) = D(:);
D = dd.^constraints.order;

midlle = floor(length(x)/2);
buffer = zeros(midlle,1);
y = [buffer; y; buffer];
x = [buffer; x; buffer];
D = [buffer; D; buffer];

y = fft(y);
x = fft(x);
D = fft(D);
x_conj = conj(x);
D_conj = conj(D);

A = x_conj.*x + lambda_m * D_conj.*D;
invA = 1./A;
k = invA.*(x_conj.*y);

k=fftshift(ifft(k));

% resizing k to original size before convolution
newMiddle = fix(length(k)/2);
k = real(k(newMiddle-constraints.causalInterval:newMiddle+constraints.causalInterval-1));
end


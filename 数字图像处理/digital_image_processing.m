clear
% 中值滤波
img = imread('girl.bmp');
% f = imread('Lena.bmp');

cm = (img(:, :, 1) + img(:, :, 2) + img(:, :, 3)) / 3;
[n, m] = size(cm);
%{
f1 = imnoise(f, 'salt & pepper', 0.02);

% L = size(f, 1); W = size(f, 2);
[L, W] = size(f);

g = medfilt2(f1);
subplot(1, 3, 1), imshow(f);
subplot(1, 3, 3), imshow(f1);
subplot(1, 3, 2), imshow(g);
%}

cf = fft2(cm); % 进行傅氏变换
cf = fftshift(cf); % 进行中心变换
u = [-floor(m / 2) : floor((m - 1) / 2)]; % 水平频率
v = [-floor(n / 2) : floor((n - 1) / 2)]; % 垂直频率
[uu, vv] = meshgrid(u, v); % 频域平面上的网格结点
bl = 1 ./ (1 + (sqrt(uu.^2 + vv.^2) / 15).^2); % 构造1阶巴特沃兹低通滤波器
cfl = bl .* cf; % 逐点相乘，进行低通滤波
cml = real(ifft2(cfl)); % 进行逆傅氏变换，并取实部
% cml = ifftshift(cml);
cml = uint8(cml); % 必须进行数据格式转换
subplot(1, 2, 1), imshow(cm)  % 显示原图像
subplot(1, 2, 2), imshow(cml) % 显示滤波后的图像













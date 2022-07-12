
clear

dat0 = load('d.txt');
x = dat0(:, [1 : 2 : 8]); x = x(:); % 向量化
y = dat0(:, [2 : 2 : 8]); y = y(:);
dat = [x y];
d1 = [70, 40];
dat = [d1; dat; d1];
dat = dat * pi / 180; % 角度转弧度
n = 102;    % 节点数目
d = zeros(n);
for i = 1 : n - 1
    for j = i + 1 : n
       d(i, j) = 6370 * acos(cos(dat(i, 1) - dat(j, 1)) * cos(dat(i, 2)) * cos(dat(j, 2)) + sin(dat(i, 2)) * sin(dat(j, 2)));
    end
end

d = d + d';
w = 50; % 种群的个数
g = 400; % 进化代数
rand('state', sum(clock));  % 初始化随机数发生器


% 通过改良圈算法选取初始种群
for k = 1 : w
    c = [1, 1 + randperm(n - 2), n];
    % 改良圈算法
    for t = 1 : n
        flag = 0;
        for i = 1 : (n - 2)
            for j = (i + 2) : (n - 1)
                if d(c(i), c(j)) + d(c(i + 1), c(j + 1)) < d(c(i), c(i + 1)) + d(c(j), c(j + 1))
                    c(i + 1 : j) = c(j : -1 : i + 1);
                    flag = 1;   % 修改圈
                end
            end
        end
        
        if flag == 0    % 返回
            J(k, c) = 1 : n;
            break;
        end
    end
end

J(:, 1) = 0; J = J / n;   % 将整数序列转成[0，1]上的实数（染色体编码）


% 遗传算法
for k = 1 : g
    A = J;  % 交配产生子代A的初始染色体
    c = randperm(w);    % 产生下面交叉操作的染色体对
    for i = 1 : 2 : w
        %{
        F = 2 + floor((n - 2) * rand(1)); % 产生交叉操作的地址 [2, 101]
        % 交叉操作
        tmp = A(c(i), [F : n]);
        A(c(i), [F : n]) = A(c(i + 1), [F : n]);
        A(c(i + 1), [F : n]) = tmp;
        %}
        ch1 = rand;     % 混沌序列初始值
        for j = 2 : w
            ch1(j) = 4 * ch1(j - 1) * (1 - ch1(j - 1));  % 产生混沌序列
        end
        ch1 = 2 + floor(100 * ch1);
        tmp = A(c(i), ch1);
        A(c(i), ch1) = A(c(i + 1), ch1);
        A(c(i + 1), ch1) = tmp;
    end
    
    by = [];
    while ~length(by)
         by = find(rand(1, w) < 0.1);    % 产生变异操作的地址（染色体对象）
    end
    B = A(by, :);   % 产生变异操作的初始染色体
    
    %{
    for j = 1 : length(by)
        bw = sort(2 + floor((n - 2) * rand(1, 3)));     % 产生变异操作的3个地址（染色体上的位置）
        B(j, :) = B(j, [1 : bw(1) - 1, bw(2) + 1 : bw(3), bw(1) : bw(2), bw(3) + 1 : n]);
    end
    %}
    ch2 = rand;
    for j = 2 : 2 * length(by)
        ch2(j) = 4 * ch2(j - 1) * (1 - ch2(j - 1));
    end
    for j = 1 : length(by)
        bw = sort(2 + floor((n - 2) * rand(1, 2)));
        B(j, bw) = ch2([j, j + 1]);
    end
    
    G = [J; A; B];  % 将父代和子代种群合在一起
    [SG, i1] = sort(G, 2);  % 将染色体翻译成1,...,n的序列i1（解编码）
    num = size(G, 1); L = zeros(1, num);
    
    for i = 1 : num
        for j = 1 : n - 1
            L(i) = L(i) + d(i1(i, j), i1(i, j + 1));
        end
    end
    
    [sL, i2] = sort(L);
    J = G(i2(1 : w), :);    % 精选前w个较短的路径对应的染色体（优胜略汰）
end

p = i1(i2(1), :); fL = sL(1);
fL / 1000
% 39.5211
xx = dat(p, 1); yy = dat(p, 2);
% plot(xx, yy, '- o');

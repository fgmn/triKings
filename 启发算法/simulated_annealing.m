clear
%{
d = zeros(6);
d(1, 2) = 56; d(1, 3) = 35; d(1, 4) = 21; d(1, 5) = 51; d(1, 6) = 60;
d(2, 3) = 21; d(2, 4) = 57; d(2, 5) = 78; d(2, 6) = 70;
d(3, 4) = 36; d(3, 5) = 68; d(3, 6) = 68;
d(4, 5) = 51; d(4, 6) = 61;
d(5, 6) = 13;
%}

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
p = []; L = inf;
rand('state', sum(clock));  % 初始化随机数发生器


% 求一组较优初始解
for i = 1 : 1000
    path0 = [1, 1 + randperm(n - 2), n]; % TSP问题固定起点
    tmp = 0;
    for j = 1 : n - 1
        tmp = tmp + d(path0(j), path0(j + 1));
    end
    if tmp < L
        p = path0; L = tmp;
    end
end

e = 0.1 ^ 30;
N = 20000;
at = 0.9999;
T = 1;

for i = 1 : N
    c = 2 + floor((n - 2) * rand(1, 2)); % 产生新解[2, n - 1] % r = a + (b-a).*rand(N,1) 生成区间 (a,b) 内的 N 个随机数
    c = sort(c);
    c1 = c(1);
    c2 = c(2);
    df = d(p(c1 - 1), p(c2)) + d(p(c1), p(c2 + 1)) - d(p(c1 - 1), p(c1)) - d(p(c2), p(c2 + 1));
    if df < 0   % 接受准则
        p = [p(1 : c1 - 1), p(c2 : -1 : c1), p(c2 + 1 : n)]; L = L + df;
    elseif exp(-df / T) >= rand
        p = [p(1 : c1 - 1), p(c2 : -1 : c1), p(c2 + 1 : n)]; L = L + df;
    end
    T = at * T;
    if T < e
        break;
    end
end
L / 1000
% 42.0219
xx = dat(p, 1);
yy = dat(p, 2);
% plot(xx, yy, '- * ');


        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
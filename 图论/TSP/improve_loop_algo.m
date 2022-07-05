
% 构造距离矩阵a
a = zeros(6);
a(1, 2) = 56; a(1, 3) = 35; a(1, 4) = 21; a(1, 5) = 51; a(1, 6) = 60;
a(2, 3) = 21; a(2, 4) = 57; a(2, 5) = 78; a(2, 6) = 70;
a(3, 4) = 36; a(3, 5) = 68; a(3, 6) = 68;
a(4, 5) = 51; a(4, 6) = 61;
a(5, 6) = 13;

a = a + a';

L = size(a, 1);
c = [5 1:4 6 5];

[circle, len] = modifyCircle(a, L, c)

% circle：近似最小哈密顿圈 len：其长度
function [circle, len] = modifyCircle(a, L, c)
    for k = 1 : L
        flag = 0;
        % n^2枚举区间
        for m = 1 :(L - 2)  % 左边界
            for n = (m + 2) : L     % 右边界
                if a(c(m), c(n)) + a(c(m + 1), c(n + 1)) < a(c(m), c(m + 1)) + a(c(n), c(n + 1))
                    c(m + 1 : n) = c(n : -1 : m + 1);   % 区间反转
                    flag = flag + 1;
                end
            end
        end
        
        if flag == 0    % 返回
            len = 0;
            for i = 1 : L
                len = len + a(c(i), c(i + 1));
            end
            circle = c;
            return
        end
    end
end



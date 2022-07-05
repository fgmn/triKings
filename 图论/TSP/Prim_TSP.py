from cmath import inf
import numpy as np
# import matplotlib.pyplot as plt

# 代价函数，具有三角不等式性质
def Price(v1, v2):
    return np.linalg.norm(np.array(v1) - np.array(v2))

# Prim算法 #

# 找已访问点和未访问点相连的最短边
def findEdge(vis, unvis):
    minWeight, _from, _to = np.inf, np.inf, np.inf
    # i -> j
    for i in vis:
        for j, w in enumerate(G[i]):
            if w < minWeight and j in unvis:
                _from = i
                _to = j
                minWeight = G[i][j]
    return (_from, _to), minWeight

# 获得未访问点集
def getUnvis(G, vis):
    unvis = []
    [unvis.append(i) for i, _ in enumerate(G) if i not in vis]
    return unvis

def Prim(G, root = 0):
    vis = [root]    # 维护已访问点集
    Path = []
    while len(vis) != G.shape[0]:
        unvis = getUnvis(G, vis)
        (_from, _to), minWeight = findEdge(vis, unvis)
        vis.append(_to)
        Path.append((_from, _to))
    T = np.full_like(G, np.inf) # 最小生成树的矩阵形式
    for (i, j) in Path:
        T[i][j] = G[i][j]
        T[j][i] = G[j][i]
    return T, Path

# 获得最小生成树的前序序列
def preOrder(T, root = 0):
    vis = [False] * T.shape[0]
    stack = [root]
    L = []
    while len(stack) != 0:
        u = stack.pop()
        L.append(u)
        vis[u] = True
        nxt = np.where(T[u] != np.inf)[0]
        if len(nxt) > 0:
            [stack.append(v) for v in reversed(nxt) if vis[v] is False]
    return L

# Prim算法 #

# 生成哈密顿回路
def H(G, L):
    H = np.full_like(G, np.inf)
    Path = []
    for i, _from in enumerate(L[0:-1]):
        _to = L[i + 1]
        H[_from][_to] = G[_from][_to]
        H[_to][_from] = G[_to][_from]
        Path.append((_from, _to))
    return H, Path

# def Draw(city, Path):
#     fig = plt.figure()

city = [(2, 6), (2, 4), (1, 3), (4, 6), (5, 5), (4, 4), (6, 4), (3, 2)]  # 城市坐标
G = []
# 建图
for i, p1 in enumerate(city):
    line = []
    for j, p2 in enumerate(city):
        line.append(Price(p1, p2)) if i != j else line.append(np.inf)
    G.append(line)
G = np.array(G) # 邻接矩阵

# print(G)

# 1.选择任意一个起点
root = 0
# 2.Prim求最小生成树
T, T_Path = Prim(G, root = root)
# print(T)
# 3.前序遍历得到顶点表L
L = preOrder(T, root = root)
# 4.根据L生成汉密顿回路H
L.append(root)
H, H_Path = H(G, L)

print('最小生成树的路径为：{}'.format(T_Path))
[print(chr(97 + v), end = ',' if i < len(L) - 1 else '\n') for i, v in enumerate(L)]
print('哈密顿回路的路径为：{}'.format(H_Path))
print('哈密顿回路产生的代价为：{}'.format(sum(G[i][j] for (i, j) in H_Path)))
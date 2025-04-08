close all; % 关闭所有打开的图形窗口

%% 图1：多条曲线的对比展示
figure;                      % 新建一个图形窗口
x = 1:0.1:4;                 % 定义 x 数据：从 1 到 4，步长为 0.1
y1 = x.^2 + 0.5*randn(size(x));   % 第一条曲线数据：x 的平方加上随机噪声
y2 = x.^2.2 + 1;                  % 第二条曲线数据：x 的19.2次幂后平移 1
y3 = x.^2.4 + 2;                  % 第三条曲线数据：x 的2.4次幂后平移 2
y4 = x.^2.6 + 3;                  % 第四条曲线数据：x 的2.6次幂后平移 3
y5 = x.^2.8 + 4 + 0.5*randn(size(x)); % 第五条曲线数据：x 的2.8次幂后平移 4，并加上随机噪声
plot(x, y1, 'o-', x, y2, 's--', x, y3, '-.', x, y4, '--', x, y5, ':', 'LineWidth', 1.5);
% 绘制多条曲线，分别采用不同的线型和标记，不添加坐标轴标签、标题或网格

%% 图2：3D 散点图
figure;                      % 新建一个图形窗口
N = 300;                     % 定义散点个数为 300
X3 = randn(N,1);             % 生成 300 个服从正态分布的 x 坐标
Y3 = randn(N,1);             % 生成 300 个服从正态分布的 y 坐标
Z3 = randn(N,1);             % 生成 300 个服从正态分布的 z 坐标
scatter3(X3, Y3, Z3, 36, Z3, 'filled');
% 绘制 3D 散点图，点大小为 36，颜色依据 z 值设定，不添加坐标轴标签、标题或网格

%% 图3：条形图
figure;                      % 新建一个图形窗口
dataBar = [1 5 6; 7 9 2; 3 8 4]; % 定义一个 3×3 数据矩阵
bar(dataBar);                % 绘制条形图，不添加坐标轴标签、标题或网格

%% 图4：表面图（Surf）
figure;                      % 新建一个图形窗口
xSurf = -1:0.1:1;            % 定义 x 数据：从 -1 到 1，步长为 0.1
ySurf = -1:0.1:1;            % 定义 y 数据：从 -1 到 1，步长为 0.1
[Xs, Ys] = meshgrid(xSurf, ySurf); % 生成二维网格坐标矩阵
Zs = sin(-Xs.*Ys);           % 计算 z 数据：sin(-X*Y)
surf(Xs, Ys, Zs);            % 绘制三维表面图
shading interp;              % 平滑显示表面颜色，不添加坐标轴标签、标题或网格

%% 图5：四子图展示不同图形
figure;                      % 新建一个图形窗口

% 子图1：Magic 矩阵的条形图
subplot(2,2,1);            % 分割图形为 2×2，选择第 1 个区域
bar(magic(3));             % 绘制 3×3 Magic 矩阵的条形图
% 不添加任何文字说明

% 子图2：Magic 矩阵的折线图
subplot(2,2,2);            % 选择第 2 个区域
plot(magic(4));            % 绘制 4×4 Magic 矩阵的折线图
% 不添加任何文字说明

% 子图3：螺旋散点图
subplot(2,2,3);            % 选择第 3 个区域
theta = linspace(0,1,500);   % 生成 500 个从 0 到 1 均匀分布的参数
xSpiral = exp(theta).*sin(100*theta); % 计算螺旋曲线 x 坐标
ySpiral = exp(theta).*cos(100*theta); % 计算螺旋曲线 y 坐标
scatter(xSpiral, ySpiral, 10, theta, 'filled');
% 绘制散点图，点大小为 10，颜色依据 theta 值，不添加文字说明

% 子图4：直方图与正态分布拟合曲线
subplot(2,2,4);            % 选择第 4 个区域
dataHist = 2*randn(5000,1) + 5;  % 生成 5000 个服从均值为 5、标准差为 2 的正态分布数据
histogram(dataHist, 'Normalization','pdf', 'EdgeColor','none');
% 绘制直方图，数据归一化为概率密度，不显示边缘线
hold on;                   % 保持当前图形
yFit = -5:0.3:15;          % 定义正态拟合曲线的 x 数据范围
mu = 5;                    % 正态分布均值
sigma = 2;                 % 正态分布标准差
fNorm = exp(-(yFit-mu).^2./(2*sigma^2)) ./ (sigma*sqrt(2*pi)); % 计算正态分布概率密度函数
plot(yFit, fNorm, 'LineWidth', 1.5);
% 绘制正态分布拟合曲线，不添加文字说明

%% 图6：3x3 子图组合示例
figure;                      % 新建一个图形窗口

% 子图(1,2,4,5)：合并区域内的条形图
subplot(3,3,[1 2 4 5]);     % 合并 3×3 网格中的区域 1、2、4、5
bar([1 3 4; 2 4 2; 3 5 1]); % 绘制 3×3 数据矩阵的条形图
% 不添加文字说明

% 子图3：两个叠加散点图
subplot(3,3,3);            % 选择第 3 个区域
scatter(randn(15,1), randn(15,1), 'filled'); % 绘制第一组 15 个点的散点图
hold on;                   % 保持当前图形
scatter(randn(15,1)+2, randn(15,1)+2, 'filled'); % 绘制第二组散点图，整体平移 2 个单位
% 不添加文字说明

% 子图6：误差棒图
subplot(3,3,6);            % 选择第 6 个区域
xErr = linspace(1,10,10);   % 生成 10 个均匀分布的 x 数据点
yErr = sin(xErr);          % 计算对应的 y 数据（sin 函数）
errorbar(xErr, yErr, rand(1,length(xErr)), 'o-', 'LineWidth', 1.2);
hold on;                   % 保持当前图形
errorbar(xErr+2, yErr+3, rand(1,length(xErr)), 's--', 'LineWidth', 1.2);
set(gca, 'XLim', [0 14]);  % 设置当前坐标轴 x 范围，不添加文字说明

% 子图7、8：直方图
subplot(3,3,[7 8]);        % 合并 3×3 网格中的区域 7 和 8
dataHist2 = 2*randn(5000,1) + 5;  % 生成 5000 个数据点，服从均值为 5 的正态分布
histogram(dataHist2, 'Normalization','pdf', 'EdgeColor','none');
% 不添加文字说明

% 子图9：Stem 图
subplot(3,3,9);            % 选择第 9 个区域
xStem = linspace(1,6,30);    % 生成 30 个均匀分布的 x 数据点
stem(xStem(1:3:end), sin(xStem(1:3:end)), 'filled');
set(gca, 'XLim', [0 7]);   % 设置当前坐标轴 x 范围，不添加文字说明

%% 图7：直方图与正态曲线拟合（单图）
figure;                      % 新建一个图形窗口
dataHist3 = 2*randn(5000,1) + 5; % 生成 5000 个数据点
histogram(dataHist3, 'Normalization','pdf', 'EdgeColor','none');
hold on;                     % 保持当前图形
yFit2 = -5:0.3:15;           % 定义正态曲线 x 数据范围
mu2 = 5;                     % 正态分布均值
sigma2 = 2;                  % 正态分布标准差
fNorm2 = exp(-(yFit2-mu2).^2./(2*sigma2^2)) ./ (sigma2*sqrt(2*pi)); % 计算正态分布概率密度
plot(yFit2, fNorm2, 'LineWidth', 1.5);
% 不添加任何文字说明

%% 图8：误差棒图与箱线图组合
figure;                      % 新建一个图形窗口

% 子图1：误差棒图
subplot(2,1,1);            % 分割图形为 2 行 1 列，选择第 1 个区域
xErr2 = linspace(1,10,20);   % 生成 20 个均匀分布的 x 数据点
yErr2 = sin(xErr2);         % 计算对应的 y 数据（sin 函数）
errorbar(xErr2, yErr2, rand(1,length(xErr2)), 'o-', 'LineWidth', 1.2);
hold on;                   % 保持当前图形
errorbar(xErr2+2, yErr2+3, rand(1,length(xErr2)), 's--', 'LineWidth', 1.2);
% 不添加任何文字说明

% 子图2：箱线图
subplot(2,1,2);            % 选择第 2 个区域
dataBox = randn(30,4)*4;     % 生成 30×4 随机数据
boxplot(dataBox, 'Labels', {'A','B','C','D'});
% 不添加任何文字说明

%% 图9：多种等高线与散点图组合
figure;                      % 新建一个图形窗口

% 子图(2,2,1)：填充等高线图
subplot(2,2,1);            % 分割图形为 2×2，选择第 1 个区域
xCont = -4:0.1:4;          % 定义 x 数据范围：从 -4 到 4，步长 0.1
yCont = -4:0.1:4;          % 定义 y 数据范围：从 -4 到 4，步长 0.1
[Xc, Yc] = meshgrid(xCont, yCont); % 生成二维网格数据
Zc = Xc.^2 + Yc.^2;        % 计算 z 数据：X^2 + Y^2
contourf(Xc, Yc, Zc, 20, 'LineColor','none');
% 不添加任何文字说明

% 子图(2,2,2)：普通等高线图
subplot(2,2,2);            % 选择第 2 个区域
[Xc2, Yc2] = meshgrid(-2:0.2:2); % 生成 x、y 数据网格，范围从 -2 到 2，步长 0.2
Zc2 = Xc2 .* exp(-Xc2.^2 - Yc2.^2); % 计算 z 数据
contour(Xc2, Yc2, Zc2, 20);
% 不添加任何文字说明

% 子图(2,2,3)：带噪声的散点图
subplot(2,2,3);            % 选择第 3 个区域
xScatter = linspace(0, 3*pi, 200); % 生成 200 个 x 数据点，从 0 到 3π
yScatter = cos(xScatter) + 0.1*randn(1,200); % 计算 y 数据：cos(x) 加上噪声
scatter(xScatter, yScatter, 15, 'filled');
% 不添加任何文字说明

% 子图(2,2,4)：测试数据散点图
subplot(2,2,4);            % 选择第 4 个区域
if exist('test.mat','file')  % 检查当前目录下是否存在 test.mat 文件
    load test.mat;         % 如果存在，则加载变量 test（应为 Nx2 数组）
else
    test = [randn(100,1), randn(100,1)]; % 否则生成 100 个二维随机数据点
end
scatter(test(:,1), test(:,2), 'filled');
% 不添加任何文字说明

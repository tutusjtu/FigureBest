close all;  % 关闭所有打开的图形窗口

%% Figure 1: 多条曲线图（使用正弦、余弦及其倍频函数）
figure;                          % 新建一个图形窗口
x = linspace(0, 10, 200);          % 生成 0 到 10 的 200 个点
y1 = sin(x) + 0.3*randn(1,200);    % 第一条曲线：sin(x) 加上少量随机噪声
y2 = cos(x) + 0.3*randn(1,200);    % 第二条曲线：cos(x) 加上少量随机噪声
y3 = sin(2*x) + 0.3*randn(1,200);  % 第三条曲线：sin(2x) 加上少量随机噪声
y4 = cos(2*x) + 0.3*randn(1,200);  % 第四条曲线：cos(2x) 加上少量随机噪声
% 绘制多条曲线，采用不同的线型和标记，线宽设为 1.5
plot(x, y1, '-o', x, y2, '-s', x, y3, '-d', x, y4, '-^', 'LineWidth', 1.5);

%% Figure 2: 3D 散点图（生成 3D 螺旋）
figure;                          % 新建一个图形窗口
theta = linspace(0, 6*pi, 300);   % 角度参数，从 0 到 6π，总共 300 个点
z = linspace(-2, 2, 300);          % z 坐标从 -2 到 2
r = linspace(0.5, 1.5, 300);       % 半径从 0.5 逐渐增加到 1.5
x3d = r .* cos(theta);           % 计算 3D 螺旋的 x 坐标
y3d = r .* sin(theta);           % 计算 3D 螺旋的 y 坐标
% 使用 scatter3 绘制 3D 散点图，点大小为 36，颜色依赖于 theta
scatter3(x3d, y3d, z, 36, theta, 'filled');

%% Figure 3: 条形图（使用随机整数数据）
figure;                          % 新建一个图形窗口
dataBar = randi([1, 20], 4, 5);    % 生成一个 4×5 的矩阵，元素为 1 到 20 之间的随机整数
bar(dataBar);                    % 绘制条形图

%% Figure 4: 表面图（2D 高斯函数）
figure;                          % 新建一个图形窗口
xSurf = linspace(-3, 3, 100);      % x 坐标从 -3 到 3，100 个点
ySurf = linspace(-3, 3, 100);      % y 坐标从 -3 到 3，100 个点
[X, Y] = meshgrid(xSurf, ySurf);   % 生成二维网格数据
Z = exp(-(X.^2 + Y.^2));         % 计算二维高斯函数（圆对称衰减）
surf(X, Y, Z);                   % 绘制三维表面图
shading interp;                  % 使用插值着色，使表面颜色平滑过渡

%% Figure 5: 2×2 子图组合（不同图形）
figure;                          % 新建一个图形窗口

% 子图 1：随机数据的热图
subplot(2,2,1);                % 分割图形为 2×2 网格，选择第 1 个区域
imagesc(rand(10));             % 用 10×10 随机矩阵生成热图

% 子图 2：带噪声的指数衰减曲线
subplot(2,2,2);                % 选择第 2 个区域
t = linspace(0, 5, 100);         % 生成 0 到 5 的 100 个点
plot(t, exp(-t) + 0.1*randn(1,100), '-o', 'LineWidth', 1.5);  % 绘制指数衰减曲线，并添加噪声

% 子图 3：两组聚类散点图
subplot(2,2,3);                % 选择第 3 个区域
data1 = randn(50,2) + 2;         % 第一组 50 个点，中心偏右上
data2 = randn(50,2) - 2;         % 第二组 50 个点，中心偏左下
scatter(data1(:,1), data1(:,2), 40, 'filled');  % 绘制第一组散点
hold on;                       % 保持当前图形
scatter(data2(:,1), data2(:,2), 40, 'filled');  % 绘制第二组散点

% 子图 4：均匀分布数据的直方图及指数拟合
subplot(2,2,4);                % 选择第 4 个区域
dataHist = rand(1,1000);         % 生成 1000 个均匀分布数据（范围 0 到 1）
histogram(dataHist, 'Normalization', 'pdf', 'EdgeColor', 'none');  % 绘制直方图，归一化为概率密度
hold on;                       % 保持当前图形
x_fit = linspace(0, 1, 100);     % 生成拟合曲线的 x 数据
fit_curve = exppdf(x_fit, 0.5);  % 计算指数概率密度函数（均值 0.5）
plot(x_fit, fit_curve, 'LineWidth', 1.5);  % 绘制拟合曲线

%% Figure 6: 3×3 子图组合（多种图形）
figure;                          % 新建一个图形窗口

% 合并子图 (1,1)：使用正弦矩阵生成条形图
subplot(3,3,[1 2 4 5]);         % 合并 3×3 网格中区域 1、2、4、5
dataMatrix = sin(linspace(0, pi, 12));  % 生成 12 个正弦值
dataMatrix = reshape(dataMatrix, [3,4]); % 重构为 3×4 矩阵
bar(dataMatrix);               % 绘制条形图

% 子图 3：两个叠加的散点图（有平移效果）
subplot(3,3,3);                % 选择第 3 个区域
scatter(randn(20,1), randn(20,1), 'filled');  % 绘制第一组 20 个散点
hold on;                       % 保持当前图形
scatter(randn(20,1)+3, randn(20,1)+3, 'filled');  % 绘制第二组散点，并整体平移

% 子图 6：误差棒图（正弦数据）
subplot(3,3,6);                % 选择第 6 个区域
xErr = linspace(0, 10, 15);      % 生成 15 个 x 数据点
yErr = sin(xErr);              % 计算 sin(x)
errorbar(xErr, yErr, 0.2*rand(1,15), 'o-', 'LineWidth', 1.2);  % 绘制误差棒图，误差为随机值

% 合并子图 (7,8)：伽马分布数据的直方图
subplot(3,3,[7 8]);            % 合并 3×3 网格中区域 7 和 8
dataGamma = gamrnd(2,2,1000,1);  % 生成 1000 个伽马分布数据（形状参数 2，尺度参数 2）
histogram(dataGamma, 'Normalization', 'pdf', 'EdgeColor', 'none');  % 绘制归一化直方图

% 子图 9： Stem 图（余弦序列）
subplot(3,3,9);                % 选择第 9 个区域
xStem = linspace(0, 2*pi, 20);   % 生成 20 个点覆盖 0 到 2π
stem(xStem, cos(xStem), 'filled');  % 绘制余弦函数的 Stem 图

%% Figure 7: 直方图与正态分布拟合（使用不同数据）
figure;                          % 新建一个图形窗口
dataNormal = 3*randn(1000,1) + 1;  % 生成 1000 个正态分布数据，均值为 1，标准差为 3
histogram(dataNormal, 'Normalization', 'pdf', 'EdgeColor', 'none');  % 绘制归一化直方图
hold on;                       % 保持当前图形
xFit = linspace(min(dataNormal), max(dataNormal), 100);  % 生成拟合曲线的 x 数据
pdfNormal = normpdf(xFit, mean(dataNormal), std(dataNormal));  % 计算正态分布概率密度函数
plot(xFit, pdfNormal, 'LineWidth', 1.5);  % 绘制正态分布拟合曲线

%% Figure 8: 误差棒图与箱线图组合（不同数据）
figure;                          % 新建一个图形窗口

% 子图 1：误差棒图（使用余弦数据）
subplot(2,1,1);                % 将图形窗口分为 2 行，选择第 1 个区域
xErr2 = linspace(0, 8, 25);       % 生成 25 个 x 数据点
yErr2 = cos(xErr2) + 0.1*randn(1,25);  % 计算余弦值并加入少量噪声
errorbar(xErr2, yErr2, 0.3*rand(1,25), 'o-', 'LineWidth', 1.2);  % 绘制误差棒图

% 子图 2：箱线图（数据具有逐渐增大的离散性）
subplot(2,1,2);                % 选择第 2 个区域
dataBox = randn(50,5) .* repmat(linspace(1,3,5), 50, 1);  % 生成 50×5 数据，不同列数据方差逐渐增大
boxplot(dataBox);              % 绘制箱线图

%% Figure 9: 2×2 子图组合（等高线与散点图）
figure;                          % 新建一个图形窗口

% 子图 1：填充等高线图（余弦调制的函数）
subplot(2,2,1);                % 将图形分为 2×2，选择第 1 个区域
xC = linspace(-pi, pi, 80);       % 生成 x 数据，从 -π 到 π
yC = linspace(-pi, pi, 80);       % 生成 y 数据，从 -π 到 π
[Xc, Yc] = meshgrid(xC, yC);      % 生成二维网格
Zc = cos(Xc).*sin(Yc);          % 计算函数值：cos(x)*sin(y)
contourf(Xc, Yc, Zc, 20, 'LineColor','none');  % 绘制 20 级填充等高线图

% 子图 2：普通等高线图（鞍面函数）
subplot(2,2,2);                % 选择第 2 个区域
[Xc2, Yc2] = meshgrid(linspace(-2,2,50));  % 生成 x、y 网格数据
Zc2 = Xc2.^2 - Yc2.^2;          % 计算鞍面函数：X^2 - Y^2
contour(Xc2, Yc2, Zc2, 20);      % 绘制 20 级等高线图

% 子图 3：散点图（噪声圆环）
subplot(2,2,3);                % 选择第 3 个区域
theta_scatter = linspace(0, 2*pi, 150);  % 生成 150 个角度点
r_scatter = 1 + 0.2*randn(1,150);  % 半径围绕 1 加上噪声
xScatter2 = r_scatter .* cos(theta_scatter);  % 计算圆环的 x 坐标
yScatter2 = r_scatter .* sin(theta_scatter);  % 计算圆环的 y 坐标
scatter(xScatter2, yScatter2, 25, 'filled');  % 绘制散点图

% 子图 4：测试数据散点图（若不存在 test.mat，则生成随机数据）
subplot(2,2,4);                % 选择第 4 个区域
if exist('test.mat','file')     % 检查是否存在 test.mat 文件
    load test.mat;             % 若存在则加载数据（变量 test 为 Nx2 数组）
else
    test = [randn(150,1), randn(150,1)];  % 否则生成 150 个随机二维数据点
end
scatter(test(:,1), test(:,2), 'filled');  % 绘制测试数据散点图

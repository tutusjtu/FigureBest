%% 清理工作区和图形
close all;  % 关闭所有已打开的图形窗口

%% 1. 单张折线图（多条曲线版本）
figure;                          % 新建图形窗口
x = linspace(0, 10, 200);          % 生成 0 到 10 之间的 200 个均匀数据点
% 生成多条曲线数据（每条曲线均加入微小随机噪声，并且有相互位移）
y1 = sin(x) + 0.1 * randn(size(x));       % 第一条曲线：sin(x) + 噪声
y2 = sin(x + 0.5) + 0.1 * randn(size(x));   % 第二条曲线：sin(x+0.5) + 噪声
y3 = cos(x) + 0.1 * randn(size(x));         % 第三条曲线：cos(x) + 噪声
y4 = cos(x + 0.5) + 0.1 * randn(size(x));     % 第四条曲线：cos(x+0.5) + 噪声
% 绘制所有曲线，分别采用不同的线型和标记，线宽为 1.5
plot(x, y1, '-o', x, y2, '-s', x, y3, '-d', x, y4, '-^', 'LineWidth', 1.5);
% 此图中同时显示 4 条曲线

%% 2. 2×2 子图组合
figure;                         % 新建图形窗口

% 子图 1：多条折线图（正弦曲线系列）
subplot(2,2,1);                 % 将窗口分为 2 行 2 列，选择第 1 个子图区域
t = linspace(0, 2*pi, 100);       % 生成 0 到 2π 的 100 个均匀数据点
% 绘制两条正弦曲线：原始曲线与相位平移后的曲线
plot(t, sin(t), 'b-', 'LineWidth', 1.5);
hold on;                        % 保持当前图形，便于叠加后续曲线
plot(t, sin(t + 0.3), 'r--', 'LineWidth', 1.5);
hold off;                       % 结束叠加

% 子图 2：条形图（多系列柱状图）
subplot(2,2,2);                 % 选择第 2 个子图区域
dataBar = randi([1,20], 4, 3);    % 生成 4×3 的随机整数矩阵（4组，每组 3 个系列）
bar(dataBar);                   % 绘制条形图，自动显示各系列数据

% 子图 3：散点图（两组二维正态分布数据）
subplot(2,2,3);                 % 选择第 3 个子图区域
data1 = randn(50,2) + 1;          % 生成第一组 50 个二维正态分布数据，并整体向右上平移
data2 = randn(50,2) - 1;          % 生成第二组 50 个二维正态分布数据，并整体向左下平移
scatter(data1(:,1), data1(:,2), 36, 'b', 'filled');  % 绘制第一组散点（蓝色）
hold on;                        % 保持当前图形
scatter(data2(:,1), data2(:,2), 36, 'r', 'filled');  % 绘制第二组散点（红色）
hold off;                       % 结束叠加

% 子图 4：Stem 图（显示两组离散数据）
subplot(2,2,4);                 % 选择第 4 个子图区域
xStem = linspace(0, 10, 20);      % 生成 20 个均匀数据点
stem(xStem, cos(xStem), 'b', 'filled');    % 绘制第一组 Stem 图（蓝色余弦数据）
hold on;                        % 保持当前图形
stem(xStem, cos(xStem + 0.5), 'r', 'filled');% 绘制第二组 Stem 图（红色，平移 0.5）
hold off;                       % 结束叠加

%% 3. 4×4 子图组合
figure;                          % 新建图形窗口

% 子图 1：多条折线图（正弦系列）
subplot(4,4,[1 2]);                % 合并第 1 和第 2 个区域
t = linspace(0, 2*pi, 200);       % 生成 0 到 2π 的 200 个数据点
plot(t, sin(t), 'b-', 'LineWidth', 1.5);   % 绘制 sin(t)
hold on;
plot(t, sin(t + 0.5), 'r--', 'LineWidth', 1.5); % 绘制 sin(t+0.5)
plot(t, sin(t + 1), 'g-.', 'LineWidth', 1.5);   % 绘制 sin(t+1)
hold off;

% 子图 3：多系列条形图
subplot(4,4,3);                % 选择第 3 个区域
data = randi([1,10], 5, 3);      % 生成 5×3 的随机整数矩阵（5组，每组 3 个系列）
bar(data);                     % 绘制条形图

% 子图 4：多系列散点图
subplot(4,4,4);                % 选择第 4 个区域
x1 = randn(30,1) + 1;            % 第一组 x 数据
y1 = randn(30,1) + 1;            % 第一组 y 数据
x2 = randn(30,1) - 1;            % 第二组 x 数据
y2 = randn(30,1) - 1;            % 第二组 y 数据
scatter(x1, y1, 36, 'b', 'filled');  % 绘制第一组散点
hold on;
scatter(x2, y2, 36, 'r', 'filled');  % 绘制第二组散点
hold off;

% 子图 5：多系列 Stem 图（指数衰减系列）
subplot(4,4,5);                % 选择第 5 个区域
x_stem = linspace(0, 10, 20);     % 生成 20 个均匀数据点
stem(x_stem, exp(-0.2 * x_stem), 'b', 'filled');  % 绘制第一组 Stem 图（蓝色指数衰减）
hold on;
stem(x_stem, exp(-0.2 * x_stem) * 1.2, 'r', 'filled');  % 绘制第二组 Stem 图（红色）
hold off;

% 子图 6：误差棒图（两组数据）
subplot(4,4,6);                % 选择第 6 个区域
x_err = linspace(0, 10, 20);      % 生成 20 个数据点
y_err1 = sin(x_err);            % 第一组数据：sin(x)
y_err2 = sin(x_err + 0.3);        % 第二组数据：sin(x+0.3)
err1 = 0.2 * rand(1,20);           % 第一组误差
err2 = 0.2 * rand(1,20);           % 第二组误差
errorbar(x_err, y_err1, err1, 'b-o', 'LineWidth', 1.5);  % 绘制第一组误差棒图
hold on;
errorbar(x_err, y_err2, err2, 'r-s', 'LineWidth', 1.5);  % 绘制第二组误差棒图
hold off;

% 子图 7：叠加直方图（两组正态分布数据）
subplot(4,4,[7 8]);                % 合并第 7 和第 8 个区域
data_hist1 = randn(1000,1);       % 第一组正态分布数据
data_hist2 = randn(1000,1) + 1;   % 第二组正态分布数据（均值平移）
histogram(data_hist1, 'Normalization', 'pdf', 'EdgeColor', 'none');  % 绘制第一组直方图
hold on;
histogram(data_hist2, 'Normalization', 'pdf', 'EdgeColor', 'none');  % 绘制第二组直方图
hold off;

% 子图 9：热图（imagesc 显示 peaks 数据）
subplot(4,4,9);                % 选择第 9 个区域
img = peaks(20);               % 生成 20×20 的 peaks 数据（数据平滑且有规律）
imagesc(img);                  % 用 imagesc 显示热图

% 子图 10：面积图（多系列面积图）
subplot(4,4,10);               % 选择第 10 个区域
area_data = [sin(t); cos(t)]';  % 构造一个 2 列面积数据（每列为一系列）
area(area_data);               % 绘制面积图

% 子图 11：多条折线图（指数增长系列）
subplot(4,4,11);               % 选择第 11 个区域
plot(t, exp(0.1 * t), 'b-', 'LineWidth', 1.5);  % 绘制指数增长曲线
hold on;
plot(t, exp(0.1 * t) * 1.1, 'r--', 'LineWidth', 1.5);  % 绘制平移后的指数曲线
plot(t, exp(0.1 * t) * 0.9, 'g-.', 'LineWidth', 1.5);   % 绘制另一条略缩小的曲线
hold off;

% 子图 12：多系列散点图（两组随机数据）
subplot(4,4,12);               % 选择第 12 个区域
x_sc1 = randn(40,1);           % 第一组 x 数据
y_sc1 = randn(40,1);           % 第一组 y 数据
x_sc2 = randn(40,1) + 2;       % 第二组 x 数据（整体平移）
y_sc2 = randn(40,1) + 2;       % 第二组 y 数据（整体平移）
scatter(x_sc1, y_sc1, 36, 'b', 'filled');  % 绘制第一组散点
hold on;
scatter(x_sc2, y_sc2, 36, 'r', 'filled');  % 绘制第二组散点
hold off;

% 子图 13：多条折线图（对数函数系列）
subplot(4,4,13);               % 选择第 13 个区域
plot(t, log(1+t), 'b-', 'LineWidth', 1.5);  % 绘制 log(1+t)
hold on;
plot(t, log(1+t) * 1.2, 'r--', 'LineWidth', 1.5);  % 绘制放大后的对数曲线
plot(t, log(1+t) * 0.8, 'g-.', 'LineWidth', 1.5);   % 绘制缩小后的对数曲线
hold off;

% 子图 14：误差棒图（另一组两系列）
subplot(4,4,14);               % 选择第 14 个区域
x_err2 = linspace(0, 10, 20);       % 生成 20 个数据点
y_err_a = cos(x_err2);         % 第一组数据：cos(x)
y_err_b = cos(x_err2 + 0.5);     % 第二组数据：cos(x+0.5)
err_a = 0.3 * rand(1,20);          % 第一组误差
err_b = 0.3 * rand(1,20);          % 第二组误差
errorbar(x_err2, y_err_a, err_a, 'b-o', 'LineWidth', 1.5);  % 绘制第一组误差棒图
hold on;
errorbar(x_err2, y_err_b, err_b, 'r-s', 'LineWidth', 1.5);  % 绘制第二组误差棒图
hold off;

% 子图 15-16：阶梯图（两组随机整数数据）
subplot(4,4,[15 16]);               % 合并选择第 15 和 16 个区域
x_stairs = linspace(0, 10, 20);    % 生成 20 个均匀数据点
stairs(x_stairs, randi([1,10], 1, 20), 'b');  % 绘制第一组阶梯图（蓝色）
hold on;
stairs(x_stairs, randi([1,10], 1, 20), 'r');  % 绘制第二组阶梯图（红色）
hold off;

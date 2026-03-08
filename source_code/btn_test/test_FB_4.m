%% 清理工作区和图形
close all;  % 关闭所有已打开的图形窗口

%% 
figure
t = tiledlayout(2,2, 'TileSpacing', 'none', 'Padding', 'none');

% Tile 1
nexttile
plot(rand(1,20))
xlabel('Value');
ylabel('Value');

% Tile 2
nexttile
plot(rand(1,20))
xlabel('Value');
ylabel('Value');

% Tile 3
nexttile
plot(rand(1,20))
xlabel('Value');
ylabel('Value');

% Tile 4
nexttile
plot(rand(1,20))
xlabel('Value');
ylabel('Value');

%% 图表和热力图对象 (已移除外部文件依赖，使用模拟数据)
figure
% ---------- 模拟生成 patients 数据集 ----------
N = 100; % 模拟 100 个病人的数据
Diastolic = round(80 + 10 * randn(N, 1)); % 舒张压 (正态分布均值80)
Systolic = round(120 + 15 * randn(N, 1)); % 收缩压 (正态分布均值120)
Height = round(65 + 5 * randn(N, 1));     % 身高
Weight = round(150 + 20 * randn(N, 1));   % 体重
Smoker = logical(randi([0, 1], N, 1));    % 吸烟情况 (逻辑值 0 或 1)

% 模拟健康状态 (分类数组)
health_options = {'Excellent', 'Good', 'Fair', 'Poor'};
SelfAssessedHealthStatus = categorical(health_options(randi(4, N, 1)))';
% ----------------------------------------------

tbl = table(Diastolic,Smoker,Systolic,Height,Weight,SelfAssessedHealthStatus);
tiledlayout(2,2)

% Scatter plot
nexttile
scatter(tbl.Height,tbl.Weight)

% Heatmap
nexttile
heatmap(tbl,'Smoker','SelfAssessedHealthStatus','Title','Smoker''s Health');

% Stacked plot
nexttile([1 2])
stackedplot(tbl,{'Systolic','Diastolic'});


%% 创建图窗和竖直排列的布局 (5行1列)
figure;
t = tiledlayout(5, 1, 'TileSpacing', 'compact', 'Padding', 'normal');

% 生成共用数据（用于前四个曲线图）
x_common = linspace(0, 2*pi, 30);
y_sin = sin(x_common);
y_cos = cos(x_common);

%% 子图1: 普通折线图 (plot)
nexttile;
plot(x_common, y_sin, 'r-', 'LineWidth', 1.5); hold on;
plot(x_common, y_cos, 'b--', 'LineWidth', 1.5);
ylabel('Amplitude');
legend('sin', 'cos', 'Location', 'best');
grid on;
set(gca, 'XTickLabel', []);  % 隐藏x轴刻度标签（由最后一个子图显示）

%% 子图2: 函数绘图 (fplot)
nexttile;
fplot(@(x) exp(-0.3*x) .* sin(2*x), [0, 8], 'g-', 'LineWidth', 1.5);
ylabel('f(x)');
grid on;
set(gca, 'XTickLabel', []);

%% 子图3: 茎秆图 (stem)
nexttile;
x_stem = 0:2:20;
y_stem = randn(size(x_stem)) .* exp(-0.1*x_stem) + 1;
stem(x_stem, y_stem, 'filled', 'MarkerFaceColor', [0.8 0.4 0.2], ...
     'LineStyle', ':', 'Color', [0.5 0.5 0.5]);
ylabel('Amplitude');
grid on;
set(gca, 'XTickLabel', []);

%% 子图4: 阶梯图 (stairs)
nexttile;
x_stairs = 0:0.5:10;
y_stairs = cumsum(randn(size(x_stairs)));  % random walk
stairs(x_stairs, y_stairs, 'm-', 'LineWidth', 1.2);
ylabel('Cumulative value');
grid on;
set(gca, 'XTickLabel', []);  % 隐藏标签，但保留刻度线

%% 子图5: 分组条形图 (bar) - 三个系列
nexttile;
% 数据：4个类别 × 3个系列
categories = {'Category A', 'Category B', 'Category C', 'Category D'};
series1 = [25, 40, 30, 35];
series2 = [18, 32, 28, 42];
series3 = [22, 38, 35, 30];
data = [series1; series2; series3]';  % 4行3列

b = bar(data, 'grouped');
b(1).FaceColor = [0.2 0.6 0.8];
b(2).FaceColor = [0.8 0.4 0.2];
b(3).FaceColor = [0.3 0.7 0.3];
ylabel('Value');
xlabel('Category');  % 最后一个子图显示x轴标签
set(gca, 'XTickLabel', categories);

legend('Series 1', 'Series 2', 'Series 3', 'Location', 'northwest');
grid on;
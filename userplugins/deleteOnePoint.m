function deleteOnePoint(figureNumbers, axesNumbers, ~)
% DELETEONEPOINT 删除某个点（来自 plot 函数绘制）
%
%   deleteOnePoint(figureNumbers, axesNumbers, ~)
%
% 示例:
%   figureNumbers = 1;
%   axesNumbers = 1;
%   deleteOnePoint(figureNumbers, axesNumbers, []);

% 找到目标 figure
figNum = figureNumbers(1);
hFig = findobj('Type', 'figure', 'Number', figNum);
if isempty(hFig)
    disp('Figure不存在!');
    return;
end

% 获取 figure 内所有 axes
axesList = findobj(hFig, 'Type', 'axes');
if isempty(axesNumbers)
    axesNumbers = 1;
end
axesH = axesList(axesNumbers(1));
axes(axesH);  % 设置目标 axes 为当前 axes

% 保存并禁用 figure 的鼠标回调及 HitTest 属性
origFigWBDFcn = get(hFig, 'WindowButtonDownFcn');
set(hFig, 'WindowButtonDownFcn', '');
origFigWBMFunc = get(hFig, 'WindowButtonMotionFcn');
set(hFig, 'WindowButtonMotionFcn', '');
origFigHitTest = get(hFig, 'HitTest');
set(hFig, 'HitTest', 'off');

% 保存并禁用 axes 内所有子对象的 HitTest 和 ButtonDownFcn
children = get(axesH, 'Children');
origChildHitTest = cell(size(children));
origChildBDFC = cell(size(children));
for i = 1:length(children)
    origChildHitTest{i} = get(children(i), 'HitTest');
    set(children(i), 'HitTest', 'off');
    origChildBDFC{i} = get(children(i), 'ButtonDownFcn');
    set(children(i), 'ButtonDownFcn', '');
end

% 强制刷新界面，确保设置生效
drawnow;

% 使用 waitforbuttonpress 捕获点击，并获取当前点
disp('请点击选取一个点...');
waitforbuttonpress;   % 等待鼠标点击或键盘按下
cp = get(axesH, 'CurrentPoint');
cp = cp(1,1:2);

% 恢复 figure 及子对象的原有属性
set(hFig, 'WindowButtonDownFcn', origFigWBDFcn);
set(hFig, 'WindowButtonMotionFcn', origFigWBMFunc);
set(hFig, 'HitTest', origFigHitTest);
for i = 1:length(children)
    set(children(i), 'HitTest', origChildHitTest{i});
    set(children(i), 'ButtonDownFcn', origChildBDFC{i});
end

% 获取 axes 坐标范围
minx = axesH.XLim(1);
maxx = axesH.XLim(2);
miny = axesH.YLim(1);
maxy = axesH.YLim(2);

% 将点击点归一化到坐标轴范围内
cp(1) = (cp(1) - minx) / (maxx - minx);
cp(2) = (cp(2) - miny) / (maxy - miny);

% 查找目标 axes 中所有 line 对象
lines = findobj(axesH, 'Type', 'line');
xy_flag_order_dist = []; % 每行格式：[x, y, line索引, 数据点序号, 距离^2]
for i = 1:length(lines)
    % 归一化 line 数据
    x = (lines(i).XData' - minx) / (maxx - minx);
    y = (lines(i).YData' - miny) / (maxy - miny);
    flag = repmat(i, length(x), 1);
    order = (1:length(x))';
    dist = (x - cp(1)).^2 + (y - cp(2)).^2;
    xy_flag_order_dist = [xy_flag_order_dist; [x, y, flag, order, dist]];
end

% 找到与点击点最近的数据点
[~, index] = min(xy_flag_order_dist(:, 5));
target_flag = xy_flag_order_dist(index, 3);
target_order = xy_flag_order_dist(index, 4);

% 删除捕捉到的点
lines(target_flag).XData = [lines(target_flag).XData(1:target_order-1), ...
    lines(target_flag).XData(target_order+1:end)];
lines(target_flag).YData = [lines(target_flag).YData(1:target_order-1), ...
    lines(target_flag).YData(target_order+1:end)];

disp('删除完成!');
end

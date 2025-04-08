function addOnePoint(figureNumbers, axesNumbers, ~)
% 增加一个点（来自 plot 函数绘制）
%
% 示例:
%   figureNumbers = 1;
%   axesNumbers = 1;
%   addOnePoint(figureNumbers, axesNumbers, []);
%
% 说明：
% 根据鼠标点击的点，寻找与点击点最近的数据点，然后在该点附近插入一个新点。

% 找到目标坐标轴
figureNum = figureNumbers(1);
hFig = findobj('Type', 'figure', 'Number', figureNum);
axesList = findobj(figureNum, 'Type', 'axes');

if isempty(axesNumbers)
    axesNumbers = 1;
end

axesH = axesList(axesNumbers(1));
axes(axesH);

minx = axesH.XLim(1);
maxx = axesH.XLim(2);
miny = axesH.YLim(1);
maxy = axesH.YLim(2);

% 获取鼠标点击的点（用 waitforbuttonpress 替换 ginput）
disp('请点击选取一个点...');
waitforbuttonpress;
cp = get(axesH, 'CurrentPoint');
cp = cp(1, 1:2);
tempcp = cp;

cp(1) = (cp(1)-minx)/(maxx-minx);
cp(2) = (cp(2)-miny)/(maxy-miny);

% 判断与点击点最近的点
lines = findobj(axesH, 'Type', 'line');
xy_flag_order_dist = []; % 每行：[x, y, line索引, 数据点序号, 距离^2]
for i = 1:length(lines)
    x = (lines(i).XData' - minx) / (maxx - minx);
    y = (lines(i).YData' - miny) / (maxy - miny);
    flag = zeros(length(x), 1) + i;
    order = (1:length(x))';
    dist = (x - cp(1)).^2 + (y - cp(2)).^2;
    xy_flag_order_dist = [xy_flag_order_dist; x y flag order dist];
end

[~, index] = min(xy_flag_order_dist(:,5));
target_flag = xy_flag_order_dist(index, 3);
target_order = xy_flag_order_dist(index, 4);

% 增加捕捉到的点（在目标点右侧插入新点）
lines(target_flag).XData = [lines(target_flag).XData(1:target_order) tempcp(1) lines(target_flag).XData(target_order+1:end)];
lines(target_flag).YData = [lines(target_flag).YData(1:target_order) tempcp(2) lines(target_flag).YData(target_order+1:end)];
disp('添加完成!');
end

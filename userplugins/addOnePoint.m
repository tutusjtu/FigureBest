function addOnePoint(figureNumbers, axesNumbers, ~)
% ����һ���㣨���� plot �������ƣ�
%
% ʾ��:
%   figureNumbers = 1;
%   axesNumbers = 1;
%   addOnePoint(figureNumbers, axesNumbers, []);
%
% ˵����
% ����������ĵ㣬Ѱ����������������ݵ㣬Ȼ���ڸõ㸽������һ���µ㡣

% �ҵ�Ŀ��������
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

% ��ȡ������ĵ㣨�� waitforbuttonpress �滻 ginput��
disp('����ѡȡһ����...');
waitforbuttonpress;
cp = get(axesH, 'CurrentPoint');
cp = cp(1, 1:2);
tempcp = cp;

cp(1) = (cp(1)-minx)/(maxx-minx);
cp(2) = (cp(2)-miny)/(maxy-miny);

% �ж�����������ĵ�
lines = findobj(axesH, 'Type', 'line');
xy_flag_order_dist = []; % ÿ�У�[x, y, line����, ���ݵ����, ����^2]
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

% ���Ӳ�׽���ĵ㣨��Ŀ����Ҳ�����µ㣩
lines(target_flag).XData = [lines(target_flag).XData(1:target_order) tempcp(1) lines(target_flag).XData(target_order+1:end)];
lines(target_flag).YData = [lines(target_flag).YData(1:target_order) tempcp(2) lines(target_flag).YData(target_order+1:end)];
disp('������!');
end

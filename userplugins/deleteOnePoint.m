function deleteOnePoint(figureNumbers, axesNumbers, ~)
% DELETEONEPOINT ɾ��ĳ���㣨���� plot �������ƣ�
%
%   deleteOnePoint(figureNumbers, axesNumbers, ~)
%
% ʾ��:
%   figureNumbers = 1;
%   axesNumbers = 1;
%   deleteOnePoint(figureNumbers, axesNumbers, []);

% �ҵ�Ŀ�� figure
figNum = figureNumbers(1);
hFig = findobj('Type', 'figure', 'Number', figNum);
if isempty(hFig)
    disp('Figure������!');
    return;
end

% ��ȡ figure ������ axes
axesList = findobj(hFig, 'Type', 'axes');
if isempty(axesNumbers)
    axesNumbers = 1;
end
axesH = axesList(axesNumbers(1));
axes(axesH);  % ����Ŀ�� axes Ϊ��ǰ axes

% ���沢���� figure �����ص��� HitTest ����
origFigWBDFcn = get(hFig, 'WindowButtonDownFcn');
set(hFig, 'WindowButtonDownFcn', '');
origFigWBMFunc = get(hFig, 'WindowButtonMotionFcn');
set(hFig, 'WindowButtonMotionFcn', '');
origFigHitTest = get(hFig, 'HitTest');
set(hFig, 'HitTest', 'off');

% ���沢���� axes �������Ӷ���� HitTest �� ButtonDownFcn
children = get(axesH, 'Children');
origChildHitTest = cell(size(children));
origChildBDFC = cell(size(children));
for i = 1:length(children)
    origChildHitTest{i} = get(children(i), 'HitTest');
    set(children(i), 'HitTest', 'off');
    origChildBDFC{i} = get(children(i), 'ButtonDownFcn');
    set(children(i), 'ButtonDownFcn', '');
end

% ǿ��ˢ�½��棬ȷ��������Ч
drawnow;

% ʹ�� waitforbuttonpress ������������ȡ��ǰ��
disp('����ѡȡһ����...');
waitforbuttonpress;   % �ȴ����������̰���
cp = get(axesH, 'CurrentPoint');
cp = cp(1,1:2);

% �ָ� figure ���Ӷ����ԭ������
set(hFig, 'WindowButtonDownFcn', origFigWBDFcn);
set(hFig, 'WindowButtonMotionFcn', origFigWBMFunc);
set(hFig, 'HitTest', origFigHitTest);
for i = 1:length(children)
    set(children(i), 'HitTest', origChildHitTest{i});
    set(children(i), 'ButtonDownFcn', origChildBDFC{i});
end

% ��ȡ axes ���귶Χ
minx = axesH.XLim(1);
maxx = axesH.XLim(2);
miny = axesH.YLim(1);
maxy = axesH.YLim(2);

% ��������һ���������᷶Χ��
cp(1) = (cp(1) - minx) / (maxx - minx);
cp(2) = (cp(2) - miny) / (maxy - miny);

% ����Ŀ�� axes ������ line ����
lines = findobj(axesH, 'Type', 'line');
xy_flag_order_dist = []; % ÿ�и�ʽ��[x, y, line����, ���ݵ����, ����^2]
for i = 1:length(lines)
    % ��һ�� line ����
    x = (lines(i).XData' - minx) / (maxx - minx);
    y = (lines(i).YData' - miny) / (maxy - miny);
    flag = repmat(i, length(x), 1);
    order = (1:length(x))';
    dist = (x - cp(1)).^2 + (y - cp(2)).^2;
    xy_flag_order_dist = [xy_flag_order_dist; [x, y, flag, order, dist]];
end

% �ҵ���������������ݵ�
[~, index] = min(xy_flag_order_dist(:, 5));
target_flag = xy_flag_order_dist(index, 3);
target_order = xy_flag_order_dist(index, 4);

% ɾ����׽���ĵ�
lines(target_flag).XData = [lines(target_flag).XData(1:target_order-1), ...
    lines(target_flag).XData(target_order+1:end)];
lines(target_flag).YData = [lines(target_flag).YData(1:target_order-1), ...
    lines(target_flag).YData(target_order+1:end)];

disp('ɾ�����!');
end

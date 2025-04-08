classdef ColorTemplateHelper 
    methods(Static)
        function processColorTemplate(handles)
            global handlesforusercolor
            %【第一部分】提取颜色信息并排序
            [sortedChildren, defaultNameParts, colorInfoLines, defaultSelections] = ...
                ColorTemplateHelper.extractColorData(handles);
            
            %【第二部分】创建对话框和相关界面组件（采用相对坐标，优化了布局和颜色）
            myData = ColorTemplateHelper.createDialogUI(handles, sortedChildren, defaultNameParts, colorInfoLines, defaultSelections);
            
            %【第三部分】通过状态循环处理多页面切换及色块显示更新
            myData = ColorTemplateHelper.handleUIState(myData);
            
            %【第四部分】若用户点击保存，则写入配色模板文件，并更新 listBox 显示
            if myData.isSaved
                ColorTemplateHelper.saveColorTemplate(myData);
                [handles.yanselist, handles.UserColor] = ColorTemplateHelper.reloadTemplates(handles);
            end
            
            % 更新 handles 到图形界面（假设 handles.figure1 为主界面句柄）
            guidata(handles.figure1, handles);
        end
        
        function [sortedChildren, defaultNameParts, colorInfoLines, defaultSelections] = extractColorData(handles)
            % 提取所有颜色块，并按其 x 坐标升序排序
            children = handles.colorbox.Children;
            numChildren = length(children);
            xCoordinates = zeros(numChildren,1);
            for i = 1:numChildren
                pos = get(children(i), 'Position');  % [x, y, width, height]
                xCoordinates(i) = pos(1);
            end
            [~, sortIdx] = sort(xCoordinates, 'ascend');
            sortedChildren = children(sortIdx);
            
            % 为每个颜色生成中文名称、详细描述及默认选中状态
            defaultNameParts = cell(1, numChildren);
            colorInfoLines   = cell(1, numChildren);
            defaultSelections = false(1, numChildren);
            baseColor = handles.colorbox.BackgroundColor;
            for i = 1:numChildren
                childColor = sortedChildren(i).BackgroundColor;
                % 假设 getChineseColorName 为外部已实现函数
                cname = getChineseColorName(childColor);
                defaultNameParts{i} = cname;
                rgb255 = round(childColor * 255);
                colorInfoLines{i} = sprintf('颜色%d: %s  [RGB: %d %d %d]', i, cname, ...
                                            rgb255(1), rgb255(2), rgb255(3));
                defaultSelections(i) = ~isequal(childColor, baseColor);
            end
        end
        
        function myData = createDialogUI(handles, sortedChildren, defaultNameParts, colorInfoLines, defaultSelections)
            %% === 基础设置：字体、颜色及尺寸 ===
            defaultFont      = 'Microsoft YaHei';
            defaultFontSize  = 11;  
            dialogBgColor    = [255   199    53]/255;  % #F8B551，金黄色
            btnBgColor       = [51   102   153]/255;  % 稍深一点的橙色系
            checkboxSelColor = dialogBgColor; % 
            checkboxDefColor = dialogBgColor;     % 复选框未选中时与背景相同
            
            % 面板与按钮的尺寸参数
            modernBtnWidth  = 0.25;
            modernBtnHeight = 0.12;
            bottomMargin    = 0.05;
            
            % 对话框整体大小
            dWidth = 0.5;
            dHeight = 0.4;
            
            d = dialog('Units','normalized',...
                'Position',[0.5 - dWidth/2, 0.5 - dHeight/2, dWidth, dHeight], ...
                'Name','保存颜色模板', ...
                'Resize','on',...
                'Color', dialogBgColor);
            
            %% === “选择”页面面板（背景同对话框）===
            pSelect = uipanel('Parent', d, ...
                'Units', 'normalized', ...
                'Position', [0, 0, 1, 1], ...
                'BorderType','none',...
                'BackgroundColor', dialogBgColor);
            
            % 在选择页面内，再创建一个子面板 pGrid，用于放置 5 行的预览/复选框/R/G/B 信息
            pGrid = uipanel('Parent', pSelect, ...
                'Units','normalized', ...
                'Position',[0.05, 0.25, 0.9, 0.65], ...
                'BackgroundColor', dialogBgColor, ...
                'BorderType','line', ...
                'Title','颜色选择', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'TitlePosition','centertop');
            
            % 行列布局参数（相对 pGrid 的坐标）
            rowHeight = 0.15;
            rowYPositions = linspace(0.8, 0.15, 5);  
            labelColWidth = 0.08;    
            squareWidth   = 0.05;     
            gap           = 0.003;    
            
            numChildren = length(sortedChildren);
            totalWidth  = labelColWidth + numChildren*squareWidth + (numChildren-1)*gap;
            offsetX     = max(0, (1 - totalWidth)/2);
            
            %% === 第一行：预览标题及颜色方块 ===
            uicontrol('Parent', pGrid, 'Style', 'text', ...
                'Units','normalized', ...
                'Position',[offsetX, rowYPositions(1)-rowHeight*0.15, labelColWidth, rowHeight], ...
                'String','预览', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold', ...
                'BackgroundColor', dialogBgColor, ...
                'HorizontalAlignment','center', ...
                'TooltipString', '显示颜色块预览');
            
            colorSquareHandles = gobjects(numChildren,1);
            for i = 1:numChildren
                xPos = offsetX + labelColWidth + (i-1)*(squareWidth + gap);
                colorSquareHandles(i) = uicontrol('Parent', pGrid, ...
                    'Style','text', ...
                    'Units','normalized', ...
                    'Position',[xPos, rowYPositions(1), squareWidth, rowHeight], ...
                    'BackgroundColor', sortedChildren(i).BackgroundColor, ...
                    'ForegroundColor',[0 0 0],...
                    'FontName', defaultFont, ...
                    'FontSize', defaultFontSize, ...
                    'HorizontalAlignment','center', ...
                    'TooltipString', ...
                    sprintf('%s\n(RGB:%s)', defaultNameParts{i}, ...
                            mat2str(round(sortedChildren(i).BackgroundColor*255))));
            end
            
            %% === 第二行：勾选标题及复选框 ===
            uicontrol('Parent', pGrid, 'Style', 'text', ...
                'Units','normalized', ...
                'Position',[offsetX, rowYPositions(2)-rowHeight*0.24, labelColWidth, rowHeight], ...
                'String','', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold', ...
                'BackgroundColor', dialogBgColor, ...
                'HorizontalAlignment','center', ...
                'TooltipString', '选择需要保存的颜色块');
            
            checkboxHandles = gobjects(numChildren,1);
            for i = 1:numChildren
                xPos = offsetX + labelColWidth + (i-1)*(squareWidth + gap);
                initBgColor = checkboxDefColor;
                if defaultSelections(i)
                    initBgColor = checkboxSelColor;
                end
                checkboxHandles(i) = uicontrol('Parent', pGrid, ...
                    'Style','checkbox', ...
                    'Units','normalized', ...
                    'Position',[xPos+squareWidth/4.1, rowYPositions(2), squareWidth, rowHeight], ...
                    'Value', defaultSelections(i), ...
                    'BackgroundColor', initBgColor, ...
                    'FontName', defaultFont, ...
                    'FontSize', defaultFontSize - 1, ...
                    'Callback',[...
                    'if get(gco,''Value''),'...
                    ' set(gco,''BackgroundColor'',[255   199    53]/255);'...
                    'else,'...
                    ' set(gco,''BackgroundColor'',[255   199    53]/255);'...
                    'end;' ], ...
                    'TooltipString', '点击勾选或取消此颜色块');
            end
            
            %% === 第三行：显示 R 值 ===
            uicontrol('Parent', pGrid, 'Style', 'text', ...
                'Units','normalized', ...
                'Position',[offsetX, rowYPositions(3), labelColWidth, rowHeight], ...
                'String','R', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold', ...
                'BackgroundColor', dialogBgColor, ...
                'HorizontalAlignment','center', ...
                'TooltipString', '红色通道 (R)');
            
            rHandles = gobjects(numChildren,1);
            for i = 1:numChildren
                xPos = offsetX + labelColWidth + (i-1)*(squareWidth + gap);
                rgb255 = round(sortedChildren(i).BackgroundColor * 255);
                rVal = num2str(rgb255(1));
                rHandles(i) = uicontrol('Parent', pGrid, ...
                    'Style','text', ...
                    'Units','normalized', ...
                    'Position',[xPos, rowYPositions(3), squareWidth, rowHeight], ...
                    'String', rVal, ...
                    'FontName', defaultFont, ...
                    'FontSize', defaultFontSize, ...
                    'BackgroundColor', dialogBgColor, ...
                    'HorizontalAlignment','center', ...
                    'TooltipString', ['红色分量：', rVal]);
            end
            
            %% === 第四行：显示 G 值 ===
            uicontrol('Parent', pGrid, 'Style', 'text', ...
                'Units','normalized', ...
                'Position',[offsetX, rowYPositions(4), labelColWidth, rowHeight], ...
                'String','G', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold', ...
                'BackgroundColor', dialogBgColor, ...
                'HorizontalAlignment','center', ...
                'TooltipString', '绿色通道 (G)');
            
            gHandles = gobjects(numChildren,1);
            for i = 1:numChildren
                xPos = offsetX + labelColWidth + (i-1)*(squareWidth + gap);
                rgb255 = round(sortedChildren(i).BackgroundColor * 255);
                gVal = num2str(rgb255(2));
                gHandles(i) = uicontrol('Parent', pGrid, ...
                    'Style','text', ...
                    'Units','normalized', ...
                    'Position',[xPos, rowYPositions(4), squareWidth, rowHeight], ...
                    'String', gVal, ...
                    'FontName', defaultFont, ...
                    'FontSize', defaultFontSize, ...
                    'BackgroundColor', dialogBgColor, ...
                    'HorizontalAlignment','center', ...
                    'TooltipString', ['绿色分量：', gVal]);
            end
            
            %% === 第五行：显示 B 值 ===
            uicontrol('Parent', pGrid, 'Style', 'text', ...
                'Units','normalized', ...
                'Position',[offsetX, rowYPositions(5), labelColWidth, rowHeight], ...
                'String','B', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold', ...
                'BackgroundColor', dialogBgColor, ...
                'HorizontalAlignment','center', ...
                'TooltipString', '蓝色通道 (B)');
            
            bHandles = gobjects(numChildren,1);
            for i = 1:numChildren
                xPos = offsetX + labelColWidth + (i-1)*(squareWidth + gap);
                rgb255 = round(sortedChildren(i).BackgroundColor * 255);
                bVal = num2str(rgb255(3));
                bHandles(i) = uicontrol('Parent', pGrid, ...
                    'Style','text', ...
                    'Units','normalized', ...
                    'Position',[xPos, rowYPositions(5), squareWidth, rowHeight], ...
                    'String', bVal, ...
                    'FontName', defaultFont, ...
                    'FontSize', defaultFontSize, ...
                    'BackgroundColor', dialogBgColor, ...
                    'HorizontalAlignment','center', ...
                    'TooltipString', ['蓝色分量：', bVal]);
            end
            
            %% === 底部：“下一步”按钮 ===
            nextBtnX = (1 - modernBtnWidth) / 2;
            btnNext = uicontrol('Parent', pSelect, ...
                'Style','pushbutton',...
                'String','下一步', ...
                'Units','normalized', ...
                'Position',[nextBtnX, bottomMargin, modernBtnWidth, modernBtnHeight], ...
                'BackgroundColor', btnBgColor, ...
                'ForegroundColor',[1 1 1], ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold',...
                'Callback', @(src, event) ColorTemplateHelper.nextStep(src), ...
                'TooltipString', '点击进入下一步，确认颜色选择');
            
            %% === “输入”页面面板（背景保持一致）===
            pInput = uipanel('Parent', d, ...
                'Units','normalized', ...
                'Position',[0, 0, 1, 1], ...
                'Visible','off', ...
                'BorderType','none', ...
                'BackgroundColor', dialogBgColor);
            
            % 在“输入”页面内再建一个白色面板 pInputBox，用于放置标题、编辑框、颜色预览
            pInputBox = uipanel('Parent', pInput, ...
                'Units','normalized', ...
                'Position',[0.05, 0.25, 0.9, 0.65], ...
                'BackgroundColor', dialogBgColor, ...
                'BorderType','line', ...
                'BorderType','line', ...
                'Title','在下方输入框中输入名称', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'TitlePosition','centertop');          
            
            % 编辑框（居中输入）
            hEdit = uicontrol('Parent', pInputBox, ...
                'Style','edit',...
                'String','', ...
                'Units','normalized', ...
                'Position',[0.05, 0.65, 0.9, 0.2], ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize+2, ...
                'FontWeight', 'bold', ...
                'HorizontalAlignment','center', ...
                'TooltipString', '在此输入模板名称');
            
            % 颜色显示区域（白色底）
            pColorDisplay = uipanel('Parent', pInputBox, ...
                'Units','normalized', ...
                'Position',[0.05, 0.05, 0.9, 0.55], ...
                'BackgroundColor', dialogBgColor, ...
                'BorderType','none');
            
            % 底部按钮：上一步 & 保存（左右布局）
            gapBetween = 0.1;
            sideMargin = (1 - (2*modernBtnWidth + gapBetween)) / 2;
            
            btnPrevious = uicontrol('Parent', pInput, ...
                'Style','pushbutton', ...
                'String','上一步', ...
                'Units','normalized', ...
                'Position',[sideMargin, bottomMargin, modernBtnWidth, modernBtnHeight], ...
                'BackgroundColor', btnBgColor, ...
                'ForegroundColor',[1 1 1], ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold',...
                'Callback', @(src, event) ColorTemplateHelper.previousStep(src), ...
                'TooltipString', '返回上一步修改颜色选择');
            
            btnSave = uicontrol('Parent', pInput, ...
                'Style','pushbutton', ...
                'String','保存', ...
                'Units','normalized', ...
                'Position',[sideMargin+modernBtnWidth+gapBetween, bottomMargin, modernBtnWidth, modernBtnHeight], ...
                'BackgroundColor', btnBgColor, ...
                'ForegroundColor',[1 1 1],...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold',...
                'Callback', @(src, event) ColorTemplateHelper.saveAndClose(src), ...
                'TooltipString', '保存当前配色模板并退出');
            
            
            % （在 function createDialogUI 内的 pInput 部分，btnPrevious、btnSave 定义之后）

            % === 新增一个 “逆序” 按钮，与“上一步”“保存”并排，位置可自行调整 ===
            btnReverse = uicontrol('Parent', pInputBox, ...
                'Style','pushbutton', ...
                'String','逆序', ...
                'Units','normalized', ...
                'Position',[0.05, 0.9, 0.05, 0.1], ... % 示例坐标，和btnPrevious/btnSave保持同高度
                'BackgroundColor',dialogBgColor, ...
                'ForegroundColor',[1 1 1], ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold',...
                'TooltipString','将已选颜色顺序倒转', ...
                'Callback', @(src, event) ColorTemplateHelper.reverseSelectedColors(src));

            
            %% === 将共享数据存入 myData 结构并保存对话框句柄 ===
            myData.checkboxHandles   = checkboxHandles;
            myData.defaultNameParts  = defaultNameParts;
            myData.hEdit             = hEdit;
            myData.state             = 'select';
            myData.isSaved           = false;
            myData.selectedIndices   = [];
            myData.sortedChildren    = sortedChildren;
            myData.colorInfoLines    = colorInfoLines;
            myData.pSelect           = pSelect;
            myData.btnNext           = btnNext;
            myData.pInput            = pInput;
            myData.pInputBox         = pInputBox;  % 新增：白色面板
            myData.pColorDisplay     = pColorDisplay;
            myData.needRegenColorBlocks = true;
            setappdata(d, 'myData', myData);
            
            myData.dialogHandle = d;
            setappdata(d, 'myData', myData);
        end
        
        function myData = handleUIState(myData)
            d = myData.dialogHandle;
            while true
                uiwait(d);
                if ~ishandle(d)
                    return;
                end
                myData = getappdata(d, 'myData');
                if strcmp(myData.state, 'input')
                    % 切换到输入页面，并更新已选色块显示
                    set(myData.pSelect,'Visible','off');
                    set(myData.btnNext,'Visible','off');
                    set(myData.pInput,'Visible','on');
                    myData = ColorTemplateHelper.updateColorDisplay(myData);
                    setappdata(d, 'myData', myData);
                elseif strcmp(myData.state, 'select')
                    % 切换回选择页面
                    set(myData.pInput,'Visible','off');
                    set(myData.pSelect,'Visible','on');
                    set(myData.btnNext,'Visible','on');
                elseif strcmp(myData.state, 'save')
                    break;
                end
            end
        end
        
        function myData = updateColorDisplay(myData)
            % 根据用户在选择页中选中的色块更新“输入”页面的颜色显示
            sel    = myData.selectedIndices;
            numSel = length(sel);
            
            gap         = 0.01;
            colCapacity = 15;  % 每行最多 15 个色块
            
            boxLeft  = myData.hEdit.Position(1);
            boxWidth = myData.hEdit.Position(3);
            patchWidth  = (boxWidth - (colCapacity-1)*gap) / colCapacity;
            patchHeight = patchWidth * 4;
            
            if colCapacity < 1
                colCapacity = 1;
            end
            
            needNewBlocks = myData.needRegenColorBlocks ...
                || ~isfield(myData,'colorBlockHandles') ...
                || (length(myData.colorBlockHandles) ~= numSel);
            
            if needNewBlocks
                delete(get(myData.pColorDisplay,'Children'));
                myData.colorBlockHandles = gobjects(numSel,1);
                for i = 1:numSel
                    rowIndex = floor((i-1)/colCapacity);
                    colIndex = mod(i-1, colCapacity);
                    
                    xPos = colIndex*(patchWidth + gap + boxLeft*2/14);
                    yPos = 1 - gap - patchHeight - rowIndex*(patchHeight + gap);
                    
                    myData.colorBlockHandles(i) = uicontrol('Parent', myData.pColorDisplay, ...
                        'Style','text','String','', ...
                        'Units','normalized', ...
                        'Position',[xPos, yPos, patchWidth, patchHeight], ...
                        'BackgroundColor', myData.sortedChildren(sel(i)).BackgroundColor, ...
                        'TooltipString', ...
                        sprintf('预览颜色：%s', myData.defaultNameParts{sel(i)}));
                end
                myData.needRegenColorBlocks = false;
            else
                % 只更新已有控件的位置
                for i = 1:numSel
                    rowIndex = floor((i-1)/colCapacity);
                    colIndex = mod(i-1, colCapacity);
                    
                    xPos = boxLeft + colIndex*(patchWidth + gap);
                    yPos = 1 - gap - patchHeight - rowIndex*(patchHeight + gap);
                    set(myData.colorBlockHandles(i), 'Position',[xPos, yPos, patchWidth, patchHeight]);
                end
            end
        end
        
        function saveColorTemplate(myData)
            % 获取用户输入名称并写入配色模板文件
            userInput = get(myData.hEdit, 'String');
            cofilename = {userInput};
            d = myData.dialogHandle;
            if ishandle(d)
                delete(d);
            end
            if ~myData.isSaved
                return;
            end
            folderOfThis = fileparts(mfilename('fullpath'));
            folderOfusertemplate = fullfile(fileparts(fileparts(folderOfThis)), 'usertemplate');
            coPath = fullfile(folderOfusertemplate, [cofilename{1}, '.co']);
            fid = fopen(coPath, 'w', 'n', 'utf-8');
            fprintf(fid, '%s\n', '图图：“这是配色文件（RGB,0~255）');
            fprintf(fid, '%s\n', '每一行代表一个颜色，虚线及虚线以上的内容勿动！”');
            fprintf(fid, '%s\n', '--------------------------------------------------');
            for idx = 1:length(myData.selectedIndices)
                childIdx = myData.selectedIndices(idx);
                childColor = myData.sortedChildren(childIdx).BackgroundColor;
                currentColor = round(255 * childColor);
                currentColor = max(min(currentColor,255),0);
                fprintf(fid, '%d %d %d\n', currentColor(1), currentColor(2), currentColor(3));
            end
            fclose(fid);
        end
        
        function [listHandle, usercolor] = reloadTemplates(handles)
            global handlesforusercolor
            folderOfThis = fileparts(mfilename('fullpath'));
            folderOfusertemplate = fullfile(fileparts(fileparts(folderOfThis)), 'usertemplate');
            colorFileList = dir(fullfile(folderOfusertemplate, '*.co'));
            namelist = {};
            for i = 1:length(colorFileList)
                namelist{end+1,1} = fullfile(folderOfusertemplate, colorFileList(i).name);
            end
            usercolor = cell(numel(namelist), 2);
            for i = 1:numel(namelist)
                co = [];
                fid = fopen(namelist{i}, 'r', 'n', 'utf-8');
                % 跳过三行说明
                for j = 1:3
                    fgetl(fid);
                end
                while ~feof(fid)
                    lineStr = fgetl(fid);
                    if ~isempty(lineStr)
                        colorValues = str2num(lineStr); %#ok<ST2NM>
                        if numel(colorValues)==3 && all(colorValues>=0 & colorValues<=255)
                            % co = [co; colorValues/255];
                            co = [co; colorValues]; % 需要[0-255]
                        else
                            warning('模板文件 %s 包含非法颜色值: %s', namelist{i}, lineStr);
                        end
                    end
                end
                fclose(fid);
                usercolor{i, 1} = co;
            end
            usercolor(:, 2) = namelist;
            orderFile = fullfile(folderOfusertemplate, 'colorOrder.txt');
            if exist(orderFile, 'file')
                fid = fopen(orderFile, 'r', 'n', 'utf-8');
                savedOrder = {};
                tline = fgetl(fid);
                while ischar(tline)
                    if ~isempty(strtrim(tline))
                        savedOrder{end+1,1} = strtrim(tline);
                    end
                    tline = fgetl(fid);
                end
                fclose(fid);
            else
                savedOrder = {};
            end
            for i = 1:size(usercolor, 1)
                [~, name, ~] = fileparts(usercolor{i, 2});
                usercolor{i, 2} = name;
            end
            if ~isempty(savedOrder)
                sortedUsercolor = {};
                for i = 1:length(savedOrder)
                    idx = find(strcmpi(savedOrder{i}, usercolor(:, 2)), 1);
                    if ~isempty(idx)
                        sortedUsercolor(end+1, :) = usercolor(idx, :);
                    end
                end
                notInOrder = usercolor;
                for i = 1:length(savedOrder)
                    notInOrder(strcmpi(savedOrder{i}, notInOrder(:, 2)), :) = [];
                end
                if ~isempty(notInOrder)
                    [~, alphaOrder] = sort(lower(notInOrder(:, 2)));
                    notInOrder = notInOrder(alphaOrder, :);
                end
                usercolor = [sortedUsercolor; notInOrder];
            else
                [~, alphaOrder] = sort(lower(usercolor(:, 2)));
                usercolor = usercolor(alphaOrder, :);
            end
            currentList = handles.yanselist.String;
            if ~iscell(currentList)
                currentList = cellstr(currentList);
            end
            newColorNames = usercolor(:, 2);
            for i = 1:length(newColorNames)
                if isempty(currentList) || ~any(strcmpi(currentList, newColorNames{i}))
                    currentList{end+1} = newColorNames{i};
                end
            end
            handles.yanselist.String = currentList;
            handles.yanselist.Value = length(currentList);
            handles.UserColor = usercolor;
            listHandle = handles.yanselist;
            fid = fopen(orderFile, 'w', 'n', 'utf-8');
            for i = 1:length(handles.yanselist.String)
                fprintf(fid, '%s\n', handles.yanselist.String{i});
            end
            fclose(fid);
            handlesforusercolor = handles;
        end
        
        function nextStep(src)
            d = ancestor(src, 'figure');
            myData = getappdata(d, 'myData');
            sel = [];
            for k = 1:length(myData.checkboxHandles)
                if get(myData.checkboxHandles(k), 'Value')
                    sel(end+1) = k; %#ok<AGROW>
                end
            end
            if isempty(sel)
                disp('请选择至少一个颜色块！');
                return;
            end
            myData.selectedIndices = sel;
            defaultNames = myData.defaultNameParts(sel);
            dname = strjoin(defaultNames, '-');
            set(myData.hEdit, 'String', dname);
            myData.needRegenColorBlocks = true;
            myData.state = 'input';
            setappdata(d, 'myData', myData);
            uiresume(d)
        end
        
        function previousStep(src)
            d = ancestor(src, 'figure');
            myData = getappdata(d, 'myData');
            myData.state = 'select';
            setappdata(d, 'myData', myData);
            uiresume(d);
        end
        
        function saveAndClose(src)
            d = ancestor(src, 'figure');
            myData = getappdata(d, 'myData');
            if isempty(get(myData.hEdit, 'String'))
                warndlg('请输入模板名称！', '提示');
                return;
            end
            myData.state = 'save';
            myData.isSaved = true;
            setappdata(d, 'myData', myData);
            uiresume(d);
        end
        
        function reverseSelectedColors(src)
    % reverseSelectedColors - 将已选颜色翻转 + 更新默认文件名也翻转
    %
    % 原有逻辑: 
    %   1) 取出 myData
    %   2) flip myData.selectedIndices
    %   3) 标记 needRegenColorBlocks = true
    %   4) 调用 updateColorDisplay(myData)
    %   5) 写回 myData
    %
    % 现在新增:
    %   - 同步更新默认文件名: 
    %     dname = strjoin( myData.defaultNameParts(myData.selectedIndices), '-' )

    d = ancestor(src,'figure');              
    myData = getappdata(d, 'myData');

    if isempty(myData.selectedIndices)
        disp('尚未选择任何颜色，无法逆序！');
        return;
    end

    % ===【1】翻转 selectedIndices ===
    myData.selectedIndices = fliplr(myData.selectedIndices);

    % ===【2】翻转默认文件名 (edit 框) ===
    %      即从 myData.defaultNameParts 中提取新顺序，并用 '-' 连接
    selNames = myData.defaultNameParts(myData.selectedIndices);
    dname   = strjoin(selNames, '-');
    set(myData.hEdit, 'String', dname);

    % ===【3】标记并刷新颜色块显示 ===
    myData.needRegenColorBlocks = true;
    myData = ColorTemplateHelper.updateColorDisplay(myData);

    % ===【4】保存回 myData 并提示
    setappdata(d, 'myData', myData);
    % disp('已对选中的颜色及默认文件名顺序执行逆序，并刷新显示！');
end

        
    end
end

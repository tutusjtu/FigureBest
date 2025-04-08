classdef ColorTemplateHelper 
    methods(Static)
        function processColorTemplate(handles)
            global handlesforusercolor
            %����һ���֡���ȡ��ɫ��Ϣ������
            [sortedChildren, defaultNameParts, colorInfoLines, defaultSelections] = ...
                ColorTemplateHelper.extractColorData(handles);
            
            %���ڶ����֡������Ի������ؽ������������������꣬�Ż��˲��ֺ���ɫ��
            myData = ColorTemplateHelper.createDialogUI(handles, sortedChildren, defaultNameParts, colorInfoLines, defaultSelections);
            
            %���������֡�ͨ��״̬ѭ�������ҳ���л���ɫ����ʾ����
            myData = ColorTemplateHelper.handleUIState(myData);
            
            %�����Ĳ��֡����û�������棬��д����ɫģ���ļ��������� listBox ��ʾ
            if myData.isSaved
                ColorTemplateHelper.saveColorTemplate(myData);
                [handles.yanselist, handles.UserColor] = ColorTemplateHelper.reloadTemplates(handles);
            end
            
            % ���� handles ��ͼ�ν��棨���� handles.figure1 Ϊ����������
            guidata(handles.figure1, handles);
        end
        
        function [sortedChildren, defaultNameParts, colorInfoLines, defaultSelections] = extractColorData(handles)
            % ��ȡ������ɫ�飬������ x ������������
            children = handles.colorbox.Children;
            numChildren = length(children);
            xCoordinates = zeros(numChildren,1);
            for i = 1:numChildren
                pos = get(children(i), 'Position');  % [x, y, width, height]
                xCoordinates(i) = pos(1);
            end
            [~, sortIdx] = sort(xCoordinates, 'ascend');
            sortedChildren = children(sortIdx);
            
            % Ϊÿ����ɫ�����������ơ���ϸ������Ĭ��ѡ��״̬
            defaultNameParts = cell(1, numChildren);
            colorInfoLines   = cell(1, numChildren);
            defaultSelections = false(1, numChildren);
            baseColor = handles.colorbox.BackgroundColor;
            for i = 1:numChildren
                childColor = sortedChildren(i).BackgroundColor;
                % ���� getChineseColorName Ϊ�ⲿ��ʵ�ֺ���
                cname = getChineseColorName(childColor);
                defaultNameParts{i} = cname;
                rgb255 = round(childColor * 255);
                colorInfoLines{i} = sprintf('��ɫ%d: %s  [RGB: %d %d %d]', i, cname, ...
                                            rgb255(1), rgb255(2), rgb255(3));
                defaultSelections(i) = ~isequal(childColor, baseColor);
            end
        end
        
        function myData = createDialogUI(handles, sortedChildren, defaultNameParts, colorInfoLines, defaultSelections)
            %% === �������ã����塢��ɫ���ߴ� ===
            defaultFont      = 'Microsoft YaHei';
            defaultFontSize  = 11;  
            dialogBgColor    = [255   199    53]/255;  % #F8B551�����ɫ
            btnBgColor       = [51   102   153]/255;  % ����һ��ĳ�ɫϵ
            checkboxSelColor = dialogBgColor; % 
            checkboxDefColor = dialogBgColor;     % ��ѡ��δѡ��ʱ�뱳����ͬ
            
            % ����밴ť�ĳߴ����
            modernBtnWidth  = 0.25;
            modernBtnHeight = 0.12;
            bottomMargin    = 0.05;
            
            % �Ի��������С
            dWidth = 0.5;
            dHeight = 0.4;
            
            d = dialog('Units','normalized',...
                'Position',[0.5 - dWidth/2, 0.5 - dHeight/2, dWidth, dHeight], ...
                'Name','������ɫģ��', ...
                'Resize','on',...
                'Color', dialogBgColor);
            
            %% === ��ѡ��ҳ����壨����ͬ�Ի���===
            pSelect = uipanel('Parent', d, ...
                'Units', 'normalized', ...
                'Position', [0, 0, 1, 1], ...
                'BorderType','none',...
                'BackgroundColor', dialogBgColor);
            
            % ��ѡ��ҳ���ڣ��ٴ���һ������� pGrid�����ڷ��� 5 �е�Ԥ��/��ѡ��/R/G/B ��Ϣ
            pGrid = uipanel('Parent', pSelect, ...
                'Units','normalized', ...
                'Position',[0.05, 0.25, 0.9, 0.65], ...
                'BackgroundColor', dialogBgColor, ...
                'BorderType','line', ...
                'Title','��ɫѡ��', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'TitlePosition','centertop');
            
            % ���в��ֲ�������� pGrid �����꣩
            rowHeight = 0.15;
            rowYPositions = linspace(0.8, 0.15, 5);  
            labelColWidth = 0.08;    
            squareWidth   = 0.05;     
            gap           = 0.003;    
            
            numChildren = length(sortedChildren);
            totalWidth  = labelColWidth + numChildren*squareWidth + (numChildren-1)*gap;
            offsetX     = max(0, (1 - totalWidth)/2);
            
            %% === ��һ�У�Ԥ�����⼰��ɫ���� ===
            uicontrol('Parent', pGrid, 'Style', 'text', ...
                'Units','normalized', ...
                'Position',[offsetX, rowYPositions(1)-rowHeight*0.15, labelColWidth, rowHeight], ...
                'String','Ԥ��', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold', ...
                'BackgroundColor', dialogBgColor, ...
                'HorizontalAlignment','center', ...
                'TooltipString', '��ʾ��ɫ��Ԥ��');
            
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
            
            %% === �ڶ��У���ѡ���⼰��ѡ�� ===
            uicontrol('Parent', pGrid, 'Style', 'text', ...
                'Units','normalized', ...
                'Position',[offsetX, rowYPositions(2)-rowHeight*0.24, labelColWidth, rowHeight], ...
                'String','', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold', ...
                'BackgroundColor', dialogBgColor, ...
                'HorizontalAlignment','center', ...
                'TooltipString', 'ѡ����Ҫ�������ɫ��');
            
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
                    'TooltipString', '�����ѡ��ȡ������ɫ��');
            end
            
            %% === �����У���ʾ R ֵ ===
            uicontrol('Parent', pGrid, 'Style', 'text', ...
                'Units','normalized', ...
                'Position',[offsetX, rowYPositions(3), labelColWidth, rowHeight], ...
                'String','R', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold', ...
                'BackgroundColor', dialogBgColor, ...
                'HorizontalAlignment','center', ...
                'TooltipString', '��ɫͨ�� (R)');
            
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
                    'TooltipString', ['��ɫ������', rVal]);
            end
            
            %% === �����У���ʾ G ֵ ===
            uicontrol('Parent', pGrid, 'Style', 'text', ...
                'Units','normalized', ...
                'Position',[offsetX, rowYPositions(4), labelColWidth, rowHeight], ...
                'String','G', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold', ...
                'BackgroundColor', dialogBgColor, ...
                'HorizontalAlignment','center', ...
                'TooltipString', '��ɫͨ�� (G)');
            
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
                    'TooltipString', ['��ɫ������', gVal]);
            end
            
            %% === �����У���ʾ B ֵ ===
            uicontrol('Parent', pGrid, 'Style', 'text', ...
                'Units','normalized', ...
                'Position',[offsetX, rowYPositions(5), labelColWidth, rowHeight], ...
                'String','B', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold', ...
                'BackgroundColor', dialogBgColor, ...
                'HorizontalAlignment','center', ...
                'TooltipString', '��ɫͨ�� (B)');
            
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
                    'TooltipString', ['��ɫ������', bVal]);
            end
            
            %% === �ײ�������һ������ť ===
            nextBtnX = (1 - modernBtnWidth) / 2;
            btnNext = uicontrol('Parent', pSelect, ...
                'Style','pushbutton',...
                'String','��һ��', ...
                'Units','normalized', ...
                'Position',[nextBtnX, bottomMargin, modernBtnWidth, modernBtnHeight], ...
                'BackgroundColor', btnBgColor, ...
                'ForegroundColor',[1 1 1], ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold',...
                'Callback', @(src, event) ColorTemplateHelper.nextStep(src), ...
                'TooltipString', '���������һ����ȷ����ɫѡ��');
            
            %% === �����롱ҳ����壨��������һ�£�===
            pInput = uipanel('Parent', d, ...
                'Units','normalized', ...
                'Position',[0, 0, 1, 1], ...
                'Visible','off', ...
                'BorderType','none', ...
                'BackgroundColor', dialogBgColor);
            
            % �ڡ����롱ҳ�����ٽ�һ����ɫ��� pInputBox�����ڷ��ñ��⡢�༭����ɫԤ��
            pInputBox = uipanel('Parent', pInput, ...
                'Units','normalized', ...
                'Position',[0.05, 0.25, 0.9, 0.65], ...
                'BackgroundColor', dialogBgColor, ...
                'BorderType','line', ...
                'BorderType','line', ...
                'Title','���·����������������', ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'TitlePosition','centertop');          
            
            % �༭�򣨾������룩
            hEdit = uicontrol('Parent', pInputBox, ...
                'Style','edit',...
                'String','', ...
                'Units','normalized', ...
                'Position',[0.05, 0.65, 0.9, 0.2], ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize+2, ...
                'FontWeight', 'bold', ...
                'HorizontalAlignment','center', ...
                'TooltipString', '�ڴ�����ģ������');
            
            % ��ɫ��ʾ���򣨰�ɫ�ף�
            pColorDisplay = uipanel('Parent', pInputBox, ...
                'Units','normalized', ...
                'Position',[0.05, 0.05, 0.9, 0.55], ...
                'BackgroundColor', dialogBgColor, ...
                'BorderType','none');
            
            % �ײ���ť����һ�� & ���棨���Ҳ��֣�
            gapBetween = 0.1;
            sideMargin = (1 - (2*modernBtnWidth + gapBetween)) / 2;
            
            btnPrevious = uicontrol('Parent', pInput, ...
                'Style','pushbutton', ...
                'String','��һ��', ...
                'Units','normalized', ...
                'Position',[sideMargin, bottomMargin, modernBtnWidth, modernBtnHeight], ...
                'BackgroundColor', btnBgColor, ...
                'ForegroundColor',[1 1 1], ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold',...
                'Callback', @(src, event) ColorTemplateHelper.previousStep(src), ...
                'TooltipString', '������һ���޸���ɫѡ��');
            
            btnSave = uicontrol('Parent', pInput, ...
                'Style','pushbutton', ...
                'String','����', ...
                'Units','normalized', ...
                'Position',[sideMargin+modernBtnWidth+gapBetween, bottomMargin, modernBtnWidth, modernBtnHeight], ...
                'BackgroundColor', btnBgColor, ...
                'ForegroundColor',[1 1 1],...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold',...
                'Callback', @(src, event) ColorTemplateHelper.saveAndClose(src), ...
                'TooltipString', '���浱ǰ��ɫģ�岢�˳�');
            
            
            % ���� function createDialogUI �ڵ� pInput ���֣�btnPrevious��btnSave ����֮��

            % === ����һ�� ������ ��ť���롰��һ���������桱���ţ�λ�ÿ����е��� ===
            btnReverse = uicontrol('Parent', pInputBox, ...
                'Style','pushbutton', ...
                'String','����', ...
                'Units','normalized', ...
                'Position',[0.05, 0.9, 0.05, 0.1], ... % ʾ�����꣬��btnPrevious/btnSave����ͬ�߶�
                'BackgroundColor',dialogBgColor, ...
                'ForegroundColor',[1 1 1], ...
                'FontName', defaultFont, ...
                'FontSize', defaultFontSize, ...
                'FontWeight','bold',...
                'TooltipString','����ѡ��ɫ˳��ת', ...
                'Callback', @(src, event) ColorTemplateHelper.reverseSelectedColors(src));

            
            %% === ���������ݴ��� myData �ṹ������Ի����� ===
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
            myData.pInputBox         = pInputBox;  % ��������ɫ���
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
                    % �л�������ҳ�棬��������ѡɫ����ʾ
                    set(myData.pSelect,'Visible','off');
                    set(myData.btnNext,'Visible','off');
                    set(myData.pInput,'Visible','on');
                    myData = ColorTemplateHelper.updateColorDisplay(myData);
                    setappdata(d, 'myData', myData);
                elseif strcmp(myData.state, 'select')
                    % �л���ѡ��ҳ��
                    set(myData.pInput,'Visible','off');
                    set(myData.pSelect,'Visible','on');
                    set(myData.btnNext,'Visible','on');
                elseif strcmp(myData.state, 'save')
                    break;
                end
            end
        end
        
        function myData = updateColorDisplay(myData)
            % �����û���ѡ��ҳ��ѡ�е�ɫ����¡����롱ҳ�����ɫ��ʾ
            sel    = myData.selectedIndices;
            numSel = length(sel);
            
            gap         = 0.01;
            colCapacity = 15;  % ÿ����� 15 ��ɫ��
            
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
                        sprintf('Ԥ����ɫ��%s', myData.defaultNameParts{sel(i)}));
                end
                myData.needRegenColorBlocks = false;
            else
                % ֻ�������пؼ���λ��
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
            % ��ȡ�û��������Ʋ�д����ɫģ���ļ�
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
            fprintf(fid, '%s\n', 'ͼͼ����������ɫ�ļ���RGB,0~255��');
            fprintf(fid, '%s\n', 'ÿһ�д���һ����ɫ�����߼��������ϵ������𶯣���');
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
                % ��������˵��
                for j = 1:3
                    fgetl(fid);
                end
                while ~feof(fid)
                    lineStr = fgetl(fid);
                    if ~isempty(lineStr)
                        colorValues = str2num(lineStr); %#ok<ST2NM>
                        if numel(colorValues)==3 && all(colorValues>=0 & colorValues<=255)
                            % co = [co; colorValues/255];
                            co = [co; colorValues]; % ��Ҫ[0-255]
                        else
                            warning('ģ���ļ� %s �����Ƿ���ɫֵ: %s', namelist{i}, lineStr);
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
                disp('��ѡ������һ����ɫ�飡');
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
                warndlg('������ģ�����ƣ�', '��ʾ');
                return;
            end
            myData.state = 'save';
            myData.isSaved = true;
            setappdata(d, 'myData', myData);
            uiresume(d);
        end
        
        function reverseSelectedColors(src)
    % reverseSelectedColors - ����ѡ��ɫ��ת + ����Ĭ���ļ���Ҳ��ת
    %
    % ԭ���߼�: 
    %   1) ȡ�� myData
    %   2) flip myData.selectedIndices
    %   3) ��� needRegenColorBlocks = true
    %   4) ���� updateColorDisplay(myData)
    %   5) д�� myData
    %
    % ��������:
    %   - ͬ������Ĭ���ļ���: 
    %     dname = strjoin( myData.defaultNameParts(myData.selectedIndices), '-' )

    d = ancestor(src,'figure');              
    myData = getappdata(d, 'myData');

    if isempty(myData.selectedIndices)
        disp('��δѡ���κ���ɫ���޷�����');
        return;
    end

    % ===��1����ת selectedIndices ===
    myData.selectedIndices = fliplr(myData.selectedIndices);

    % ===��2����תĬ���ļ��� (edit ��) ===
    %      ���� myData.defaultNameParts ����ȡ��˳�򣬲��� '-' ����
    selNames = myData.defaultNameParts(myData.selectedIndices);
    dname   = strjoin(selNames, '-');
    set(myData.hEdit, 'String', dname);

    % ===��3����ǲ�ˢ����ɫ����ʾ ===
    myData.needRegenColorBlocks = true;
    myData = ColorTemplateHelper.updateColorDisplay(myData);

    % ===��4������� myData ����ʾ
    setappdata(d, 'myData', myData);
    % disp('�Ѷ�ѡ�е���ɫ��Ĭ���ļ���˳��ִ�����򣬲�ˢ����ʾ��');
end

        
    end
end

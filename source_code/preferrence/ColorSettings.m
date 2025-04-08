classdef ColorSettings
    % ColorSettings 封装了与颜色设置相关的工具函数，
    % 用于获取控件的颜色属性、保存/读取颜色设置文件、解析文件内容、
    % 以及将颜色设置应用到 FB GUI 控件上。
    
    methods(Static)
        function t = safeGetTag(hObj)
            % 与 FontNameSettings.safeGetTag 相同
            val = get(hObj, 'Tag');
            if ischar(val)
                t = strtrim(val);
            else
                t = '';
            end
        end
        
        function sArr = safeGetStrings(uiControls)
            % 与 FontNameSettings.safeGetStrings 相同
            n = numel(uiControls);
            sArr = cell(n,1);
            for i = 1:n
                if isprop(uiControls(i), 'String')
                    v = get(uiControls(i), 'String');
                    if ischar(v)
                        sArr{i} = strtrim(v);
                    elseif iscell(v) && ~isempty(v)
                        sArr{i} = strtrim(char(v{1}));
                    elseif isnumeric(v)
                        sArr{i} = num2str(v);
                    else
                        sArr{i} = '';
                    end
                else
                    sArr{i} = '';
                end
            end
        end
        
        function [bgColors, fgColors] = safeGetColors(uiControls)
            % 获取控件的 BackgroundColor 和 ForegroundColor
            n = numel(uiControls);
            bgColors = cell(n,1);
            fgColors = cell(n,1);
            for i = 1:n
                if isprop(uiControls(i), 'BackgroundColor')
                    bgColors{i} = get(uiControls(i), 'BackgroundColor');
                else
                    bgColors{i} = [];
                end
                if isprop(uiControls(i), 'ForegroundColor')
                    fgColors{i} = get(uiControls(i), 'ForegroundColor');
                else
                    fgColors{i} = [];
                end
            end
        end
        
        function s = color2str(c)
            % 将颜色向量转换为字符串格式，格式为：[r,g,b]，保留两位小数
            if isempty(c)
                s = '[]';
            else
                s = sprintf('[%.2f,%.2f,%.2f]', c(1), c(2), c(3));
            end
        end
        
        function c = str2color(str)
            % 将形如 "[0.50,0.50,0.50]" 的字符串转换为 1x3 数值向量
            str = strrep(str, '[', '');
            str = strrep(str, ']', '');
            parts = strsplit(str, ',');
            if numel(parts) < 3
                c = [];
                return;
            end
            c = zeros(1,3);
            for i = 1:3
                c(i) = str2double(strtrim(parts{i}));
            end
        end
        
        function applyToFBGUI_Color(cNames, bgColors, fgColors, tagMap)
            % 将颜色设置应用到主界面中对应 Tag 的控件上
            for i = 1:numel(cNames)
                tg = strtrim(cNames{i});
                if isempty(tg)
                    continue;
                end
                if isKey(tagMap, tg)
                    h = tagMap(tg);
                    if ishandle(h)
                        if isprop(h, 'BackgroundColor')
                            set(h, 'BackgroundColor', bgColors{i});
                        end
                        if isprop(h, 'ForegroundColor')
                            set(h, 'ForegroundColor', fgColors{i});
                        end
                    end
                end
            end
        end
        
        function saveColorSettings(filePath, cNames, bgColors, fgColors, cStrings)
            % 将颜色设置保存到文件，格式为：
            % [控件的String] ([控件的Tag])=[BackgroundColor];[ForegroundColor]
            fid = fopen(filePath, 'w');
            if fid < 0
                error('无法写入文件：%s', filePath);
            end
            for i = 1:numel(cNames)
                sVal = strtrim(cStrings{i});
                tVal = strtrim(cNames{i});
                if isempty(sVal), sVal = ''; end
                if isempty(tVal), tVal = ''; end
                bgStr = ColorSettings.color2str(bgColors{i});
                fgStr = ColorSettings.color2str(fgColors{i});
                fprintf(fid, '%s (%s)=%s;%s\n', sVal, tVal, bgStr, fgStr);
            end
            fclose(fid);
        end
        
        function lines = readAllLines(fname)
            % 与 FontNameSettings.readAllLines 相同
            lines = {};
            fid = fopen(fname, 'r');
            if fid < 0
                return;
            end
            C = textscan(fid, '%s', 'Delimiter', '\n', 'EndOfLine', '\r\n');
            fclose(fid);
            lines = C{1};
        end
        
        function [cNames, cStrings, bgColors, fgColors] = parseColorLines(allLines)
            % 解析颜色设置文件中的每一行，返回各项设置
            n = numel(allLines);
            cNames = cell(n,1);
            cStrings = cell(n,1);
            bgColors = cell(n,1);
            fgColors = cell(n,1);
            k = 0;
            for i = 1:n
                L = strtrim(allLines{i});
                if isempty(L)
                    continue;
                end
                parts = strsplit(L, '=');
                if numel(parts) ~= 2
                    continue;
                end
                leftPart = strtrim(parts{1});
                rightPart = strtrim(parts{2});
                subParts = strsplit(rightPart, ';');
                if numel(subParts) < 2
                    continue;
                end
                bgColorStr = strtrim(subParts{1});
                fgColorStr = strtrim(subParts{2});
                bgC = ColorSettings.str2color(bgColorStr);
                fgC = ColorSettings.str2color(fgColorStr);
                % 从左侧文本中提取 Tag（同 FontNameSettings 的处理方式）
                idxOpen = strfind(leftPart, '(');
                idxClose = strfind(leftPart, ')');
                theTag = '';
                theStr = leftPart;
                if ~isempty(idxOpen) && ~isempty(idxClose)
                    lastO = idxOpen(end);
                    lastC = idxClose(end);
                    if lastC > lastO
                        theTag = strtrim(leftPart(lastO+1:lastC-1));
                        prefix = strtrim(leftPart(1:lastO-1));
                        suffix = strtrim(leftPart(lastC+1:end));
                        theStr = strtrim([prefix, ' ', suffix]);
                    end
                end
                k = k + 1;
                cNames{k} = theTag;
                cStrings{k} = theStr;
                bgColors{k} = bgC;
                fgColors{k} = fgC;
            end
            cNames(k+1:end) = [];
            cStrings(k+1:end) = [];
            bgColors(k+1:end) = [];
            fgColors(k+1:end) = [];
        end
        
        function [colorsByTag, colorsByString] = loadColorSettings(filePath)
            % 返回以 Tag 和 String 为键的颜色设置结构体
            colorsByTag = struct();
            colorsByString = struct();
            if ~exist(filePath, 'file')
                return;
            end
            lines = ColorSettings.readAllLines(filePath);
            for i = 1:numel(lines)
                L = strtrim(lines{i});
                if isempty(L)
                    continue;
                end
                parts = strsplit(L, '=');
                if numel(parts) < 2
                    continue;
                end
                leftPart = strtrim(parts{1});
                rightPart = strtrim(parts{2});
                subParts = strsplit(rightPart, ';');
                if numel(subParts) < 2
                    continue;
                end
                bgColorStr = strtrim(subParts{1});
                fgColorStr = strtrim(subParts{2});
                bgC = ColorSettings.str2color(bgColorStr);
                fgC = ColorSettings.str2color(fgColorStr);
                tokens = regexp(leftPart, '\((.*?)\)', 'tokens');
                theTag = '';
                if ~isempty(tokens)
                    theTag = strtrim(tokens{end}{1});
                end
                leftNoTag = regexprep(leftPart, '\(.*?\)', '');
                theStr = strtrim(leftNoTag);
                if ~isempty(theTag)
                    tField = matlab.lang.makeValidName(theTag);
                    colorsByTag.(tField) = struct('bg', bgC, 'fg', fgC);
                end
                if ~isempty(theStr)
                    sField = matlab.lang.makeValidName(theStr);
                    colorsByString.(sField) = struct('bg', bgC, 'fg', fgC);
                end
            end
        end
        
        function [updNames, updStrings, upd_bgColors, upd_fgColors] = compareAndUpdateColorData(uiNames, uiStrings, ui_bgColors, ui_fgColors, fileNames, fileStrings, file_bgColors, file_fgColors)
            % compareAndUpdateColorData 对比 UI 与文件侧颜色数据，并更新颜色字段
            %
            % 输入参数：
            %   uiNames     - UI侧的名称列表（cell 数组）
            %   uiStrings   - UI侧的字符串列表（cell 数组）
            %   ui_bgColors - UI侧的背景颜色（cell 数组，每个元素为 [R G B] 向量）
            %   ui_fgColors - UI侧的前景颜色（cell 数组，每个元素为 [R G B] 向量）
            %   fileNames     - 文件侧的名称列表（cell 数组）
            %   fileStrings   - 文件侧的字符串列表（cell 数组）
            %   file_bgColors - 文件侧的背景颜色（cell 数组）
            %   file_fgColors - 文件侧的前景颜色（cell 数组）
            %
            % 输出参数：
            %   updNames, updStrings, upd_bgColors, upd_fgColors 分别为更新后的数据
            %
            % 对于每个 UI 元素，先尝试使用名称匹配，若匹配成功则更新背景色和前景色，
            % 否则尝试使用字符串匹配；均未匹配则保留原始颜色数据。
            
            updNames = uiNames;
            updStrings = uiStrings;
            upd_bgColors = ui_bgColors;
            upd_fgColors = ui_fgColors;
            
            for i = 1:length(uiNames)
                % 先尝试用名称匹配
                idx = find(strcmp(uiNames{i}, fileNames), 1);
                if ~isempty(idx)
                    upd_bgColors{i} = file_bgColors{idx};
                    upd_fgColors{i} = file_fgColors{idx};
                else
                    % 如果名称匹配失败，尝试用字符串匹配
                    idx2 = find(strcmp(uiStrings{i}, fileStrings), 1);
                    if ~isempty(idx2)
                        upd_bgColors{i} = file_bgColors{idx2};
                        upd_fgColors{i} = file_fgColors{idx2};
                    end
                end
            end
        end
    end
end

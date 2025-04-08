classdef FontNameSettings
    % FontNameSettings 包含所有与字体名称设置相关的工具函数，
    % 并扩展支持字体加粗（FontWeight）和斜体（FontAngle）。
    %
    % 文件保存格式为：
    %   [控件的String] ([控件的Tag])=FontName;FontWeight;FontAngle
    % 如果 FontWeight 或 FontAngle 未指定，则默认为 'normal'。
    
    methods(Static)
        function t = safeGetTag(hObj)
            val = get(hObj, 'Tag');
            if ischar(val)
                t = strtrim(val);
            else
                t = '';
            end
        end
        
        function sArr = safeGetStrings(uiControls)
            n = numel(uiControls);
            sArr = cell(n, 1);
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
        
        function s = onOff(b)
            if b
                s = 'on';
            else
                s = 'off';
            end
        end
        
        function applyToFBGUI_FontName(fNames, fFontNames, fFontWeights, fFontAngles, tagMap)
            for i = 1:numel(fNames)
                tg = strtrim(fNames{i});
                if isempty(tg)
                    continue;
                end
                if isKey(tagMap, tg)
                    h = tagMap(tg);
                    if ishandle(h)
                        set(h, 'FontName', fFontNames{i}, 'FontWeight', fFontWeights{i}, 'FontAngle', fFontAngles{i});
                    end
                end
            end
        end
        
        function saveFontSettingFile(filePath, fNames, fFontNames, fFontWeights, fFontAngles, fStrings)
            fid = fopen(filePath, 'w');
            if fid < 0
                error('无法写入文件：%s', filePath);
            end
            for i = 1:numel(fNames)
                sVal = strtrim(fStrings{i});
                tVal = strtrim(fNames{i});
                if isempty(sVal), sVal = ''; end
                if isempty(tVal), tVal = ''; end
                % 格式：[String] ([Tag])=FontName;FontWeight;FontAngle
                fprintf(fid, '%s (%s)=%s;%s;%s\n', sVal, tVal, fFontNames{i}, fFontWeights{i}, fFontAngles{i});
            end
            fclose(fid);
        end
        
        function lines = readAllLines(fname)
            lines = {};
            fid = fopen(fname, 'r');
            if fid < 0
                return;
            end
            C = textscan(fid, '%s', 'Delimiter', '\n', 'EndOfLine', '\r\n');
            fclose(fid);
            lines = C{1};
        end
        
        function [fNames, fStrings, fFontNames, fFontWeights, fFontAngles] = parseFontLines_FontName(allLines)
            n = numel(allLines);
            fNames = cell(n, 1);
            fStrings = cell(n, 1);
            fFontNames = cell(n, 1);
            fFontWeights = cell(n, 1);
            fFontAngles = cell(n, 1);
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
                fontName = '';
                weight = 'normal';
                angle = 'normal';
                if numel(subParts) >= 1
                    fontName = strtrim(subParts{1});
                end
                if numel(subParts) >= 2
                    weight = strtrim(subParts{2});
                end
                if numel(subParts) >= 3
                    angle = strtrim(subParts{3});
                end
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
                fNames{k} = theTag;
                fStrings{k} = theStr;
                fFontNames{k} = fontName;
                fFontWeights{k} = weight;
                fFontAngles{k} = angle;
            end
            fNames(k+1:end) = [];
            fStrings(k+1:end) = [];
            fFontNames(k+1:end) = [];
            fFontWeights(k+1:end) = [];
            fFontAngles(k+1:end) = [];
        end
        
        function [fontsByTag, fontsByString] = loadFontSettingFile(filePath)
            fontsByTag = struct();
            fontsByString = struct();
            if ~exist(filePath, 'file')
                return;
            end
            lines = FontNameSettings.readAllLines(filePath);
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
                fontName = '';
                if ~isempty(subParts)
                    fontName = strtrim(subParts{1});
                end
                tokens = regexp(leftPart, '\((.*?)\)', 'tokens');
                theTag = '';
                if ~isempty(tokens)
                    theTag = strtrim(tokens{end}{1});
                end
                leftNoTag = regexprep(leftPart, '\(.*?\)', '');
                theStr = strtrim(leftNoTag);
                if ~isempty(theTag)
                    tField = matlab.lang.makeValidName(theTag);
                    fontsByTag.(tField) = fontName;
                end
                if ~isempty(theStr)
                    sField = matlab.lang.makeValidName(theStr);
                    fontsByString.(sField) = fontName;
                end
            end
        end
        
        function [updFontNames, updFontWeights, updFontAngles, updStrings, updNames] = compareAndUpdateFontNameData(uiNames, uiStrings, uiFontNames, uiFontWeights, uiFontAngles, fileNames, fileStrings, fileFontNames, fileFontWeights, fileFontAngles)
            % compareAndUpdateFontNameData 对比 UI 与文件侧字体名称数据，并更新字体属性
            %
            % 输入参数：
            %   uiNames        - UI 侧控件的名称列表（如 fNamesFN，cell 数组）
            %   uiStrings      - UI 侧控件的字符串列表（如 fStringsFN，cell 数组）
            %   uiFontNames    - UI 侧控件的字体名称（cell 数组）
            %   uiFontWeights  - UI 侧控件的字体粗细（cell 数组）
            %   uiFontAngles   - UI 侧控件的字体倾斜度（cell 数组）
            %   fileNames      - 文件侧的名称列表（cell 数组）
            %   fileStrings    - 文件侧的字符串列表（cell 数组）
            %   fileFontNames  - 文件侧的字体名称（cell 数组）
            %   fileFontWeights- 文件侧的字体粗细（cell 数组）
            %   fileFontAngles - 文件侧的字体倾斜度（cell 数组）
            %
            % 输出参数：
            %   updFontNames   - 更新后的字体名称（cell 数组）
            %   updFontWeights - 更新后的字体粗细（cell 数组）
            %   updFontAngles  - 更新后的字体倾斜度（cell 数组）
            %   updStrings     - 更新后的字符串（保持 UI 侧数据不变）
            %   updNames       - 更新后的名称列表（保持 UI 侧数据不变）
            
            % 初始化返回数据，先使用 UI 侧数据
            updNames = uiNames;
            updStrings = uiStrings;
            updFontNames = uiFontNames;
            updFontWeights = uiFontWeights;
            updFontAngles = uiFontAngles;
            
            % 遍历每个 UI 控件数据
            for i = 1:length(uiNames)
                % 先尝试用名称匹配
                idx = find(strcmp(uiNames{i}, fileNames), 1);
                if ~isempty(idx)
                    updFontNames{i} = fileFontNames{idx};
                    updFontWeights{i} = fileFontWeights{idx};
                    updFontAngles{i} = fileFontAngles{idx};
                else
                    % 名称匹配失败，尝试用字符串匹配
                    idx2 = find(strcmp(uiStrings{i}, fileStrings), 1);
                    if ~isempty(idx2)
                        updFontNames{i} = fileFontNames{idx2};
                        updFontWeights{i} = fileFontWeights{idx2};
                        updFontAngles{i} = fileFontAngles{idx2};
                    end
                    % 若两种方式都未匹配，则保留原始 UI 数据
                end
            end
        end
    end
end

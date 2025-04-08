classdef FontSettings
    % FontSettings 包含所有与字体设置相关的工具函数
    % 该类提供静态方法，用于：
    %   - 安全获取控件的 Tag 与 String 属性
    %   - 将字体设置写入文件、读取文件、解析文件内容
    %   - 将修改后的设置应用到主 GUI 控件上
    %   - 将布尔值转换为 'on'/'off'
    %
    % 使用示例：
    %   tagStr = FontSettings.safeGetTag(hControl);
    %   sArr = FontSettings.safeGetStrings(controlArray);
    %   status = FontSettings.onOff(true);
    %   FontSettings.applyToFBGUI(fNames, fSizes, tagMap);
    %   FontSettings.saveFontSettings(filePath, fNames, fSizes, fStrings);
    %   lines = FontSettings.readAllLines(filePath);
    %   [fNames, fStrings, fSizes] = FontSettings.parseFontLines_KeepBrackets(lines);
    %   [fontsByTag, fontsByString] = FontSettings.loadFontSettings(filePath);
    
    methods(Static)
        function t = safeGetTag(hObj)
            % SAFEGETTAG 安全获取控件的 Tag 属性
            % 输入参数：
            %   hObj - 控件句柄
            % 输出参数：
            %   t    - 去除空格后的 Tag 字符串；若不可用，则返回空字符串
            val = get(hObj, 'Tag');
            if ischar(val)
                t = strtrim(val);
            else
                t = '';
            end
        end
        
        function sArr = safeGetStrings(uiControls)
            % SAFEGETSTRINGS 批量安全获取控件的 String 属性
            % 输入参数：
            %   uiControls - 控件句柄数组
            % 输出参数：
            %   sArr - cell 数组，每个元素为对应控件的 String 属性
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
            % ONOFF 将布尔值转换为 'on' 或 'off'
            % 输入参数：
            %   b - 布尔值
            % 输出参数：
            %   s - 若 b 为 true，则返回 'on'；否则返回 'off'
            if b
                s = 'on';
            else
                s = 'off';
            end
        end
        
        function applyToFBGUI(fNames, fSizes, tagMap)
            % APPLYTOFBGUI 将修改后的字号设置应用到主 GUI 控件上
            % 根据 fNames 中存储的控件 Tag，在 tagMap 中查找对应控件，
            % 并将其 FontSize 属性更新为 fSizes 中的值。
            for i = 1:numel(fNames)
                tg = strtrim(fNames{i});
                if isempty(tg)
                    continue;
                end
                if isKey(tagMap, tg)
                    h = tagMap(tg);
                    if ishandle(h)
                        set(h, 'FontSize', fSizes(i));
                    end
                end
            end
        end
        
        function saveFontSettings(filePath, fNames, fSizes, fStrings)
            % SAVEFONTSETTINGS 将字体设置写入文件
            % 文件格式为：[显示字符串] ([Tag])=字号
            fid = fopen(filePath, 'w');
            if fid < 0
                error('无法写入文件：%s', filePath);
            end
            for i = 1:numel(fNames)
                sVal = strtrim(fStrings{i});
                tVal = strtrim(fNames{i});
                if isempty(sVal), sVal = ''; end
                if isempty(tVal), tVal = ''; end
                fprintf(fid, '%s (%s)=%d\n', sVal, tVal, fSizes(i));
            end
            fclose(fid);
        end
        
        function lines = readAllLines(fname)
            % READALLLINES 读取文件中的所有行，返回 cell 数组
            lines = {};
            fid = fopen(fname, 'r');
            if fid < 0
                return;
            end
            C = textscan(fid, '%s', 'Delimiter', '\n', 'EndOfLine', '\r\n');
            fclose(fid);
            lines = C{1};
        end
        
        function [fNames, fStrings, fSizes] = parseFontLines_KeepBrackets(allLines)
            % PARSEFONTLINES_KEEPBRACKETS 解析字体设置文件的每一行
            % 每行格式为：[显示字符串] ([Tag])=字号
            n = numel(allLines);
            fNames = cell(n,1);
            fStrings = cell(n,1);
            fSizes = zeros(n,1);
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
                szVal = str2double(parts{2});
                if isnan(szVal)
                    continue;
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
                fSizes(k) = szVal;
            end
            fNames(k+1:end) = [];
            fStrings(k+1:end) = [];
            fSizes(k+1:end) = [];
        end
        
        function [fontsByTag, fontsByString] = loadFontSettings(fontFilePath)
            % LOADFONTSETTINGS 从字体设置文件中读取设置数据
            % 每行格式为：[显示字符串] ([Tag])=字号
            % 输出：
            %   fontsByTag    - 结构体，其字段为控件 Tag，值为对应的字号。
            %   fontsByString - 结构体，其字段为控件显示字符串，值为对应的字号。
            fontsByTag = struct();
            fontsByString = struct();
            if ~exist(fontFilePath, 'file')
                return;
            end
            lines = FontSettings.readAllLines(fontFilePath);
            for i = 1:numel(lines)
                L = strtrim(lines{i});
                if isempty(L)
                    continue;
                end
                parts = strsplit(L, '=');
                if numel(parts) ~= 2
                    continue;
                end
                leftPart = strtrim(parts{1});
                szVal = str2double(parts{2});
                if isnan(szVal)
                    continue;
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
                    fontsByTag.(tField) = szVal;
                end
                if ~isempty(theStr)
                    sField = matlab.lang.makeValidName(theStr);
                    fontsByString.(sField) = szVal;
                end
            end
        end    
        
        
        function [updSizes, updStrings, updNames] = compareAndUpdateFontData(fNames, fStrings, fSizes, fileFNames, fileFStrings, fileFSizes)
            % compareAndUpdateFontData 对比 UI 侧数据与文件侧数据，更新字体大小
            %
            % 输入参数：
            %   fNames       - UI 侧的名称列表（cell 数组）
            %   fStrings     - UI 侧的字符串列表（cell 数组）
            %   fSizes       - UI 侧的字体大小数组（数值数组）
            %   fileFNames   - 文件侧的名称列表（cell 数组）
            %   fileFStrings - 文件侧的字符串列表（cell 数组）
            %   fileFSizes   - 文件侧的字体大小数组（数值数组）
            %
            % 输出参数：
            %   updSizes     - 更新后的字体大小数组
            %   updStrings   - UI 侧的字符串列表（保持不变）
            %   updNames     - UI 侧的名称列表（保持不变）
            
            % 初始时直接使用 UI 侧数据
            updSizes = fSizes;
            updStrings = fStrings;
            updNames = fNames;
            
            % 遍历每个 UI 侧数据
            for i = 1:length(fNames)
                % 先用 fNames 进行匹配
                idx = find(strcmp(fNames{i}, fileFNames), 1);
                if ~isempty(idx)
                    updSizes(i) = fileFSizes(idx);
                else
                    % 若 fNames 匹配失败，则用 fStrings 尝试匹配
                    idx2 = find(strcmp(fStrings{i}, fileFStrings), 1);
                    if ~isempty(idx2)
                        updSizes(i) = fileFSizes(idx2);
                    end
                    % 如果两种方式都未匹配，则保持原 fSizes(i)
                end
            end
        end
        

        
    end % methods(Static)
end % classdef

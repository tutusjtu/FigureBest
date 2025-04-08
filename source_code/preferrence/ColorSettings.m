classdef ColorSettings
    % ColorSettings ��װ������ɫ������صĹ��ߺ�����
    % ���ڻ�ȡ�ؼ�����ɫ���ԡ�����/��ȡ��ɫ�����ļ��������ļ����ݡ�
    % �Լ�����ɫ����Ӧ�õ� FB GUI �ؼ��ϡ�
    
    methods(Static)
        function t = safeGetTag(hObj)
            % �� FontNameSettings.safeGetTag ��ͬ
            val = get(hObj, 'Tag');
            if ischar(val)
                t = strtrim(val);
            else
                t = '';
            end
        end
        
        function sArr = safeGetStrings(uiControls)
            % �� FontNameSettings.safeGetStrings ��ͬ
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
            % ��ȡ�ؼ��� BackgroundColor �� ForegroundColor
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
            % ����ɫ����ת��Ϊ�ַ�����ʽ����ʽΪ��[r,g,b]��������λС��
            if isempty(c)
                s = '[]';
            else
                s = sprintf('[%.2f,%.2f,%.2f]', c(1), c(2), c(3));
            end
        end
        
        function c = str2color(str)
            % ������ "[0.50,0.50,0.50]" ���ַ���ת��Ϊ 1x3 ��ֵ����
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
            % ����ɫ����Ӧ�õ��������ж�Ӧ Tag �Ŀؼ���
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
            % ����ɫ���ñ��浽�ļ�����ʽΪ��
            % [�ؼ���String] ([�ؼ���Tag])=[BackgroundColor];[ForegroundColor]
            fid = fopen(filePath, 'w');
            if fid < 0
                error('�޷�д���ļ���%s', filePath);
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
            % �� FontNameSettings.readAllLines ��ͬ
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
            % ������ɫ�����ļ��е�ÿһ�У����ظ�������
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
                % ������ı�����ȡ Tag��ͬ FontNameSettings �Ĵ���ʽ��
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
            % ������ Tag �� String Ϊ������ɫ���ýṹ��
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
            % compareAndUpdateColorData �Ա� UI ���ļ�����ɫ���ݣ���������ɫ�ֶ�
            %
            % ���������
            %   uiNames     - UI��������б�cell ���飩
            %   uiStrings   - UI����ַ����б�cell ���飩
            %   ui_bgColors - UI��ı�����ɫ��cell ���飬ÿ��Ԫ��Ϊ [R G B] ������
            %   ui_fgColors - UI���ǰ����ɫ��cell ���飬ÿ��Ԫ��Ϊ [R G B] ������
            %   fileNames     - �ļ���������б�cell ���飩
            %   fileStrings   - �ļ�����ַ����б�cell ���飩
            %   file_bgColors - �ļ���ı�����ɫ��cell ���飩
            %   file_fgColors - �ļ����ǰ����ɫ��cell ���飩
            %
            % ���������
            %   updNames, updStrings, upd_bgColors, upd_fgColors �ֱ�Ϊ���º������
            %
            % ����ÿ�� UI Ԫ�أ��ȳ���ʹ������ƥ�䣬��ƥ��ɹ�����±���ɫ��ǰ��ɫ��
            % ������ʹ���ַ���ƥ�䣻��δƥ������ԭʼ��ɫ���ݡ�
            
            updNames = uiNames;
            updStrings = uiStrings;
            upd_bgColors = ui_bgColors;
            upd_fgColors = ui_fgColors;
            
            for i = 1:length(uiNames)
                % �ȳ���������ƥ��
                idx = find(strcmp(uiNames{i}, fileNames), 1);
                if ~isempty(idx)
                    upd_bgColors{i} = file_bgColors{idx};
                    upd_fgColors{i} = file_fgColors{idx};
                else
                    % �������ƥ��ʧ�ܣ��������ַ���ƥ��
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

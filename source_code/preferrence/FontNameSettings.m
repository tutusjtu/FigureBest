classdef FontNameSettings
    % FontNameSettings ������������������������صĹ��ߺ�����
    % ����չ֧������Ӵ֣�FontWeight����б�壨FontAngle����
    %
    % �ļ������ʽΪ��
    %   [�ؼ���String] ([�ؼ���Tag])=FontName;FontWeight;FontAngle
    % ��� FontWeight �� FontAngle δָ������Ĭ��Ϊ 'normal'��
    
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
                error('�޷�д���ļ���%s', filePath);
            end
            for i = 1:numel(fNames)
                sVal = strtrim(fStrings{i});
                tVal = strtrim(fNames{i});
                if isempty(sVal), sVal = ''; end
                if isempty(tVal), tVal = ''; end
                % ��ʽ��[String] ([Tag])=FontName;FontWeight;FontAngle
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
            % compareAndUpdateFontNameData �Ա� UI ���ļ��������������ݣ���������������
            %
            % ���������
            %   uiNames        - UI ��ؼ��������б��� fNamesFN��cell ���飩
            %   uiStrings      - UI ��ؼ����ַ����б��� fStringsFN��cell ���飩
            %   uiFontNames    - UI ��ؼ����������ƣ�cell ���飩
            %   uiFontWeights  - UI ��ؼ��������ϸ��cell ���飩
            %   uiFontAngles   - UI ��ؼ���������б�ȣ�cell ���飩
            %   fileNames      - �ļ���������б�cell ���飩
            %   fileStrings    - �ļ�����ַ����б�cell ���飩
            %   fileFontNames  - �ļ�����������ƣ�cell ���飩
            %   fileFontWeights- �ļ���������ϸ��cell ���飩
            %   fileFontAngles - �ļ����������б�ȣ�cell ���飩
            %
            % ���������
            %   updFontNames   - ���º���������ƣ�cell ���飩
            %   updFontWeights - ���º�������ϸ��cell ���飩
            %   updFontAngles  - ���º��������б�ȣ�cell ���飩
            %   updStrings     - ���º���ַ��������� UI �����ݲ��䣩
            %   updNames       - ���º�������б����� UI �����ݲ��䣩
            
            % ��ʼ���������ݣ���ʹ�� UI ������
            updNames = uiNames;
            updStrings = uiStrings;
            updFontNames = uiFontNames;
            updFontWeights = uiFontWeights;
            updFontAngles = uiFontAngles;
            
            % ����ÿ�� UI �ؼ�����
            for i = 1:length(uiNames)
                % �ȳ���������ƥ��
                idx = find(strcmp(uiNames{i}, fileNames), 1);
                if ~isempty(idx)
                    updFontNames{i} = fileFontNames{idx};
                    updFontWeights{i} = fileFontWeights{idx};
                    updFontAngles{i} = fileFontAngles{idx};
                else
                    % ����ƥ��ʧ�ܣ��������ַ���ƥ��
                    idx2 = find(strcmp(uiStrings{i}, fileStrings), 1);
                    if ~isempty(idx2)
                        updFontNames{i} = fileFontNames{idx2};
                        updFontWeights{i} = fileFontWeights{idx2};
                        updFontAngles{i} = fileFontAngles{idx2};
                    end
                    % �����ַ�ʽ��δƥ�䣬����ԭʼ UI ����
                end
            end
        end
    end
end

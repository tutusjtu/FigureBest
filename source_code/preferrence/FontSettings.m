classdef FontSettings
    % FontSettings ��������������������صĹ��ߺ���
    % �����ṩ��̬���������ڣ�
    %   - ��ȫ��ȡ�ؼ��� Tag �� String ����
    %   - ����������д���ļ�����ȡ�ļ��������ļ�����
    %   - ���޸ĺ������Ӧ�õ��� GUI �ؼ���
    %   - ������ֵת��Ϊ 'on'/'off'
    %
    % ʹ��ʾ����
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
            % SAFEGETTAG ��ȫ��ȡ�ؼ��� Tag ����
            % ���������
            %   hObj - �ؼ����
            % ���������
            %   t    - ȥ���ո��� Tag �ַ������������ã��򷵻ؿ��ַ���
            val = get(hObj, 'Tag');
            if ischar(val)
                t = strtrim(val);
            else
                t = '';
            end
        end
        
        function sArr = safeGetStrings(uiControls)
            % SAFEGETSTRINGS ������ȫ��ȡ�ؼ��� String ����
            % ���������
            %   uiControls - �ؼ��������
            % ���������
            %   sArr - cell ���飬ÿ��Ԫ��Ϊ��Ӧ�ؼ��� String ����
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
            % ONOFF ������ֵת��Ϊ 'on' �� 'off'
            % ���������
            %   b - ����ֵ
            % ���������
            %   s - �� b Ϊ true���򷵻� 'on'�����򷵻� 'off'
            if b
                s = 'on';
            else
                s = 'off';
            end
        end
        
        function applyToFBGUI(fNames, fSizes, tagMap)
            % APPLYTOFBGUI ���޸ĺ���ֺ�����Ӧ�õ��� GUI �ؼ���
            % ���� fNames �д洢�Ŀؼ� Tag���� tagMap �в��Ҷ�Ӧ�ؼ���
            % ������ FontSize ���Ը���Ϊ fSizes �е�ֵ��
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
            % SAVEFONTSETTINGS ����������д���ļ�
            % �ļ���ʽΪ��[��ʾ�ַ���] ([Tag])=�ֺ�
            fid = fopen(filePath, 'w');
            if fid < 0
                error('�޷�д���ļ���%s', filePath);
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
            % READALLLINES ��ȡ�ļ��е������У����� cell ����
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
            % PARSEFONTLINES_KEEPBRACKETS �������������ļ���ÿһ��
            % ÿ�и�ʽΪ��[��ʾ�ַ���] ([Tag])=�ֺ�
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
            % LOADFONTSETTINGS �����������ļ��ж�ȡ��������
            % ÿ�и�ʽΪ��[��ʾ�ַ���] ([Tag])=�ֺ�
            % �����
            %   fontsByTag    - �ṹ�壬���ֶ�Ϊ�ؼ� Tag��ֵΪ��Ӧ���ֺš�
            %   fontsByString - �ṹ�壬���ֶ�Ϊ�ؼ���ʾ�ַ�����ֵΪ��Ӧ���ֺš�
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
            % compareAndUpdateFontData �Ա� UI ���������ļ������ݣ����������С
            %
            % ���������
            %   fNames       - UI ��������б�cell ���飩
            %   fStrings     - UI ����ַ����б�cell ���飩
            %   fSizes       - UI ��������С���飨��ֵ���飩
            %   fileFNames   - �ļ���������б�cell ���飩
            %   fileFStrings - �ļ�����ַ����б�cell ���飩
            %   fileFSizes   - �ļ���������С���飨��ֵ���飩
            %
            % ���������
            %   updSizes     - ���º�������С����
            %   updStrings   - UI ����ַ����б����ֲ��䣩
            %   updNames     - UI ��������б����ֲ��䣩
            
            % ��ʼʱֱ��ʹ�� UI ������
            updSizes = fSizes;
            updStrings = fStrings;
            updNames = fNames;
            
            % ����ÿ�� UI ������
            for i = 1:length(fNames)
                % ���� fNames ����ƥ��
                idx = find(strcmp(fNames{i}, fileFNames), 1);
                if ~isempty(idx)
                    updSizes(i) = fileFSizes(idx);
                else
                    % �� fNames ƥ��ʧ�ܣ����� fStrings ����ƥ��
                    idx2 = find(strcmp(fStrings{i}, fileFStrings), 1);
                    if ~isempty(idx2)
                        updSizes(i) = fileFSizes(idx2);
                    end
                    % ������ַ�ʽ��δƥ�䣬�򱣳�ԭ fSizes(i)
                end
            end
        end
        

        
    end % methods(Static)
end % classdef

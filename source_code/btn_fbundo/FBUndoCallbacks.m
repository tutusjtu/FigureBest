classdef FBUndoCallbacks
    % FBUndoCallbacks ����ά��������������и��ؼ��Ļص�����
    methods(Static)
        function ishistory_Callback(src, eventdata, figHandle, handles)
            % ����ѡ��ť״̬�ı䣬������Ҫ���Ը��� src.Value ִ����Ӧ����
            % disp('�������Ƿ�򿪳������ܵĿ��ء�״̬�ı�');
            
            %%%%%%%%%%%%%%% ���������ļ���д %%%%%%%%%%%%%%%
            % ��ȡ settings �ļ���·��
            folderOfThis = fileparts(mfilename('fullpath'));
            folderOfFB = fileparts(fileparts(folderOfThis));
            settingsFolder = fullfile(folderOfFB, 'settings');
            if ~exist(settingsFolder, 'dir')
                mkdir(settingsFolder);
            end
            txtFile = fullfile(settingsFolder, 'ishistory.txt');
            % ����ļ��������򴴽���д���ʼֵ 0
            if ~exist(txtFile, 'file')
                fid = fopen(txtFile, 'wt');
                fprintf(fid, '%d', 0);
                fclose(fid);
            end
            % ÿ�λص�ʱ����ǰ״̬д���ļ�
            fid = fopen(txtFile, 'wt');
            fprintf(fid, '%d', src.Value);
            fclose(fid);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % ����ѡ��ť״̬�ı䣬������Ҫ���Ը��� src.Value ִ����Ӧ����
            % disp('�������Ƿ�򿪳������ܵĿ��ء�״̬�ı�');
            % �˴�����Ӷ�����룬���������ز���
            if src.Value
                handles.msg.String = '��ʱ�����ٶ�������Ӱ�죡';
                %%%%%%%%%%%%%%% ���historydata�ļ����ڵ�.mat�ļ����� %%%%%%%%%%%%%%%
                folderOfThis = fileparts(mfilename('fullpath'));  % ��ȡ��ǰ.m�ļ����ڵ��ļ���
                folderOfFB = fileparts(fileparts(folderOfThis));  % ��ȡFB�ļ���
                folderOfHistory = fullfile(folderOfFB, 'historydata');  % ����historydata�ļ���·��
                
                % ��ȡhistorydata�ļ��������е�.mat�ļ�
                matFiles = dir(fullfile(folderOfHistory, '*.mat'));
                numFiles = length(matFiles);
                
                % ����ļ���������200���������û���ʱ����
                if numFiles > 200
                    warningMsg = sprintf('��ǰhistorydata�ļ�����.mat�ļ�����Ϊ %d���ѳ���200�����뼰ʱ���¡�����-��ʼ������ť��������Ӱ�������ٶȡ�', numFiles);
                    fprintf('%s\n', warningMsg);
                    handles.msg.String = '�浵̫�࣡������-��ʼ������������Ӱ���ٶȣ�';
                    % ��ѡ��ʹ�öԻ��������û�
                    % msgbox(warningMsg, '����', 'warn');
                end
                
            else
                handles.msg.String = '�浵/���������ѹرգ�';
            end
        end
        
        function undo_Callback(src, eventdata, figHandle, handles)
            % disp('����������ť�����');
            if handles.ishistory.Value == 0 % ֻ�д浵��ť�����²Ż�浵
                handles.msg.String = ['���ȴ򿪡��������ܿ��ơ���'];
                return
            end
            disp('����ʼ�����أ�����...')
            handles.msg.String = ['���ڻ���,����...'];
            pause(0.01)
            % ��ʷ��¼��
            try
                main_history(handles,'load')
            catch
                handles.msg.String = ['����ʧ��,�������¡�������'];
                pause(0.01)
                return
            end
            
            handles.msg.String = ['ȫ�����˳ɹ�'];
            disp('��������ȫ�����سɹ���')
        end
        
        function archive_Callback(src, eventdata, figHandle, handles)
            if handles.ishistory.Value == 0 % ֻ�д浵��ť�����²Ż�浵
                handles.msg.String = ['���ȴ򿪡��������ܿ��ơ���'];
                return
            end
            disp('�����������ڳ�ʼ��Figure��ʷ���ݿ�...')
            handles.msg.String = ['���ڳ�ʼ�����ݿ�,����...'];pause(0.01)
            % ��ʷ��¼��
            % �������������ļ�
            folderOfThis = fileparts(mfilename('fullpath')); % get the folder of current .m
            folderOfFB = fileparts(fileparts(folderOfThis)); % get the folder of FB
            folderOfHistory = fullfile(folderOfFB,'historydata');
            
            list = dir(folderOfHistory);
            matName = {};
            for i = 1:length(list)
                if strfind(list(i).name,'.mat')
                    delete(fullfile(folderOfHistory,list(i).name));
                end
            end
            % ��ʼ���ļ�
            try
                main_history(handles,'save') %
                handles.msg.String = ['��ʼ���ɹ�'];pause(0.01)
                disp('����ɡ���')
            catch
                disp('����ʼ��ʧ�ܡ���')
                handles.msg.String = ['��ʼ��ʧ��'];
            end
            
        end
        
        function close_Callback(src, eventdata, figHandle, handles)
            % disp('���رա���ť�����');
            % ���س����������
            handles = guidata(figHandle);
            if isfield(handles, 'undoPanel') && ishandle(handles.undoPanel)
                set(handles.undoPanel, 'Visible', 'off');
            end
            guidata(figHandle, handles);
        end
    end
end

classdef FBUndoCallbacks
    % FBUndoCallbacks 集中维护撤销控制面板中各控件的回调函数
    methods(Static)
        function ishistory_Callback(src, eventdata, figHandle, handles)
            % 处理单选按钮状态改变，如有需要可以根据 src.Value 执行相应操作
            % disp('【控制是否打开撤销功能的开关】状态改变');
            
            %%%%%%%%%%%%%%% 增加设置文件读写 %%%%%%%%%%%%%%%
            % 获取 settings 文件夹路径
            folderOfThis = fileparts(mfilename('fullpath'));
            folderOfFB = fileparts(fileparts(folderOfThis));
            settingsFolder = fullfile(folderOfFB, 'settings');
            if ~exist(settingsFolder, 'dir')
                mkdir(settingsFolder);
            end
            txtFile = fullfile(settingsFolder, 'ishistory.txt');
            % 如果文件不存在则创建，写入初始值 0
            if ~exist(txtFile, 'file')
                fid = fopen(txtFile, 'wt');
                fprintf(fid, '%d', 0);
                fclose(fid);
            end
            % 每次回调时将当前状态写入文件
            fid = fopen(txtFile, 'wt');
            fprintf(fid, '%d', src.Value);
            fclose(fid);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 处理单选按钮状态改变，如有需要可以根据 src.Value 执行相应操作
            % disp('【控制是否打开撤销功能的开关】状态改变');
            % 此处可添加额外代码，例如更新相关参数
            if src.Value
                handles.msg.String = '打开时运行速度受显著影响！';
                %%%%%%%%%%%%%%% 检查historydata文件夹内的.mat文件数量 %%%%%%%%%%%%%%%
                folderOfThis = fileparts(mfilename('fullpath'));  % 获取当前.m文件所在的文件夹
                folderOfFB = fileparts(fileparts(folderOfThis));  % 获取FB文件夹
                folderOfHistory = fullfile(folderOfFB, 'historydata');  % 构建historydata文件夹路径
                
                % 获取historydata文件夹内所有的.mat文件
                matFiles = dir(fullfile(folderOfHistory, '*.mat'));
                numFiles = length(matFiles);
                
                % 如果文件数量超过200，则提醒用户及时清理
                if numFiles > 200
                    warningMsg = sprintf('当前historydata文件夹中.mat文件数量为 %d，已超过200个。请及时按下【建档-初始化】按钮清理，以免影响运行速度。', numFiles);
                    fprintf('%s\n', warningMsg);
                    handles.msg.String = '存档太多！【建档-初始化】清理，以免影响速度！';
                    % 可选：使用对话框提醒用户
                    % msgbox(warningMsg, '警告', 'warn');
                end
                
            else
                handles.msg.String = '存档/撤销功能已关闭！';
            end
        end
        
        function undo_Callback(src, eventdata, figHandle, handles)
            % disp('【撤销】按钮被点击');
            if handles.ishistory.Value == 0 % 只有存档按钮被按下才会存档
                handles.msg.String = ['请先打开【撤销功能控制】！'];
                return
            end
            disp('【开始】撤回，请勿动...')
            handles.msg.String = ['正在回退,请勿动...'];
            pause(0.01)
            % 历史记录区
            try
                main_history(handles,'load')
            catch
                handles.msg.String = ['回退失败,建议重新【建档】'];
                pause(0.01)
                return
            end
            
            handles.msg.String = ['全部回退成功'];
            disp('【结束】全部撤回成功！')
        end
        
        function archive_Callback(src, eventdata, figHandle, handles)
            if handles.ishistory.Value == 0 % 只有存档按钮被按下才会存档
                handles.msg.String = ['请先打开【撤销功能控制】！'];
                return
            end
            disp('【建档】正在初始化Figure历史数据库...')
            handles.msg.String = ['正在初始化数据库,请勿动...'];pause(0.01)
            % 历史记录区
            % 清理所有已有文件
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
            % 初始化文件
            try
                main_history(handles,'save') %
                handles.msg.String = ['初始化成功'];pause(0.01)
                disp('【完成】！')
            catch
                disp('【初始化失败】！')
                handles.msg.String = ['初始化失败'];
            end
            
        end
        
        function close_Callback(src, eventdata, figHandle, handles)
            % disp('【关闭】按钮被点击');
            % 隐藏撤销控制面板
            handles = guidata(figHandle);
            if isfield(handles, 'undoPanel') && ishandle(handles.undoPanel)
                set(handles.undoPanel, 'Visible', 'off');
            end
            guidata(figHandle, handles);
        end
    end
end

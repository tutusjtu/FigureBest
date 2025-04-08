classdef FBMoreCallbacks
    % FBMoreCallbacks 集中维护【更多】面板各子选项的回调函数
    methods(Static)
        function update_Callback(src, eventdata, figHandle, handles)
    % 禁用更新按钮，防止重复点击 / Disable the update button
    src.Enable = 'off';
    
    % 提示正在联网检查新版 / Inform the user that update checking is in progress
    handles.msg.String = '正在检查新版...';
    drawnow; % 强制界面刷新 / Force UI update
    
    try
        % 调用更新检查函数（假设为同步执行） / Call the update-check function (assumed synchronous)
        update_fb();        
        % 检查成功后的提示信息 / Success message
        disp('================')
        handles.msg.String = '完成 | 请查看Command窗口！';        
        disp('【如何部署？Apply?】法一、点击{部署新版}按钮，选择下载后的{压缩文件}，剩下的自动完成！');
        disp('【如何部署？Apply?】法二、解压{压缩文件}，全部添加到MATLAB工作路径，完成！');
    catch
        % 更新失败后的提示信息 / Failure message        
        handles.msg.String = '更新检查失败！请查看Command窗口的错误信息。 / Update check failed! Please see the Command Window for error details.';
        disp('【错误/Error】更新检查失败，请稍后重试！ / Update check failed, please try again later!');
    end
    
    % 无论成功或失败，都提示关注更新信息 / Always display the follow-us reminder
    disp('================')
    disp('如果失败，请检查网络！或关注公众号/B站 @图通道 获取更新!')
    disp('If issues persist, follow our public account/Bilibili channel @tutongdao for updates!');
    disp('================')
    % 重新启用更新按钮 / Re-enable the update button
    src.Enable = 'on';
end


        
        function sync_Callback(src, eventdata, figHandle, handles)
            %disp('【部署】按钮被点击');
            % 部署新的代码
            syncFbCode(true,handles);
        end
        
        function feedback_Callback(src, eventdata, figHandle, handles)
            % disp('【反馈】按钮被点击');
            handles.msg.String = '访问：https://www.wjx.cn/m/79855160.aspx';
            pause(0.01)
            disp('访问：https://www.wjx.cn/m/79855160.aspx')
            web('https://www.wjx.cn/m/79855160.aspx','-browser');
        end
        
        function tutorial_Callback(src, eventdata, figHandle, handles)
            % disp('【教程】按钮被点击');
            web('https://www.bilibili.com/video/BV1eu4y1s7Re','-browser');
        end
        
        function portfolio_Callback(src, eventdata, figHandle, handles)
handles.msg.String = '待开发用户社区功能';
        end
        
        function close_Callback(src, eventdata, figHandle, handles)
            % disp('【关闭】按钮被点击');
            % 隐藏【更多】面板
            handles = guidata(figHandle);
            if isfield(handles, 'morePanel') && ishandle(handles.morePanel)
                set(handles.morePanel, 'Visible', 'off');
            end
            guidata(figHandle, handles);
        end
    end
end

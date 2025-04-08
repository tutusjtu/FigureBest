classdef FBMoreCallbacks
    % FBMoreCallbacks ����ά�������ࡿ������ѡ��Ļص�����
    methods(Static)
        function update_Callback(src, eventdata, figHandle, handles)
    % ���ø��°�ť����ֹ�ظ���� / Disable the update button
    src.Enable = 'off';
    
    % ��ʾ������������°� / Inform the user that update checking is in progress
    handles.msg.String = '���ڼ���°�...';
    drawnow; % ǿ�ƽ���ˢ�� / Force UI update
    
    try
        % ���ø��¼�麯��������Ϊͬ��ִ�У� / Call the update-check function (assumed synchronous)
        update_fb();        
        % ���ɹ������ʾ��Ϣ / Success message
        disp('================')
        handles.msg.String = '��� | ��鿴Command���ڣ�';        
        disp('����β���Apply?����һ�����{�����°�}��ť��ѡ�����غ��{ѹ���ļ�}��ʣ�µ��Զ���ɣ�');
        disp('����β���Apply?����������ѹ{ѹ���ļ�}��ȫ����ӵ�MATLAB����·������ɣ�');
    catch
        % ����ʧ�ܺ����ʾ��Ϣ / Failure message        
        handles.msg.String = '���¼��ʧ�ܣ���鿴Command���ڵĴ�����Ϣ�� / Update check failed! Please see the Command Window for error details.';
        disp('������/Error�����¼��ʧ�ܣ����Ժ����ԣ� / Update check failed, please try again later!');
    end
    
    % ���۳ɹ���ʧ�ܣ�����ʾ��ע������Ϣ / Always display the follow-us reminder
    disp('================')
    disp('���ʧ�ܣ��������磡���ע���ں�/Bվ @ͼͨ�� ��ȡ����!')
    disp('If issues persist, follow our public account/Bilibili channel @tutongdao for updates!');
    disp('================')
    % �������ø��°�ť / Re-enable the update button
    src.Enable = 'on';
end


        
        function sync_Callback(src, eventdata, figHandle, handles)
            %disp('�����𡿰�ť�����');
            % �����µĴ���
            syncFbCode(true,handles);
        end
        
        function feedback_Callback(src, eventdata, figHandle, handles)
            % disp('����������ť�����');
            handles.msg.String = '���ʣ�https://www.wjx.cn/m/79855160.aspx';
            pause(0.01)
            disp('���ʣ�https://www.wjx.cn/m/79855160.aspx')
            web('https://www.wjx.cn/m/79855160.aspx','-browser');
        end
        
        function tutorial_Callback(src, eventdata, figHandle, handles)
            % disp('���̡̳���ť�����');
            web('https://www.bilibili.com/video/BV1eu4y1s7Re','-browser');
        end
        
        function portfolio_Callback(src, eventdata, figHandle, handles)
handles.msg.String = '�������û���������';
        end
        
        function close_Callback(src, eventdata, figHandle, handles)
            % disp('���رա���ť�����');
            % ���ء����ࡿ���
            handles = guidata(figHandle);
            if isfield(handles, 'morePanel') && ishandle(handles.morePanel)
                set(handles.morePanel, 'Visible', 'off');
            end
            guidata(figHandle, handles);
        end
    end
end

classdef CeshiCallbacks
    % CeshiCallbacks ����ά�� ceshi ������ѡ��Ļص�����
    methods(Static)
        function test1_Callback(src, eventdata, figHandle, handles)
            handles.msg.String = ['���ɲ���ͼ,����...'];pause(0.001)
            disp('=========test_FB code=========')
            disp('[FB����ͼԴ��]�����·�����ɲ鿴����ͼԴ����')
            disp('edit(''test_FB_1'')')
            disp('==============================')
            test_FB_1
            handles.msg.String = ['����ͼ����'];pause(0.001)
        end
        
        function test2_Callback(src, eventdata, figHandle, handles)
            handles.msg.String = ['���ɲ���ͼ,����...'];pause(0.001)
            disp('=========test_FB code=========')
            disp('[FB����ͼԴ��]�����·�����ɲ鿴����ͼԴ����')
            disp('edit(''test_FB_2'')')
            disp('==============================')
            test_FB_2
            handles.msg.String = ['����ͼ����'];pause(0.001)            
            % ���ڴ˴���Ӿ���Ĵ������
        end
        
        function test3_Callback(src, eventdata, figHandle, handles)
            handles.msg.String = ['���ɲ���ͼ,����...'];pause(0.001)
            disp('=========test_FB code=========')
            disp('[FB����ͼԴ��]�����·�����ɲ鿴����ͼԴ����')
            disp('edit(''test_FB_3'')')
            disp('==============================')
            test_FB_3
            handles.msg.String = ['����ͼ����'];pause(0.001)      
        end
        
        function close_Callback(src, eventdata, figHandle, handles)
            % ���� ceshi ���
            if isfield(handles, 'ceshiPanel') && ishandle(handles.ceshiPanel)
                set(handles.ceshiPanel, 'Visible', 'off');
            end
            guidata(figHandle, handles);
        end
    end
end

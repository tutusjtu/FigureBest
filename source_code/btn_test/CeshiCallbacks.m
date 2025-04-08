classdef CeshiCallbacks
    % CeshiCallbacks 集中维护 ceshi 面板各子选项的回调函数
    methods(Static)
        function test1_Callback(src, eventdata, figHandle, handles)
            handles.msg.String = ['生成测试图,请勿动...'];pause(0.001)
            disp('=========test_FB code=========')
            disp('[FB测试图源码]运行下方命令可查看测试图源代码')
            disp('edit(''test_FB_1'')')
            disp('==============================')
            test_FB_1
            handles.msg.String = ['测试图就绪'];pause(0.001)
        end
        
        function test2_Callback(src, eventdata, figHandle, handles)
            handles.msg.String = ['生成测试图,请勿动...'];pause(0.001)
            disp('=========test_FB code=========')
            disp('[FB测试图源码]运行下方命令可查看测试图源代码')
            disp('edit(''test_FB_2'')')
            disp('==============================')
            test_FB_2
            handles.msg.String = ['测试图就绪'];pause(0.001)            
            % 可在此处添加具体的处理代码
        end
        
        function test3_Callback(src, eventdata, figHandle, handles)
            handles.msg.String = ['生成测试图,请勿动...'];pause(0.001)
            disp('=========test_FB code=========')
            disp('[FB测试图源码]运行下方命令可查看测试图源代码')
            disp('edit(''test_FB_3'')')
            disp('==============================')
            test_FB_3
            handles.msg.String = ['测试图就绪'];pause(0.001)      
        end
        
        function close_Callback(src, eventdata, figHandle, handles)
            % 隐藏 ceshi 面板
            if isfield(handles, 'ceshiPanel') && ishandle(handles.ceshiPanel)
                set(handles.ceshiPanel, 'Visible', 'off');
            end
            guidata(figHandle, handles);
        end
    end
end

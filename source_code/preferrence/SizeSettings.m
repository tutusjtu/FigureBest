classdef SizeSettings
    methods(Static)
        function applySafePosition(mainHandles, pos)
            % 增强版本：带边界检查 + 置顶窗口
            originalUnits = get(mainHandles.figure1, 'Units');
            
            % 获取屏幕尺寸
            set(0, 'Units', 'pixels');
            screenSize = get(0, 'MonitorPositions');
            if size(screenSize,1) > 1
                screenSize = screenSize(1,:); % 使用主显示器
            end
            
            % 修正参数
            validatedPos = pos;
            validatedPos(1) = max(10, min(pos(1), screenSize(3)-pos(3)-10)); % 左边距
            validatedPos(2) = max(10, min(pos(2), screenSize(4)-pos(4)-10)); % 下边距
            
            % 应用并置顶
            set(mainHandles.figure1, 'Units', 'pixels');
            set(mainHandles.figure1, 'Position', validatedPos);
            figure(mainHandles.figure1); % 确保置顶
            set(mainHandles.figure1, 'Units', originalUnits);
        end
        function saveSizeSettings(filePath, pos)
            % 确保输入位置为像素值
            fid = fopen(filePath, 'w');
            if fid < 0, error('无法写入文件'); end
            fprintf(fid, 'left=%.2f\nbottom=%.2f\nwidth=%.2f\nheight=%.2f\nunits=pixels',...
                pos(1), pos(2), pos(3), pos(4));
            fclose(fid);
        end
        
        function pos = loadSizeSettings(filePath)
            pos = [];
            if ~exist(filePath, 'file'), return; end
            
            fid = fopen(filePath, 'r');
            data = textscan(fid, '%s %f', 'Delimiter', '=');
            fclose(fid);
            
            keys = data{1};
            vals = data{2};
            pos = zeros(1,4);
            for i = 1:length(keys)
                switch lower(keys{i})
                    case 'left',   pos(1) = vals(i);
                    case 'bottom', pos(2) = vals(i);
                    case 'width', pos(3) = vals(i);
                    case 'height', pos(4) = vals(i);
                end
            end
        end
        
        function applySize(mainHandles, pos)
            % 强制使用像素单位设置位置
            originalUnits = get(mainHandles.figure1, 'Units');
            set(mainHandles.figure1, 'Units', 'pixels');
            set(mainHandles.figure1, 'Position', pos);
            set(mainHandles.figure1, 'Units', originalUnits);
        end
    end
end
classdef SizeSettings
    methods(Static)
        function applySafePosition(mainHandles, pos)
            % ��ǿ�汾�����߽��� + �ö�����
            originalUnits = get(mainHandles.figure1, 'Units');
            
            % ��ȡ��Ļ�ߴ�
            set(0, 'Units', 'pixels');
            screenSize = get(0, 'MonitorPositions');
            if size(screenSize,1) > 1
                screenSize = screenSize(1,:); % ʹ������ʾ��
            end
            
            % ��������
            validatedPos = pos;
            validatedPos(1) = max(10, min(pos(1), screenSize(3)-pos(3)-10)); % ��߾�
            validatedPos(2) = max(10, min(pos(2), screenSize(4)-pos(4)-10)); % �±߾�
            
            % Ӧ�ò��ö�
            set(mainHandles.figure1, 'Units', 'pixels');
            set(mainHandles.figure1, 'Position', validatedPos);
            figure(mainHandles.figure1); % ȷ���ö�
            set(mainHandles.figure1, 'Units', originalUnits);
        end
        function saveSizeSettings(filePath, pos)
            % ȷ������λ��Ϊ����ֵ
            fid = fopen(filePath, 'w');
            if fid < 0, error('�޷�д���ļ�'); end
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
            % ǿ��ʹ�����ص�λ����λ��
            originalUnits = get(mainHandles.figure1, 'Units');
            set(mainHandles.figure1, 'Units', 'pixels');
            set(mainHandles.figure1, 'Position', pos);
            set(mainHandles.figure1, 'Units', originalUnits);
        end
    end
end
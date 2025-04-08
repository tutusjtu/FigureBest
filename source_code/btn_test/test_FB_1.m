%% ����������ͼ��
close all;  % �ر������Ѵ򿪵�ͼ�δ���

%% 1. ��������ͼ���������߰汾��
figure;                          % �½�ͼ�δ���
x = linspace(0, 10, 200);          % ���� 0 �� 10 ֮��� 200 ���������ݵ�
% ���ɶ����������ݣ�ÿ�����߾�����΢С����������������໥λ�ƣ�
y1 = sin(x) + 0.1 * randn(size(x));       % ��һ�����ߣ�sin(x) + ����
y2 = sin(x + 0.5) + 0.1 * randn(size(x));   % �ڶ������ߣ�sin(x+0.5) + ����
y3 = cos(x) + 0.1 * randn(size(x));         % ���������ߣ�cos(x) + ����
y4 = cos(x + 0.5) + 0.1 * randn(size(x));     % ���������ߣ�cos(x+0.5) + ����
% �����������ߣ��ֱ���ò�ͬ�����ͺͱ�ǣ��߿�Ϊ 1.5
plot(x, y1, '-o', x, y2, '-s', x, y3, '-d', x, y4, '-^', 'LineWidth', 1.5);
% ��ͼ��ͬʱ��ʾ 4 ������

%% 2. 2��2 ��ͼ���
figure;                         % �½�ͼ�δ���

% ��ͼ 1����������ͼ����������ϵ�У�
subplot(2,2,1);                 % �����ڷ�Ϊ 2 �� 2 �У�ѡ��� 1 ����ͼ����
t = linspace(0, 2*pi, 100);       % ���� 0 �� 2�� �� 100 ���������ݵ�
% ���������������ߣ�ԭʼ��������λƽ�ƺ������
plot(t, sin(t), 'b-', 'LineWidth', 1.5);
hold on;                        % ���ֵ�ǰͼ�Σ����ڵ��Ӻ�������
plot(t, sin(t + 0.3), 'r--', 'LineWidth', 1.5);
hold off;                       % ��������

% ��ͼ 2������ͼ����ϵ����״ͼ��
subplot(2,2,2);                 % ѡ��� 2 ����ͼ����
dataBar = randi([1,20], 4, 3);    % ���� 4��3 �������������4�飬ÿ�� 3 ��ϵ�У�
bar(dataBar);                   % ��������ͼ���Զ���ʾ��ϵ������

% ��ͼ 3��ɢ��ͼ�������ά��̬�ֲ����ݣ�
subplot(2,2,3);                 % ѡ��� 3 ����ͼ����
data1 = randn(50,2) + 1;          % ���ɵ�һ�� 50 ����ά��̬�ֲ����ݣ�������������ƽ��
data2 = randn(50,2) - 1;          % ���ɵڶ��� 50 ����ά��̬�ֲ����ݣ�������������ƽ��
scatter(data1(:,1), data1(:,2), 36, 'b', 'filled');  % ���Ƶ�һ��ɢ�㣨��ɫ��
hold on;                        % ���ֵ�ǰͼ��
scatter(data2(:,1), data2(:,2), 36, 'r', 'filled');  % ���Ƶڶ���ɢ�㣨��ɫ��
hold off;                       % ��������

% ��ͼ 4��Stem ͼ����ʾ������ɢ���ݣ�
subplot(2,2,4);                 % ѡ��� 4 ����ͼ����
xStem = linspace(0, 10, 20);      % ���� 20 ���������ݵ�
stem(xStem, cos(xStem), 'b', 'filled');    % ���Ƶ�һ�� Stem ͼ����ɫ�������ݣ�
hold on;                        % ���ֵ�ǰͼ��
stem(xStem, cos(xStem + 0.5), 'r', 'filled');% ���Ƶڶ��� Stem ͼ����ɫ��ƽ�� 0.5��
hold off;                       % ��������

%% 3. 4��4 ��ͼ���
figure;                          % �½�ͼ�δ���

% ��ͼ 1����������ͼ������ϵ�У�
subplot(4,4,[1 2]);                % �ϲ��� 1 �͵� 2 ������
t = linspace(0, 2*pi, 200);       % ���� 0 �� 2�� �� 200 �����ݵ�
plot(t, sin(t), 'b-', 'LineWidth', 1.5);   % ���� sin(t)
hold on;
plot(t, sin(t + 0.5), 'r--', 'LineWidth', 1.5); % ���� sin(t+0.5)
plot(t, sin(t + 1), 'g-.', 'LineWidth', 1.5);   % ���� sin(t+1)
hold off;

% ��ͼ 3����ϵ������ͼ
subplot(4,4,3);                % ѡ��� 3 ������
data = randi([1,10], 5, 3);      % ���� 5��3 �������������5�飬ÿ�� 3 ��ϵ�У�
bar(data);                     % ��������ͼ

% ��ͼ 4����ϵ��ɢ��ͼ
subplot(4,4,4);                % ѡ��� 4 ������
x1 = randn(30,1) + 1;            % ��һ�� x ����
y1 = randn(30,1) + 1;            % ��һ�� y ����
x2 = randn(30,1) - 1;            % �ڶ��� x ����
y2 = randn(30,1) - 1;            % �ڶ��� y ����
scatter(x1, y1, 36, 'b', 'filled');  % ���Ƶ�һ��ɢ��
hold on;
scatter(x2, y2, 36, 'r', 'filled');  % ���Ƶڶ���ɢ��
hold off;

% ��ͼ 5����ϵ�� Stem ͼ��ָ��˥��ϵ�У�
subplot(4,4,5);                % ѡ��� 5 ������
x_stem = linspace(0, 10, 20);     % ���� 20 ���������ݵ�
stem(x_stem, exp(-0.2 * x_stem), 'b', 'filled');  % ���Ƶ�һ�� Stem ͼ����ɫָ��˥����
hold on;
stem(x_stem, exp(-0.2 * x_stem) * 1.2, 'r', 'filled');  % ���Ƶڶ��� Stem ͼ����ɫ��
hold off;

% ��ͼ 6������ͼ���������ݣ�
subplot(4,4,6);                % ѡ��� 6 ������
x_err = linspace(0, 10, 20);      % ���� 20 �����ݵ�
y_err1 = sin(x_err);            % ��һ�����ݣ�sin(x)
y_err2 = sin(x_err + 0.3);        % �ڶ������ݣ�sin(x+0.3)
err1 = 0.2 * rand(1,20);           % ��һ�����
err2 = 0.2 * rand(1,20);           % �ڶ������
errorbar(x_err, y_err1, err1, 'b-o', 'LineWidth', 1.5);  % ���Ƶ�һ������ͼ
hold on;
errorbar(x_err, y_err2, err2, 'r-s', 'LineWidth', 1.5);  % ���Ƶڶ�������ͼ
hold off;

% ��ͼ 7������ֱ��ͼ��������̬�ֲ����ݣ�
subplot(4,4,[7 8]);                % �ϲ��� 7 �͵� 8 ������
data_hist1 = randn(1000,1);       % ��һ����̬�ֲ�����
data_hist2 = randn(1000,1) + 1;   % �ڶ�����̬�ֲ����ݣ���ֵƽ�ƣ�
histogram(data_hist1, 'Normalization', 'pdf', 'EdgeColor', 'none');  % ���Ƶ�һ��ֱ��ͼ
hold on;
histogram(data_hist2, 'Normalization', 'pdf', 'EdgeColor', 'none');  % ���Ƶڶ���ֱ��ͼ
hold off;

% ��ͼ 9����ͼ��imagesc ��ʾ peaks ���ݣ�
subplot(4,4,9);                % ѡ��� 9 ������
img = peaks(20);               % ���� 20��20 �� peaks ���ݣ�����ƽ�����й��ɣ�
imagesc(img);                  % �� imagesc ��ʾ��ͼ

% ��ͼ 10�����ͼ����ϵ�����ͼ��
subplot(4,4,10);               % ѡ��� 10 ������
area_data = [sin(t); cos(t)]';  % ����һ�� 2 ��������ݣ�ÿ��Ϊһϵ�У�
area(area_data);               % �������ͼ

% ��ͼ 11����������ͼ��ָ������ϵ�У�
subplot(4,4,11);               % ѡ��� 11 ������
plot(t, exp(0.1 * t), 'b-', 'LineWidth', 1.5);  % ����ָ����������
hold on;
plot(t, exp(0.1 * t) * 1.1, 'r--', 'LineWidth', 1.5);  % ����ƽ�ƺ��ָ������
plot(t, exp(0.1 * t) * 0.9, 'g-.', 'LineWidth', 1.5);   % ������һ������С������
hold off;

% ��ͼ 12����ϵ��ɢ��ͼ������������ݣ�
subplot(4,4,12);               % ѡ��� 12 ������
x_sc1 = randn(40,1);           % ��һ�� x ����
y_sc1 = randn(40,1);           % ��һ�� y ����
x_sc2 = randn(40,1) + 2;       % �ڶ��� x ���ݣ�����ƽ�ƣ�
y_sc2 = randn(40,1) + 2;       % �ڶ��� y ���ݣ�����ƽ�ƣ�
scatter(x_sc1, y_sc1, 36, 'b', 'filled');  % ���Ƶ�һ��ɢ��
hold on;
scatter(x_sc2, y_sc2, 36, 'r', 'filled');  % ���Ƶڶ���ɢ��
hold off;

% ��ͼ 13����������ͼ����������ϵ�У�
subplot(4,4,13);               % ѡ��� 13 ������
plot(t, log(1+t), 'b-', 'LineWidth', 1.5);  % ���� log(1+t)
hold on;
plot(t, log(1+t) * 1.2, 'r--', 'LineWidth', 1.5);  % ���ƷŴ��Ķ�������
plot(t, log(1+t) * 0.8, 'g-.', 'LineWidth', 1.5);   % ������С��Ķ�������
hold off;

% ��ͼ 14������ͼ����һ����ϵ�У�
subplot(4,4,14);               % ѡ��� 14 ������
x_err2 = linspace(0, 10, 20);       % ���� 20 �����ݵ�
y_err_a = cos(x_err2);         % ��һ�����ݣ�cos(x)
y_err_b = cos(x_err2 + 0.5);     % �ڶ������ݣ�cos(x+0.5)
err_a = 0.3 * rand(1,20);          % ��һ�����
err_b = 0.3 * rand(1,20);          % �ڶ������
errorbar(x_err2, y_err_a, err_a, 'b-o', 'LineWidth', 1.5);  % ���Ƶ�һ������ͼ
hold on;
errorbar(x_err2, y_err_b, err_b, 'r-s', 'LineWidth', 1.5);  % ���Ƶڶ�������ͼ
hold off;

% ��ͼ 15-16������ͼ����������������ݣ�
subplot(4,4,[15 16]);               % �ϲ�ѡ��� 15 �� 16 ������
x_stairs = linspace(0, 10, 20);    % ���� 20 ���������ݵ�
stairs(x_stairs, randi([1,10], 1, 20), 'b');  % ���Ƶ�һ�����ͼ����ɫ��
hold on;
stairs(x_stairs, randi([1,10], 1, 20), 'r');  % ���Ƶڶ������ͼ����ɫ��
hold off;

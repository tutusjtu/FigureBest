close all;  % �ر����д򿪵�ͼ�δ���

%% Figure 1: ��������ͼ��ʹ�����ҡ����Ҽ��䱶Ƶ������
figure;                          % �½�һ��ͼ�δ���
x = linspace(0, 10, 200);          % ���� 0 �� 10 �� 200 ����
y1 = sin(x) + 0.3*randn(1,200);    % ��һ�����ߣ�sin(x) ���������������
y2 = cos(x) + 0.3*randn(1,200);    % �ڶ������ߣ�cos(x) ���������������
y3 = sin(2*x) + 0.3*randn(1,200);  % ���������ߣ�sin(2x) ���������������
y4 = cos(2*x) + 0.3*randn(1,200);  % ���������ߣ�cos(2x) ���������������
% ���ƶ������ߣ����ò�ͬ�����ͺͱ�ǣ��߿���Ϊ 1.5
plot(x, y1, '-o', x, y2, '-s', x, y3, '-d', x, y4, '-^', 'LineWidth', 1.5);

%% Figure 2: 3D ɢ��ͼ������ 3D ������
figure;                          % �½�һ��ͼ�δ���
theta = linspace(0, 6*pi, 300);   % �ǶȲ������� 0 �� 6�У��ܹ� 300 ����
z = linspace(-2, 2, 300);          % z ����� -2 �� 2
r = linspace(0.5, 1.5, 300);       % �뾶�� 0.5 �����ӵ� 1.5
x3d = r .* cos(theta);           % ���� 3D ������ x ����
y3d = r .* sin(theta);           % ���� 3D ������ y ����
% ʹ�� scatter3 ���� 3D ɢ��ͼ�����СΪ 36����ɫ������ theta
scatter3(x3d, y3d, z, 36, theta, 'filled');

%% Figure 3: ����ͼ��ʹ������������ݣ�
figure;                          % �½�һ��ͼ�δ���
dataBar = randi([1, 20], 4, 5);    % ����һ�� 4��5 �ľ���Ԫ��Ϊ 1 �� 20 ֮����������
bar(dataBar);                    % ��������ͼ

%% Figure 4: ����ͼ��2D ��˹������
figure;                          % �½�һ��ͼ�δ���
xSurf = linspace(-3, 3, 100);      % x ����� -3 �� 3��100 ����
ySurf = linspace(-3, 3, 100);      % y ����� -3 �� 3��100 ����
[X, Y] = meshgrid(xSurf, ySurf);   % ���ɶ�ά��������
Z = exp(-(X.^2 + Y.^2));         % �����ά��˹������Բ�Գ�˥����
surf(X, Y, Z);                   % ������ά����ͼ
shading interp;                  % ʹ�ò�ֵ��ɫ��ʹ������ɫƽ������

%% Figure 5: 2��2 ��ͼ��ϣ���ͬͼ�Σ�
figure;                          % �½�һ��ͼ�δ���

% ��ͼ 1��������ݵ���ͼ
subplot(2,2,1);                % �ָ�ͼ��Ϊ 2��2 ����ѡ��� 1 ������
imagesc(rand(10));             % �� 10��10 �������������ͼ

% ��ͼ 2����������ָ��˥������
subplot(2,2,2);                % ѡ��� 2 ������
t = linspace(0, 5, 100);         % ���� 0 �� 5 �� 100 ����
plot(t, exp(-t) + 0.1*randn(1,100), '-o', 'LineWidth', 1.5);  % ����ָ��˥�����ߣ����������

% ��ͼ 3���������ɢ��ͼ
subplot(2,2,3);                % ѡ��� 3 ������
data1 = randn(50,2) + 2;         % ��һ�� 50 ���㣬����ƫ����
data2 = randn(50,2) - 2;         % �ڶ��� 50 ���㣬����ƫ����
scatter(data1(:,1), data1(:,2), 40, 'filled');  % ���Ƶ�һ��ɢ��
hold on;                       % ���ֵ�ǰͼ��
scatter(data2(:,1), data2(:,2), 40, 'filled');  % ���Ƶڶ���ɢ��

% ��ͼ 4�����ȷֲ����ݵ�ֱ��ͼ��ָ�����
subplot(2,2,4);                % ѡ��� 4 ������
dataHist = rand(1,1000);         % ���� 1000 �����ȷֲ����ݣ���Χ 0 �� 1��
histogram(dataHist, 'Normalization', 'pdf', 'EdgeColor', 'none');  % ����ֱ��ͼ����һ��Ϊ�����ܶ�
hold on;                       % ���ֵ�ǰͼ��
x_fit = linspace(0, 1, 100);     % ����������ߵ� x ����
fit_curve = exppdf(x_fit, 0.5);  % ����ָ�������ܶȺ�������ֵ 0.5��
plot(x_fit, fit_curve, 'LineWidth', 1.5);  % �����������

%% Figure 6: 3��3 ��ͼ��ϣ�����ͼ�Σ�
figure;                          % �½�һ��ͼ�δ���

% �ϲ���ͼ (1,1)��ʹ�����Ҿ�����������ͼ
subplot(3,3,[1 2 4 5]);         % �ϲ� 3��3 ���������� 1��2��4��5
dataMatrix = sin(linspace(0, pi, 12));  % ���� 12 ������ֵ
dataMatrix = reshape(dataMatrix, [3,4]); % �ع�Ϊ 3��4 ����
bar(dataMatrix);               % ��������ͼ

% ��ͼ 3���������ӵ�ɢ��ͼ����ƽ��Ч����
subplot(3,3,3);                % ѡ��� 3 ������
scatter(randn(20,1), randn(20,1), 'filled');  % ���Ƶ�һ�� 20 ��ɢ��
hold on;                       % ���ֵ�ǰͼ��
scatter(randn(20,1)+3, randn(20,1)+3, 'filled');  % ���Ƶڶ���ɢ�㣬������ƽ��

% ��ͼ 6������ͼ���������ݣ�
subplot(3,3,6);                % ѡ��� 6 ������
xErr = linspace(0, 10, 15);      % ���� 15 �� x ���ݵ�
yErr = sin(xErr);              % ���� sin(x)
errorbar(xErr, yErr, 0.2*rand(1,15), 'o-', 'LineWidth', 1.2);  % ��������ͼ�����Ϊ���ֵ

% �ϲ���ͼ (7,8)��٤��ֲ����ݵ�ֱ��ͼ
subplot(3,3,[7 8]);            % �ϲ� 3��3 ���������� 7 �� 8
dataGamma = gamrnd(2,2,1000,1);  % ���� 1000 ��٤��ֲ����ݣ���״���� 2���߶Ȳ��� 2��
histogram(dataGamma, 'Normalization', 'pdf', 'EdgeColor', 'none');  % ���ƹ�һ��ֱ��ͼ

% ��ͼ 9�� Stem ͼ���������У�
subplot(3,3,9);                % ѡ��� 9 ������
xStem = linspace(0, 2*pi, 20);   % ���� 20 ���㸲�� 0 �� 2��
stem(xStem, cos(xStem), 'filled');  % �������Һ����� Stem ͼ

%% Figure 7: ֱ��ͼ����̬�ֲ���ϣ�ʹ�ò�ͬ���ݣ�
figure;                          % �½�һ��ͼ�δ���
dataNormal = 3*randn(1000,1) + 1;  % ���� 1000 ����̬�ֲ����ݣ���ֵΪ 1����׼��Ϊ 3
histogram(dataNormal, 'Normalization', 'pdf', 'EdgeColor', 'none');  % ���ƹ�һ��ֱ��ͼ
hold on;                       % ���ֵ�ǰͼ��
xFit = linspace(min(dataNormal), max(dataNormal), 100);  % ����������ߵ� x ����
pdfNormal = normpdf(xFit, mean(dataNormal), std(dataNormal));  % ������̬�ֲ������ܶȺ���
plot(xFit, pdfNormal, 'LineWidth', 1.5);  % ������̬�ֲ��������

%% Figure 8: ����ͼ������ͼ��ϣ���ͬ���ݣ�
figure;                          % �½�һ��ͼ�δ���

% ��ͼ 1������ͼ��ʹ���������ݣ�
subplot(2,1,1);                % ��ͼ�δ��ڷ�Ϊ 2 �У�ѡ��� 1 ������
xErr2 = linspace(0, 8, 25);       % ���� 25 �� x ���ݵ�
yErr2 = cos(xErr2) + 0.1*randn(1,25);  % ��������ֵ��������������
errorbar(xErr2, yErr2, 0.3*rand(1,25), 'o-', 'LineWidth', 1.2);  % ��������ͼ

% ��ͼ 2������ͼ�����ݾ������������ɢ�ԣ�
subplot(2,1,2);                % ѡ��� 2 ������
dataBox = randn(50,5) .* repmat(linspace(1,3,5), 50, 1);  % ���� 50��5 ���ݣ���ͬ�����ݷ���������
boxplot(dataBox);              % ��������ͼ

%% Figure 9: 2��2 ��ͼ��ϣ��ȸ�����ɢ��ͼ��
figure;                          % �½�һ��ͼ�δ���

% ��ͼ 1�����ȸ���ͼ�����ҵ��Ƶĺ�����
subplot(2,2,1);                % ��ͼ�η�Ϊ 2��2��ѡ��� 1 ������
xC = linspace(-pi, pi, 80);       % ���� x ���ݣ��� -�� �� ��
yC = linspace(-pi, pi, 80);       % ���� y ���ݣ��� -�� �� ��
[Xc, Yc] = meshgrid(xC, yC);      % ���ɶ�ά����
Zc = cos(Xc).*sin(Yc);          % ���㺯��ֵ��cos(x)*sin(y)
contourf(Xc, Yc, Zc, 20, 'LineColor','none');  % ���� 20 �����ȸ���ͼ

% ��ͼ 2����ͨ�ȸ���ͼ�����溯����
subplot(2,2,2);                % ѡ��� 2 ������
[Xc2, Yc2] = meshgrid(linspace(-2,2,50));  % ���� x��y ��������
Zc2 = Xc2.^2 - Yc2.^2;          % ���㰰�溯����X^2 - Y^2
contour(Xc2, Yc2, Zc2, 20);      % ���� 20 ���ȸ���ͼ

% ��ͼ 3��ɢ��ͼ������Բ����
subplot(2,2,3);                % ѡ��� 3 ������
theta_scatter = linspace(0, 2*pi, 150);  % ���� 150 ���Ƕȵ�
r_scatter = 1 + 0.2*randn(1,150);  % �뾶Χ�� 1 ��������
xScatter2 = r_scatter .* cos(theta_scatter);  % ����Բ���� x ����
yScatter2 = r_scatter .* sin(theta_scatter);  % ����Բ���� y ����
scatter(xScatter2, yScatter2, 25, 'filled');  % ����ɢ��ͼ

% ��ͼ 4����������ɢ��ͼ���������� test.mat��������������ݣ�
subplot(2,2,4);                % ѡ��� 4 ������
if exist('test.mat','file')     % ����Ƿ���� test.mat �ļ�
    load test.mat;             % ��������������ݣ����� test Ϊ Nx2 ���飩
else
    test = [randn(150,1), randn(150,1)];  % �������� 150 �������ά���ݵ�
end
scatter(test(:,1), test(:,2), 'filled');  % ���Ʋ�������ɢ��ͼ

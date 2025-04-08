function fb()
%% %%%%%%%%%%%%%%% FigureBest �������� %%%%%%%%%%%%%%%
%
% ͼͨ��
% ֧�� macOS, Windows / MATLAB R2016a ���������еİ汾
%
% ---------------------------
% ����ΰ�װ���� fb��
%   1. ��ѹ�������
%   2. �������ļ�������һ����Ϊ�̶��Ҿ��ж���дȨ�޵�λ�ã�
%      ��������޷��������������������
%   3. ��һ������ʱ������ fb.m ������
%   4. �˺����㲽��2�������£�ֱ������ fb ����������
%      ����������Ҫ�����Զ�����·����
%
% ---------------------------
% �����������ٶ����Ų����⡿
%   - ��һ�����к󣬿ɽ������һ��`FigureBest_v4`�������ȫ��ע�͵���
%     �����������ٶ��Ҳ��Զ��л�·����
%   - ����ֿ��ٻ� java �౨�����ʵ����� java ���ڴ棺
%       Ԥ�� -> ���� -> java ���ڴ�
%   - ����д��Ȩ�����⣬���л���ǰ����Ŀ¼�����档
%   - �滻���֤�������´��Ϸ�ע�ͼ�顣
%   - ��������ʱ��ͨ���� set path ���ע�Ϳɽ����
% ---------------------------

%% �����Ŀ·����Ȩ��
currentFile = mfilename('fullpath');
[folderOfThis, ~, ~] = fileparts(currentFile);
try
    % ����һ����ʱ�����ļ�������·��
    testFile = fullfile(folderOfThis, 'temp_permission_test.txt');
    % ����д����ʱ�ļ�
    fid = fopen(testFile, 'w');
    % д������
    fclose(fid);delete(testFile);
catch
    errordlg(sprintf('��ǰĿ¼��%s û��д��Ȩ�ޡ�\n������洢·�����Թ���Ա������� MATLAB �Ը����Ŀ¼��дȨ�ޡ�', folderOfThis), ...
        'Ȩ�޴���', 'modal');
    return
end

%% ��ʾ������Ϣ
disp(['FB is loading from : ' folderOfThis ' ... ']);

%% ������
% ---------------------------
% PASS: UTF8 �� GBK
% WARNING: ��������
DefaultCharacterSet = feature('DefaultCharacterSet');
locale = feature('locale');
encoding = locale.encoding;
if ~strcmp(DefaultCharacterSet, 'GBK') || ~strcmp(encoding, 'GBK')
    disp(['[DefaultCharacterSet] ' DefaultCharacterSet '; [encoding] ' encoding])
    disp('���� GBK ���룬���ܻ�������룬����Ҫ���ܲ���Ӱ�죡')
    disp('����ܣ����޸�Ϊ GBK ���롣')
end

%% �������·������ע�͵���
% ������ӵ�ǰ�ļ��м������ļ��е�����·���������ñ�������
addpath(genpath(folderOfThis));pause(0.1)
savepath;
% �л�����Ŀ¼
cd(folderOfThis);

%% ����������
FigureBest_v4


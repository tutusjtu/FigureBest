function fb()
%% %%%%%%%%%%%%%%% FigureBest 启动程序 %%%%%%%%%%%%%%%
%
% 图通道
% 支持 macOS, Windows / MATLAB R2016a 及后续发行的版本
%
% ---------------------------
% 【如何安装启动 fb】
%   1. 解压代码包。
%   2. 将所有文件放置在一个较为固定且具有读、写权限的位置，
%      否则可能无法启动或产生功能隐患。
%   3. 第一次启动时，运行 fb.m 函数。
%   4. 此后，满足步骤2的条件下，直接输入 fb 快速启动。
%      上述步骤主要用于自动设置路径。
%
% ---------------------------
% 【提升启动速度与排查问题】
%   - 第一次运行后，可将除最后一行`FigureBest_v4`外的内容全部注释掉，
%     以提升启动速度且不自动切换路径。
%   - 如出现卡顿或 java 类报错，请适当增大 java 堆内存：
%       预设 -> 常规 -> java 堆内存
%   - 如遇写入权限问题，可切换当前工作目录至桌面。
%   - 替换许可证后建议重新打开上方注释检查。
%   - 遇到问题时，通常打开 set path 相关注释可解决。
% ---------------------------

%% 检测项目路径的权限
currentFile = mfilename('fullpath');
[folderOfThis, ~, ~] = fileparts(currentFile);
try
    % 构造一个临时测试文件的完整路径
    testFile = fullfile(folderOfThis, 'temp_permission_test.txt');
    % 尝试写入临时文件
    fid = fopen(testFile, 'w');
    % 写入内容
    fclose(fid);delete(testFile);
catch
    errordlg(sprintf('当前目录：%s 没有写入权限。\n请更换存储路径或以管理员身份运行 MATLAB 以赋予该目录读写权限。', folderOfThis), ...
        '权限错误', 'modal');
    return
end

%% 显示启动信息
disp(['FB is loading from : ' folderOfThis ' ... ']);

%% 编码检查
% ---------------------------
% PASS: UTF8 或 GBK
% WARNING: 其它编码
DefaultCharacterSet = feature('DefaultCharacterSet');
locale = feature('locale');
encoding = locale.encoding;
if ~strcmp(DefaultCharacterSet, 'GBK') || ~strcmp(encoding, 'GBK')
    disp(['[DefaultCharacterSet] ' DefaultCharacterSet '; [encoding] ' encoding])
    disp('若非 GBK 编码，可能会出现乱码，但主要功能不受影响！')
    disp('如可能，请修改为 GBK 编码。')
end

%% 添加搜索路径（可注释掉）
% 重新添加当前文件夹及其子文件夹到搜索路径，并永久保存设置
addpath(genpath(folderOfThis));pause(0.1)
savepath;
% 切换工作目录
cd(folderOfThis);

%% 启动主程序
FigureBest_v4


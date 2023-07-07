% 路径
SourcePath = 'Source\';
OutputPath = 'Output\';
CachePath = 'Cache\';

% 选择视频源
SourceName = 'ShinyDancer.mp4';
SourcePath = strcat(SourcePath,SourceName);
Source = VideoReader(SourcePath);

% 读取视频源数据
SourceFramesNum = Source.NumFrames;
SourceWidth = Source.Width;
SourceHeight = Source.Height;

% 创建输出视频文件并打开
OutputPath = strcat(OutputPath,SourceName);
Output = VideoWriter(OutputPath,'MPEG-4');  % mp4格式
open(Output);

% 帧遍历
for i=1:SourceFramesNum
    % 提取帧
    Frame = read(Source,i);
    % 边缘检测
    Frame = rgb2gray(Frame);    % 转灰度
    Roberts = edge(Frame,'roberts');    % Roberts算子边缘检测
    [x,y] = find(Roberts==1);   % 边缘点坐标
    % 绘制散点图，图片矩阵坐标从左上角开始从左到右，从上到下，
    % 向下x正，向右y正，要使输出散点图方向正确需要x、y互换并反转y，
    Frame = scatter(y,-x,'.');
    axis([0,SourceWidth,-SourceHeight,0],'equal'); % 保证比例正确
    % 保存图窗为jpg，因为无法直接变成图片对象写入，故先缓存下来
    Path = strcat(CachePath,SourceName,'_Cache.jpg');
    saveas(Frame,Path);
    % 读出缓存的边缘帧图写入输出视频文件
    Frame = imread(Path);
    writeVideo(Output,Frame);
end

close(Output);  % 关闭文件
delete(Path);   % 删除缓存文件

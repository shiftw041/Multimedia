% 隐写信息到图像中****************************
img1 = imread('inputgray.bmp');
img2 = double(img1);  % 转换为双精度浮点数以便修改

ctext1 = fopen('secret_meg.txt','r'); 
[msg,len] = fread(ctext1,'ubit1');  % 秘密信息转换为二进制序列

[m,n]=size(img2); % 获取图像大小
p=1;
rng(1,'twister'); % 设置随机数生成器的种子

for f2=1:n
    for f1=1:m
        % 随机选择一个像素的索引进行替换
        i = randi(m);  % 随机选择行
        j = randi(n);  % 随机选择列
        
        % 替换随机选择的像素的最低位
        img2(i,j) = img2(i,j) - mod(img2(i,j),2) + msg(p,1);
        
        % 移动到秘密信息的下一位
        if p==len
            break;
        end
        p=p+1;
    end
    if p==len
        break;
    end
end


disp(len);
img2=uint8(img2);   
imwrite(img2,'cimg2.bmp');
subplot(2,2,1);imshow(img1);title('原始图像');
subplot(2,2,2);imshow(img2);title('随机隐写图像');   % 显示图像和文字


count1=imhist(img1);
subplot(2,2,3);stem(0:20, count1(1:21));title('原始图像直方图');
ylim([0 2000]);
count2=imhist(img2);
subplot(2,2,4);stem(0:20, count2(1:21));title('随机隐写图像直方图');
ylim([0 2000]);

fclose(ctext1);
% 计算卡方统计量的函数
function p = prb(img_gray)
    count = imhist(img_gray);
    length = size(count, 1); % 获取直方图的灰度级数
    num = floor(length/2);
    r = 0; % 记录卡方统计量
    k = 0;
    for i = 1:num
        if (count(2*i-1) + count(2*i)) ~= 0
            r = r + (count(2*i-1) - count(2*i))^2 / (2 * (count(2*i-1) + count(2*i)));
            k = k + 1;
        end
    end
    p = 1 - chi2cdf(r, k - 1); % 计算卡方累积分布函数
end

% 使用该函数计算隐写后图像的卡方统计量
p_value = prb(img2);

% 显示结果
disp(['卡方统计量对应的累积概率 p 值为: ', num2str(p_value)]);

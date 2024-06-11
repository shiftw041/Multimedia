% 隐写信息到图像中******************************
img1 = imread('inputgray.bmp');
img2 = img1;
img2 = double(img2);  

ctext1 = fopen('secret_meg2.txt','r'); 
[msg,len] = fread(ctext1,'ubit1');  % 秘密信息转换为二进制序列

% 随机置换秘密信息以生成加密序列
encrypted_msg = zeros(1, len);
for i = 1:len
    bit_position = randi(len);  % 随机选择一个位置
    while bit_position == i  % 确保不选择相同的位置
        bit_position = randi(len);
    end
    encrypted_msg(i) = msg(bit_position);
end

[m,n]=size(img2); % m=512, n=512
p=1;
for f2=1:n
    for f1=1:m
        img2(f1,f2)=img2(f1,f2)-mod(img2(f1,f2),2)+msg(p,1);%encrypted_msg(p)
        % 主要算法，对每个像素点的灰度值的最低比特位替换为私密信息序列的每一比特信息
        % p = p - p mod 2 + msg
        p=p+1;
    end
end

%disp(len);
img2=uint8(img2);   
imwrite(img2,'cimg3.bmp');
subplot(2,2,1);imshow(img1);title('原始图像');
subplot(2,2,2);imshow(img2);title('隐写图像');   % 显示图像和文字


count1=imhist(img1);
subplot(2,2,3);stem(0:20, count1(1:21));title('原始图像直方图');
ylim([0 2000]);
count2=imhist(img2);
subplot(2,2,4);stem(0:20, count2(1:21));title('隐写图像直方图');
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

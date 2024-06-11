% 隐写信息到图像中******************************
img1 = imread('inputgray.bmp');
img2 = img1;
img2 = double(img2);  

ctext1 = fopen('secret_meg.txt','r'); 
[msg,len] = fread(ctext1,'ubit1');  % 秘密信息转换为二进制序列

[m,n]=size(img2); % m=512, n=512
p=1;
for f2=1:n
    for f1=1:m
        img2(f1,f2)=img2(f1,f2)-mod(img2(f1,f2),2)+msg(p,1);
        % 主要算法，对每个像素点的灰度值的最低比特位替换为私密信息序列的每一比特信息
        % p = p - p mod 2 + msg
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
imwrite(img2,'cimg1.bmp');
subplot(2,2,1);imshow(img1);title('原始图像');
subplot(2,2,2);imshow(img2);title('隐写图像');   % 显示图像和文字


count1=imhist(img1);
subplot(2,2,3);stem(0:20, count1(1:21));title('原始图像直方图');
ylim([0 2000]);
count2=imhist(img2);
subplot(2,2,4);stem(0:20, count2(1:21));title('隐写图像直方图');
ylim([0 2000]);

fclose(ctext1);


% 提取隐写的信息*****************************
Picture = imread('cimg1.bmp');
Picture = double(Picture);
[m,n]=size(Picture);
% 加载原始图像

frr=fopen('plsb1.txt','w');
% 打开存放秘密信息的文件
p=1;
for f2=1:n
   for f1=1:m
      if bitand(Picture(f1,f2),1)==1
         fwrite(frr,1,'ubit1');
         result(p,1)=1;
      else
         fwrite(frr,0,'ubit1');
         result(p,1)=0;
      end
      if p==len
          break;
      end
      if p<len
          p=p+1;
      end
   end
   if p==len
       break;
   end
end
fclose(frr);

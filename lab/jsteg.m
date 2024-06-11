cover='cover.jpg';
stego='F3.jpg';

try 
    jobj=jpeg_read(cover);
    dct=jobj.coef_arrays{1};
    dct1=jobj.coef_arrays{1};
catch
    error('Error(problem with the cover image)');
end
insertable = dct ~= 0 & dct ~= 1;
insertable(1:8:end, 1:8:end) = false;
AC=sum(insertable(:));%可嵌数据的AC系数数量

wen.txt_id=fopen('secret_meg2.txt','r');%隐藏的信息
[msg,L]=fread(wen.txt_id,'ubit1');
%msg=round(rand(AC,1));

len=length(msg);
id=1;
[m,n]=size(dct);
for f2 =1:n
    for f1 =1:m
        if(dct(f1,f2)==1 || dct(f1,f2) == 0)
            continue;
        end
        if(dct(f1,f2)>1)%dct系数大于1
            odd=mod(dct(f1,f2),2);
            if(msg(id,1)==0&&odd==1)%嵌入信息为0，AC系数为奇数
                dct(f1,f2)=dct(f1,f2)-1;
            end
            if(msg(id,1)==1 && odd==0)%嵌入信息为1，AC系数为偶数
               dct(f1,f2)=dct(f1,f2)+1;
            end
        end
        if(dct(f1,f2)<0)%dct系数小于0
            odd=abs(mod(dct(f1,f2),2));
            if(msg(id,1)==0&&odd==1)%嵌入信息为0，AC系数为奇数
                dct(f1,f2)=dct(f1,f2)-1;
            end
            if(msg(id,1)==1 && odd==0)%嵌入信息为1，AC系数为偶数
               dct(f1,f2)=dct(f1,f2)+1;
            end
        end
        if(id==len)
            break;
        end
        id=id+1;
    end
    if id ==len
        break;
    end
end

    
try 
    jobj.coef_arrays{1}=dct;
    jobj.optimize_coding=1;
    jpeg_write(jobj,stego);
catch
    error('ERROR (problem with saving the stego image)')
end

subplot(2,2,1);
imshow(cover);
title('原始图像');
subplot(2,2,2);
imshow(stego);
title('JSTEG隐写图像');
subplot(2,2,3);
histogram(dct1);
axis([-16 16,0 2e4]);
title('原始图像直方图');
subplot(2,2,4);
histogram(dct);
axis([-16 16,0 2e4]);
title('JSTEG隐写图像直方图');
            
            
            
        
            
            
        
            
            
            
        
    

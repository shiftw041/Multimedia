cover='cover.jpg';
stego='F4.jpg';

try 
    jobj=jpeg_read(cover);
    dct=jobj.coef_arrays{1};
    dct1=jobj.coef_arrays{1};
catch
    error('Error(problem with the cover image)');
end
AC=numel(dct)-numel(dct(1:8:end,1:8:end));

wen.txt_id=fopen('secret_meg2.txt','r');
[msg,L]=fread(wen.txt_id,'ubit1');
if(length(msg)>AC)
    error('ERROR(too long message)');
end
len=length(msg);
id=1;
[m,n]=size(dct);
for f2 =1:n
    for f1 =1:m
        if((dct(f1,f2))==0)
            continue;
        end
        if(dct(f1,f2)==1 &&msg(id,1)==0)
            dct(f1,f2)=0;
            continue;
        end
        
        if(dct(f1,f2)>=1)%正数
            odd=mod(dct(f1,f2),2);
            if(msg(id,1)~=odd)
                dct(f1,f2)=dct(f1,f2)-1;
            end
        end
        if(dct(f1,f2)==-1 &&msg(id,1)==1)
            dct(f1,f2)=0;
            continue;
        end
        if(dct(f1,f2)<=-1)
            odd=abs(mod(dct(f1,f2),2));
            if(msg(id,1)==odd)
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
title('F4隐写图像');
subplot(2,2,3);
histogram(dct1);
axis([-16 16,0 2e4]);
title('原始图像直方图');
subplot(2,2,4);
histogram(dct);
axis([-16 16,0 2e4]);
title('F4隐写图像直方图');
            
            
        
            
            
        
            
            
            
        
    

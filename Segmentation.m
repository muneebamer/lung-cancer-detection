function [out1, out2] = Segmentation(Img)

    img_threshold = Img;
    img_threshold(Img<100)=255;
    img_threshold(Img>100)=0;
    
    sobelFilter = fspecial('sobel');
    t=imfilter(double(img_threshold), sobelFilter, 'replicate');
    
    % Dilation
    se = strel('disk',1);
    out1 = imdilate(t,se);
    
    %edge detection
    temp = edge(out1);
    
    %performing dilation again
    se = strel('disk',1);
    out2 = imdilate(temp,se);
    
    return;
function [out1,out2,out3] = preProcessing(I)
    %Structuring element
    se = strel('line',1,1);
    img_t = I;
    img_t(I<100)=255;
    img_t(I>100)=0;
    out1 = img_t;
    %Perform thresholding
    % I refers to image threshold values
    %255 and 0 are assigned values
    
    [lbl,outl] = graythresh(I);
    
    %Histogram eq
    histEq=histeq(I);
    out2 = histEq;
    % Filtering
    %Laplacian or gaussian filter
    logFilter = fspecial('log');
    out3 = imfilter(double(out1), logFilter, 'replicate');
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    outl;
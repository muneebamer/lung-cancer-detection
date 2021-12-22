function [out1,out2,out3,out4,out5] = featureExtraction(Img)
    % mean of the image %
    out1 = mean2(Img);
    
    % entropy of the image %
    out2 = entropy(cast(Img,'double'));
    
    % contrast, homogenity and energy of the image %
    glcms = graycomatrix(Img);
    stats = graycoprops(glcms,{'contrast','homogeneity','energy'});
    
    out3 = stats.Energy;
    out4 = stats.Contrast;
    out5 = stats.Homogeneity;
    
    return
    
    
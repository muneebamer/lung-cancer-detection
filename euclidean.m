function [distance] = euclidean(x1,x2,x3,x4,x5,y1,y2,y3,y4,y5)
    distance = sqrt((y1-x1)^2 + (y2-x2)^2 + (y3-x3)^2 + (y4-x4)^2 + (y5-x5)^2);
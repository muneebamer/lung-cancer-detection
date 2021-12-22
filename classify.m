function class = classify(mean,ent,ene,cont,homo)
    data = readtable('centroids.csv');
    data = table2array(data);
    
    dist1 = euclidean(mean,ent,ene,cont,homo,data(1,1),data(1,2),data(1,3),data(1,4),data(1,5));
    dist2 = euclidean(mean,ent,ene,cont,homo,data(2,1),data(2,2),data(2,3),data(2,4),data(2,5));
    
    if (dist1<dist2)
        class = 1;
    else
        class = 2;
    end
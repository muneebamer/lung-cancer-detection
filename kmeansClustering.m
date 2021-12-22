close all; clear; clc;


%% Input dataset and number of clusters
k = 2;     % number of clusters
points = readtable('patientData.xlsx');
points= removevars(points,{'patient'});
A = table2array(points);
fprintf('Dataset of %d points will be divided in %d clusters.\n',height(points) ,k);

%% run function kmeans(P,k) to make clusters and calculating performance
fprintf('TRAINING...\n');
tic;
[labelled, centers] = kmeans(A,k); % MATLAB's k-means
timeTaken = toc;
%fprintf('Computation time for kmeans clustering: %d seconds.\n', timeTaken);

%% assigning data to clusters and counting
cluster1 = {};
cluster2 = {};

for i=1:length(A)
    if (labelled(i)==1)
        cluster1 = [cluster1;{A(i,2),A(i,3),A(i,5)}];
    else
        cluster2 = [cluster2;{A(i,2),A(i,3),A(i,5)}];
    end
end

fprintf('Values in cluster 1 are: %d.\n', length(cluster1));
fprintf('Values in cluster 2 are: %d.\n', length(cluster2));
%% save into new csv file

centroids = array2table(centers,'VariableNames',{'mean','entropy','energy','cont','homo'});
labels = array2table(labelled,'VariableNames',{'label'});

writetable(centroids,'centroids.csv');
writetable(labels,'labels.csv');
fprintf('FILES CREATED\n');


%% Differenciating features
entropy1 = cluster1(:,1);
energy1 = cluster1(:,2);
homo1 = cluster1(:,3);

entropy2 = cluster2(:,1);
energy2 = cluster2(:,2);
homo2 = cluster2(:,3);

entropy1= cell2mat(entropy1);
energy1= cell2mat(energy1);
homo1= cell2mat(homo1);

entropy2= cell2mat(entropy2);
energy2= cell2mat(energy2);
homo2= cell2mat(homo2);

centerEntropy = [centers(1,2);centers(2,2)];
centerEnergy = [centers(1,3);centers(2,3)];
centerHomo = [centers(1,5);centers(2,5)];

%% Plotting 
hold on;
plot3(entropy1,energy1,homo1,'ro');
plot3(entropy2,energy2,homo2,'go');
plot3(centerEntropy,centerEnergy,centerHomo,'kx','MarkerSize',20,'linewidth',3);
xlabel('Entropy');
ylabel('Energy');
zlabel('Contrast');
view(40,35);



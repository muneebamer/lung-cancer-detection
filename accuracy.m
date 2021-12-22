clc;
clear all;

%% loading data
train_feat = readtable('patientData.xlsx');
labels = readtable('testing.csv');

location = 'D:\University\Semester 8\FYP\Lung Cancer Detection\Training Data';
files = dir(location);

accuracies = [];

%% randomly choosing 10 patients and checking their labels
    
for b=1:8
    test_labels = [];
    r = int8(1 + (height(labels)-1) .* rand(10,1));
    for i=1:10

        fileName = strcat(location,'\patient',num2str(r(i)))
        pat_dir = dir(strcat(fileName,'\*.dcm'));

        for j=1:length(pat_dir)

            file = strcat(fileName,'\',pat_dir(i).name);
            I = dicomread(file);

        end 

        lbl = runClassification(I);

        if (lbl == 2)
            test_labels = [test_labels;0];
        else
            test_labels = [test_labels;1];
        end


    end

    correct = 0;

    for m=1:10
        lbl_arr = table2array(labels);
        if (test_labels(m) == lbl_arr(r(m)))
            correct = correct + 1;
        end
    end
    acc = correct/10
    accuracies = [accuracies;acc];
end
%% calculating final accuracy
sum = 0;
for i=1:8
    sum = sum + accuracies(i);
end

final_accuracy = int8((sum*100)/8);


fprintf("FINAL ACCURRACY: %d%%\n",final_accuracy);

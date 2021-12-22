function featuresCSV
    % browse files %
    fldPath = uigetdir();
    %Loop through Training Data
    for i=1:80
        foldName = strcat(fldPath,'\patient',num2str(i))
        srcFile = dir(strcat(foldName,'\*.dcm'));
        %Loop through dicom images of patient
        for j=1:length(srcFile)
            fileName = strcat(foldName,'\',srcFile(j).name);
            I = dicomread(fileName);
        end
        
        [dilated, edge_det] = Segmentation(I);
        
        % Feature Extraction %
        [mean, entr, ener, cont, homo] = featureExtraction(edge_det);
        patient = strcat('patient', num2str(i));
        
        %weightage = (mean+entr+ener+cont+homo)/5;
        %weightage2 = ((mean^2)+(entr^2)+(ener^2)+(cont^2)+(homo^2))/5;
        
        if (i==1)
            T = table(patient,mean,entr,ener,cont,homo);
        else
            cellPatients = {patient,mean,entr,ener,cont,homo};
            T = [T;cellPatients];
        end
    end
    
    filename = 'patientdata.xlsx';
       % xlswrite('patientdata.xlsx',T,'Output','F1');
    writetable(T,filename);
    
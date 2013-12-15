clear all;
close all;

images = {'im1s';'im3s'; 'im5s'; 'im6s'; 'im8s'; 'im9s'; 'im10s'; 'im13s'};

path = 'samples/';
suffix = '.jpg';
numImages = size(images,1);
numGrid = ceil(sqrt(numImages));


[referenceNames, referenceStrings] = textread(strcat(path, 'reference.txt'),'%q %q\n');

for i = 1:numImages
    
    %Read the image we want to test
    fileString = char(strcat(path,images{i},suffix));
    img = im2double(imread(fileString));
    
    %Run the main program
    outputString = beathoven(img);
        
    imageName = images(i);
    imageReferenceName = imageName(1:end-1);
    
    referenceIndex = 0;
    for j = 1:numel(referenceNames)
        chName = char(imageName);
        if (strcmp(char(referenceNames(j)), chName(1:end-1)))
            referenceIndex = j;
        end
    end
   
    if (referenceIndex) 
       ref = referenceStrings(referenceIndex);
       d = strdist(char(ref), outputString);
       failRate = double(d)/double(length(char(ref)));
       fprintf('%s %d %#5.0f \n', char(imageName), d, failRate*100);
       fprintf('ref: %s\n', char(ref));
       fprintf('out: %s\n', char(outputString)); 
    end   
end
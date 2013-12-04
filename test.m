clear all;
close all;
images = {'im1s';'im3s'; 'im5s'; 'im6s'; 'im8s'; 'im9s'; 'im10s'; 'im13s'};
path = 'samples/';
suffix = '.jpg';
numImages = size(images,1);
numGrid = ceil(sqrt(numImages));

h1 = figure(1);
set(1, 'name', 'Original Images');
h2 = figure(2);
set(2, 'name', 'Straightened');
h3 = figure(3);
set(3, 'name', 'Threshold');


for i = 1:numImages
    
    %Read the image we want to test
    fileString = char(strcat(path,images{i},suffix));
    img = im2double(imread(fileString));
    
    figure(h1);
    a = subplot(numGrid, numGrid, i);
    imshow(img);
    title(a, fileString);
    
    %Straighten the image
    straightened = straighten(img);
    
    
    figure(h2);
    b = subplot(numGrid, numGrid, i);
    imshow(straightened);
    title(b, fileString);
    
    %Threshold the image
    imgThresh = thresh(straightened);
    
   
    figure(h3);
    c = subplot(numGrid, numGrid, i);
    imshow(imgThresh);
    title(c, fileString);
    %Gets the staffs
    %staffDetection(imgThresh);
    
    
end

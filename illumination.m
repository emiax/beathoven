% http://www.mathworks.se/help/images/examples/correcting-nonuniform-illumination.html?s_eid=PSM_5532

function [ outputImage ] = illumination( inputImage )

%     h1 = figure(1);
%     set(1, 'name', 'Original Image');
%     h2 = figure(2);
%     set(2, 'name', 'Fixed');
%     h3 = figure(3);
%     set(3, 'name', 'Adjusted');
%     h4 = figure(4);
%     set(4, 'name', 'Binary')
    

    %Read image
%     I = imread('samples/im8c.jpg');
    I = inputImage;
    
%     figure(h1);
%     imshow(I)

    % Convert image to greyscale
    I = rgb2gray(I);
    % Invert image
    I = imcomplement(I);

    % Calculates the morphological opening and  
    % Subtracts it from the original image
    I2 = imtophat(I,strel('disk',15));
%     figure(h2);
%     imshow(I2);

    % Increases the image contrast                 
    I3 = imadjust(I2);
    I4 = imcomplement(I3);
%     figure(h3);
%     imshow(I3);

    % Create a new binary image
    % Remove background noise with bwareaopen
%     level = graythresh(I3);
%     bw = im2bw(I3,level);
%     bw = bwareaopen(bw, 50);
%     figure(h4);
%     imshow(bw);
    
    outputImage = I4;
end
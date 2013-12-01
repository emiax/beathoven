clear all;
close all;
%Read the image we want to test
img = im2double(imread('samples/im1s.jpg'));
figure(), imshow(img);


%Straighten the image
straightened = straighten(img);
figure(), imshow(straightened);

%Threshold the image
imgThresh = thresh(straightened);
figure(), imshow(imgThresh);

%Gets the staffs
staffs = staffDetection(imgThresh);
figure(), plot(staffs);
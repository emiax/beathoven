function [ outputImage ] = straighten( inputImage )
    %Converts input to edges (I.E, binary)
    I = rgb2gray(inputImage);
    BW = edge(I, 'canny');

    % Hough transform, with more detailed resolution than before.
    [H,T,R] = hough(BW,'Theta',-90:0.01:89.5);
    
    % Get only the first houghpeak
    P  = houghpeaks(H,1);
    
    % Pick out the angle
    angle = T(P(2));

    %Rotate the image
    outputImage = imrotate(inputImage, 90+angle);
end


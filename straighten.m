function [ outputImage ] = straighten( inputImage )
    %Converts input to edges (I.E, binary)
    I = rgb2gray(inputImage);
    BW = edge(I, 'canny');

    % Hough transform, with more detailed resolution than before.
    [H,T,R] = hough(BW,'Theta',-90:0.1:89.5);
    
    % Get only the first houghpeak
    P  = houghpeaks(H,1);
    
    % Pick out the angle
    angle = T(P(2)) + 90;

    if (angle > 90)
           angle = angle - 180;
    end
   
    
    %Rotate the image
    %Taken from http://www.mathworks.com/matlabcentral/answers/10089-image-rotate
    %In order to have white on the borders
    outputImage = imrotate(inputImage, angle);
    Mrot = ~imrotate(true(size(inputImage)),angle);
    outputImage(Mrot&~imclearborder(Mrot)) = 1;
end


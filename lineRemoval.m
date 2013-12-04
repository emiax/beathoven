function outputImage = staffRemoval(image, staffs)
    outputImage = double(image);
    yCoordinates = staffs(:)';
    [h, w] = size(image);
    for y = yCoordinates
        toTop = zeros(1, w);
        toBottom = zeros(1, w);
        
        for x = 1:w
            i = 0;   
            while (image(y - i, x) == 0) 
                i = i + 1;
            end
            toTop(x) = i;
            
            i = 0;   
            while (image(y + i, x) == 0) 
                i = i + 1;
            end
            toBottom(x) = i;
        end
        
        relevant = toTop(toTop>0);
        toTop = median(relevant);
        relevant = toBottom(toBottom>0);
        toBottom = median(relevant);
        
        size(y:y+toBottom)
        size(y+toBottom:y+2*toBottom)
        
        outputImage(y+1:y+toBottom, :) = 1; %image(y+1+toBottom:y+2*toBottom, :);
        outputImage(y-toTop:y, :) = 1; %image(y-2*toTop, y-toTop, :);
        
    end
    %outputImage = image;
    
    ones(toTop + toBottom - 1, 1)
    outputImage = max(image, imerode(outputImage, ones(2*(toTop + toBottom), 1)));
    
    figure
    imshow(image);
    figure
    imshow(outputImage);
end

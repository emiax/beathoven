% Returns a matrix of n*5 elements, where n is the number of staffs.

function stemsImage = findStems(noLinesImage, lines)
    
    noLinesImage = 1 - noLinesImage;

    lineDist = mean(mean(lines(:,2:5) - lines(:, 1:4)));
    opened = imopen(noLinesImage, ones(round(2.2*lineDist), 1)); 
        
    %[h, w] = size(noLinesImage);
    %image = zeros(h, w, 3);
    
    %image(:, :, 1) = noLinesImage;
    %image(:, :, 2) = opened;
    
    %image(:, :, 3) = opened;
    %figure();
    %imshow(image);
    
    stemsImage = 1 - opened;
    
end

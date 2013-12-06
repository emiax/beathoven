function outputImage = lineRemoval(image, staffs)



    image = ~image;
    
    figure(); imshow(image);
    lines = double(image);
    
    outputImage = double(image);
    yCoordinates = staffs(:)';
    [h, w] = size(image);
    for y = yCoordinates
        toTop = zeros(1, w);
        toBottom = zeros(1, w);
        
        for x = 1:w
            i = 0;   
            while (image(y - i, x) == 1) 
                i = i + 1;
            end
            toTop(x) = i;
            
            i = 0;   
            while (image(y + i, x) == 1) 
                i = i + 1;
            end
            toBottom(x) = i;
        end
        
        relevant = toTop;%(toTop>0);
        toTop = median(relevant) + 1;
        relevant = toBottom;%(toBottom>0);
        toBottom = median(relevant) + 1;
        
        %size(y:y+toBottom)
        %size(y+toBottom:y+2*toBottom)
        
        
        %over = image(y+toBottom, :)
        %(x') * ones(1,3)
        %size((image(y+toBottom + 2, :)*ones(toBottom+1, 1))')
        %size(outputImage(y:y+toBottom, :))
        %outputImage(y:y+toBottom, :) = (image(y+toBottom + 2, :)'*ones(toBottom+1, 1))';
      
        %outputImage(y:y-toTop-1, :) = image(y-toTop - 2, :);
        
        for yi = y-toTop:y+toBottom
            lines(yi, :) = 0.5;
            outputImage(yi, :) = image(y + toBottom + 1, :) + image(y - toTop - 1, :) > 1;
        end
        
        
        
        
        ; %image(y+1+toBottom:y+2*toBottom, :);
        %lines(y+toBottom-1:y, :) = 1; 
        %lines(y-toTop+1:y, :) = 1; %image(y-2*toTop, y-toTop, :);
        
    end
    
    outputImage = imerode(outputImage, [1 1 1]');
    outputImage = imdilate(outputImage, [1 1 1]');
    %outputImage = bwmorph(outputImage, 'open');
    
    figure(); imshow(lines);
    %outputImage = image;
    
    %se = ones((toTop + toBottom), 1);
    %outputImage = lines;
    %outputImage = image;
        
    %outputImage = lines; %imdilate(outputImage, se);
    
    %figure
    %imshow(image);
    %figure
    %imshow(outputImage);
end

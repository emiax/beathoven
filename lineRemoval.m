function outputImage = lineRemoval(image, staffs)
    outputImage = 1 - image;
    image = rgb2gray(1 - image);
    dimage = image;
    lines = image;
    
    
    yCoordinates = staffs(:)'; % all staff lines, no matter which of the five different ones.
    lineDist = mean(mean(staffs(:,2:5) - staffs(:, 1:4)));
    
    staffs
    
    lineSeeds = zeros(size(image));
    for y = yCoordinates
        lineSeeds(y,:) = 1;
    end
        
    lineSeeds = imdilate(lineSeeds, ones(3, 3));
    
    theFilter = fspecial('gaussian', [1 ceil(8*lineDist)], 2*lineDist);
    onlyLines = imfilter(image, theFilter);
    onlyLines = double(im2bw(onlyLines, graythresh(onlyLines)));
    onlyLines = imreconstruct(lineSeeds, onlyLines);
    
    %imshow(onlyLines/max(max(onlyLines)));
    
    distances = zeros(size(image));
    
        outputImage(:, :, 2) = 0;
        outputImage(:, :, 3) = 0;    
    
    [h, w] = size(image);
    
    
    
    lineMask = zeros(size(image));
    for y = yCoordinates
        toTop = zeros(1, w);
        toBottom = zeros(1, w);
        
        for x = 1:w
            i = 0;   
            while (onlyLines(y - i, x) == 1) 
                i = i + 1;
            end
            toTop(x) = min(i, lineDist/3);
            
            
            i = 0;   
            while (onlyLines(y + i, x) == 1) 
                i = i + 1;
            end
            toBottom(x) = min(i, lineDist/3);
            distances(y, x) = min(toTop(x), toBottom(x));
        end
       
    
        relevant = toTop(toTop>0);
        toTop = mean(relevant);
        relevant = toBottom(toBottom>0);
        toBottom = mean(relevant);
        
        if isnan(toTop)
            toTop = 0;
        end
        if isnan(toBottom)
            toBottom = 0;
        end
        
        lineHeight = toTop + toBottom;
               
        toTop = round(toTop);
        toBottom = round(toBottom);
                
        ymin = y-toTop;
        ymax = y+toBottom;

        for yi = ymin:ymax
            
            t = (yi - ymin) / (ymax - ymin);
            line = dimage(ymax + 1, :).*t + dimage(ymin - 1, :).*(1-t);
            lines(yi, :) = line;
            outputImage(yi, :, 1) = line;
            outputImage(yi, :, 2) = line;
            lineMask(yi, :) = 1;
        end
        
        st = ones(ceil(lineHeight), 1);
        new = imerode(image, st);
        old = zeros(size(image));
        
        while new ~= old
            old = new;
            new = imdilate(old, st);
        end
        
        outputImage = new;

    end

    outputImage = 1-outputImage;
    %outputImage = imerode(outputImage, [1 1 1 1 1]');
    %outputImage = imdilate(outputImage, [1 1 1 1 1]');
    %outputImage = bwmorph(outputImage, 'open');
    
    %figure(); imshow(lines);
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

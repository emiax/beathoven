function outputImage = lineRemoval(image, staffs)
    %outputImage = 1 - image;
    image = 1 - image;
    dimage = image;
    lines = image;
    
    
    % all staff lines, no matter which of the five different ones.
    yCoordinates = staffs(:)';
    
    %Distance between lines in one staff
    lineDist = mean(mean(staffs(:,2:5) - staffs(:, 1:4)));
%     
%     %Create an image with ones along the detected lines' y-coordinates
%     lineSeeds = zeros(size(image));
%     for y = yCoordinates
%         lineSeeds(y,:) = 1;
%     end
%         
%     %grow lines a bit
%     lineSeeds = imdilate(lineSeeds, ones(3, 3));
%     
%     % Blur the image along the x-axis, and only keep the high intensity pixels.
%     % This will keep lines and remove other elements. 
%     gaussianFilter = fspecial('gaussian', [1 ceil(8*lineDist)], 2*lineDist);
%     onlyLines = imfilter(image, gaussianFilter);
%     onlyLines = double(im2bw(onlyLines, graythresh(onlyLines)));
%     onlyLines = lineSeeds + onlyLines > 1;
%     
%     figure();
%     imshow(onlyLines);
%     
%     %onlyLines can now be used to get a better estimate of how thick the
%     %lines are. 
% 
%     [~, w] = size(image);
%     
%     toTop = zeros(length(yCoordinates(:)), w);
%     toBottom = zeros(length(yCoordinates(:)), w);
%     yIndex = 1;
%     for y = yCoordinates(1,:)
%         for x = 1:w
%             i = 0;   
%             while (onlyLines(y - i, x) == 1) 
%                 i = i + 1;
%             end
%             toTop(yIndex, x) = min(i, lineDist/3);
%             
%             i = 0;   
%             while (onlyLines(y + i, x) == 1) 
%                 i = i + 1;
%             end
%             toBottom(yIndex, x) = min(i, lineDist/3);
%         end
%         yIndex = yIndex + 1;
%     end
%        
%     toTop = toTop(:);
%     toBottom = toBottom(:);
% 
%     relevant = toTop(toTop>0);
%     toTop = median(relevant);
%     relevant = toBottom(toBottom>0);
%     toBottom = median(relevant);
% 
%     if isnan(toTop)
%         toTop = 0;
%     end
%     if isnan(toBottom)
%         toBottom = 0;
%     end
% 
%     lineHeight = toTop + toBottom;
% 
%     st = ones(round(lineHeight)+1, 1);
%     %interpolated = mod(lineHeight, 1);
%     
%     %st(1) = 1-0.5*interpolated;
%     %st(ceil(lineHeight)) = 1-0.5*interpolated;
    
    
    %lineHeight
    %lineDist
    st = ones(floor(lineDist/2), 1);
    
    %new = imerode(image, st);
    new = imopen(image, st);
    
    
    outputImage = new;

    %figure();
    %imshow(outputImage);
    
    outputImage = 1-outputImage;
end

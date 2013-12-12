function [ noteHeads ] = noteHeadDetection( imgNoLines, lines)

    
    imgNoLines =  1 - (double(imgNoLines) ./ max(max(max(double(imgNoLines)))));
    [h,w] = size(imgNoLines);   

    lineDist = floor(mean(mean(lines(:,2:5) - lines(:, 1:4))));


    str = strel('ball', round(lineDist/3), 1, 2);

    str = str.getnhood.*str.getheight;

    str = imresize(str, 'Scale', [1,1.2]);
    str = imrotate(str, 45, 'bilinear');

    %bwImg = thresh(staff);  
    %morphed = bwmorph(bwImg, 'clean', Inf);
    %closed = imfill(staff);

    correlation = imopen(imgNoLines, round(str));

    
    noteHeads = 1 - (correlation./max(max(double(correlation))));
    
    %debugImage = zeros(zeros(h,w,3));
    %debugImage(:,:,3) = noteHeads;
    %debugImage(:,:,2) = imgNoLines;
    %figure();
    %imshow(debugImage);
    
end


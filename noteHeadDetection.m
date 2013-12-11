function [ noteHeads ] = noteHeadDetection( imgNoLines, staffBounds , lines)


    imgNoLines =  (double(imgNoLines) ./ max(max(max(double(imgNoLines)))));


    lineDist = floor(mean(mean(lines(:,2:5) - lines(:, 1:4))));


    str = strel('ball', round(lineDist/3), 1, 2);

    str = str.getnhood.*str.getheight;

    str = imresize(str, 'Scale', [1,1.2]);
    str = imrotate(str, 45, 'bilinear');

    staff = imgNoLines(staffBounds(i,1):staffBounds(i,2),:);
    %bwImg = thresh(staff);  
    %morphed = bwmorph(bwImg, 'clean', Inf);
    %closed = imfill(staff);

    correlation = imopen(staff, round(str));

    noteHeads = correlation./max(max(double(correlation)));

end


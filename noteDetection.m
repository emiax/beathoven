function [ noteBounds ] = noteDetection( imgNoLines, staffBounds , lines)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%     lineDist = floor(mean(mean(lines(:,2:5) - lines(:, 1:4))));
%     se = strel('ball',lineDist,1,0);
%     
%     convuluted = filter2(double(se.getnhood),double(imgNoLines));
%     convuluted = convuluted./max(max(convuluted));
% 
%     imshow(convuluted == 1)
    for i = 1:length(staffBounds)

        img = thresh(imgNoLines(staffBounds(i,1):staffBounds(i,2), :));
        figure();
        imshow(img);
        hold on
        L = logical(img);
        s = regionprops(L,'BoundingBox');
        
            for j = 1:length(s)
                sj = s(j);
                rectangle('Position', sj.BoundingBox,'EdgeColor','r');
            end
            %vislabels(L);
    end
end


function [ noteBounds ] = noteHeadDetection( imgNoLines, staffBounds , lines)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%     lineDist = floor(mean(mean(lines(:,2:5) - lines(:, 1:4))));
%     se = strel('ball',lineDist,1,0);
%     
%     convuluted = filter2(double(se.getnhood),double(imgNoLines));
%     convuluted = convuluted./max(max(convuluted));
% 
%     imshow(convuluted == 1)

    imgNoLines =  (double(imgNoLines) ./ max(max(max(double(imgNoLines)))));
    for i = 1:length(staffBounds)
        
        %vertHist = vertProj(bwImg);
        %figure();
        %plot(vertHist);
%         se = strel('ball', R, H, N)
%         


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

        correlation = correlation./max(max(double(correlation)));

%       
%       
%         L = logical(morphed);
%         s = regionprops(L,'BoundingBox');
%          
%              for j = 1:length(s)
%                  sj = s(j);
%                  rectangle('Position', sj.BoundingBox,'EdgeColor','r');
%              end
%              %vislabels(L);
    end
end


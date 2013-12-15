function [boxes, headCentroids, flagPositions] = boundingBoxes(stems, heads, lineDist)
    both = (stems + heads) > 0;
    both = imdilate(both, ones(round(lineDist*1/3)));

    [h, w] = size(stems);

    %categorization = zeros(h, w, 3);
    %categorization(:, :, 1) = heads;
    %categorization(:, :, 2) = stems;
    %categorization(:, :, 3) = 1-heads-stems;
    
    labels = bwlabel(both, 8);
    boxesStruct = regionprops(labels, 'BoundingBox');
    nBoxes = numel(boxesStruct);
    
    boxes = zeros(nBoxes, 4);
    for i = 1:nBoxes;    
        boxes(i,1:4) = boxesStruct(i).BoundingBox;
    end
    
    boxes = sortrows(boxes, 1);
  
    headCentroids = cell([nBoxes, 1]);
    headAreas = cell([nBoxes, 1]);
    flagPositions = zeros(nBoxes, 3);
    
    [nBoxes, ~] = size(boxes);

    for i = 1:nBoxes;

        bb = round(boxes(i, 1:4));
        
        x = max(bb(1), 1); y = max(bb(2), 1); x2 = min(x+bb(3), w); y2 = min(y+bb(4), h);
         
        stemXOffset = 0;
        [~, stemXOffset] = max(vertProj(stems(y:y2,x:x2)));
        
        
        localHeads = heads(y:y2,x:x2);
        headLabels = bwlabel(localHeads);
        headCentroidsStruct = regionprops(headLabels, 'Centroid', 'Area');

        nHeads = numel(headCentroidsStruct);
        
        foundInTop = [];
        foundInBottom = [];
        
        for j = 1:nHeads
           hb = headCentroidsStruct(j).Centroid;
           ha = headCentroidsStruct(j).Area;
           
           
           headX = x+hb(1);
           headY = y+hb(2);
           
           %plot(headX, headY, 'gx');
           %plot(headX, topLine, 'rx');
           %plot(headX, bottomLine, 'mx');
           %headX = x+hbb(1)+hbb(3)/2;
           %headY = y+hbb(2)+hbb(4)/2;
           
           headArea = y+ha;
           
           ratio = (headY - y) / (y2 - y);
           
           if (ratio > 3/4)
               foundInBottom(end + 1) = j;
           elseif (ratio < 1/4) 
               foundInTop(end + 1) = j;
           end
           
           headCentroids{i}(j,:) = [headX headY];
           headAreas{i}(j) = headArea;
        end
        

        topArea = sum(headAreas{i}(foundInTop));
        bottomArea = sum(headAreas{i}(foundInBottom));
        
        %if the majority of note head areas is at the bottom om the stem,
        % nullify the found potential heads in the bottom, and vice versa.       
        if (topArea >= bottomArea) 
            flagPositions(i,:) = [y+2*(y2-y)/3 - lineDist/2, y2 + lineDist/2, x + stemXOffset];
            if (~isempty(foundInBottom))
                headCentroids{i}(foundInBottom',:) = [];
            end
        elseif (bottomArea >= topArea)
            flagPositions(i,:) = [y - lineDist/2, y+(y2-y)/3 + lineDist/2, x + stemXOffset];
            if (~isempty(foundInTop))
                headCentroids{i}(foundInTop',:) = [];           
            end
        end
        
        % if no head is found either in top or bottom of stem, nullify the
        % note.
        if (bottomArea == 0 && topArea == 0)
            headCentroids{i} = [];
        end
    end

    % uncomment for debugging
    %figure();
    %imshow(categorization); hold on;
    %for i = 1:nBoxes
    %    rectangle('Position', boxes(i, :), 'EdgeColor','r');
    %    [nHeads, ~] = size(headCentroids{i});
    %    
    %    for j = 1:nHeads
    %        
    %        x = headCentroids{i}(j, 1);
    %        y = headCentroids{i}(j, 2);
    %        plot(x, y,'g.');
    %    end
    %end
end



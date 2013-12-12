function [boxes, headCentroids] = boundingBoxes(stems, heads, lineDist)
  both = (stems + heads) > 0;
    both = imdilate(both, ones(round(lineDist*1/3)));

    [h, w] = size(stems);

    categorization = zeros(h, w, 3);
    categorization(:, :, 1) = heads;
    categorization(:, :, 2) = stems;
    categorization(:, :, 3) = both;
    
        

    
    labels = bwlabel(both, 8);
    boxesStruct = regionprops(labels, 'BoundingBox');
    nBoxes = numel(boxesStruct);
    
    boxes = zeros(nBoxes, 4);
    for i = 1:nBoxes;    
        boxes(i,1:4) = boxesStruct(i).BoundingBox;
    end
    
   
    
    boxes = sortrows(boxes, 1);
  
    headCentroids = cell([nBoxes, 1]);
    warning off;
    for i = 1:size(boxes,1);
        
        bb = boxes(i, 1:size(boxes,2));
        x = bb(1); y = bb(2); w = bb(3); h = bb(4);

        localHeads = heads(y:y+h,x:x+w);
        headLabels = bwlabel(localHeads);
        headCentroidsStruct = regionprops(headLabels, 'Centroid');

        nHeads = numel(headCentroidsStruct);
        
        for j = 1:nHeads
           hb = headCentroidsStruct(j).Centroid;
           headCentroids{i}(j,:) = [x+hb(1) y+hb(2)];           
           %rectangle('Position', [x+hb(1) y+hb(2) hb(3) hb(4)], 'EdgeColor','g');
        end         
    end
    warning on;

    
    % uncomment for debugging
    figure();
    imshow(categorization); hold on;
    for i = 1:nBoxes
        rectangle('Position', boxes(i, :), 'EdgeColor','r');
        [nHeads, ~] = size(headCentroids{i});
        nHeads
        for j = 1:nHeads
            headCentroids{i}(j, :)
            plot(headCentroids{i}(j, :),'g.');
        end
    end
%         
%     
%
end



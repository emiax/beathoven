function [ stems, heads, misc ] = categoirze( imageNoLines, lines ) 

    
    %only stems
    stemsImage = stemDetection(imageNoLines, lines);
    
    %only heads
    headsImage = noteHeadDetection(imageNoLines, lines);
    
        
    %thresh heads
    heads = 1 - headsImage;
    threshold = graythresh(heads);
    heads = im2bw(heads, threshold);
   
    %thresh stems
    stems = 1 - stemsImage;
    threshold = graythresh(stems);
    stems = im2bw(stems, threshold);
    
    
    thinStems = bwmorph(stems, 'thin');
    %bottoms = bwhitmiss(thinStems, [0 0 0; 0 1 0; -1 -1 -1]);
    %tops = bwhitmiss(thinStems, [-1 -1 -1; 0 1 0; 0 0 0]);
    %bottomsAndTops = (bottoms + tops) > 0;
    
    lineDist = mean(mean(lines(:,2:5) - lines(:, 1:4)));
    %areas = bwdist(bottomsAndTops) < lineDist*(2/3);
    
    areas = bwdist(thinStems) < lineDist*(2/3);
    
    areas = (areas + heads) > 1;
    
    stems = imreconstruct(imdilate(areas, ones(round(lineDist*2/3))), stems);
    heads = imreconstruct(areas, heads);
   
        
    misc = (1 - imageNoLines) - (1 - stemsImage) - (1 - headsImage);
    %misc = ( 1 - imageNoLines - stems - heads); % stemsImage + headsImage - 1 - imageNoLines;
    
    
    
    
    %[h, w] = size(imageNoLines);
    %rgbImg = zeros(h, w, 3);
    %rgbImg(:,:,1) = stems;
    %rgbImg(:,:,2) = heads;
    %rgbImg(:,:,3) = misc;
    %figure();
    %imshow(rgbImg);
    
end
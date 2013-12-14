function values = noteValue( flagPositions, img, lineDist)
    

    [h, ~] = size(flagPositions);

  
   
    
    values = zeros(h, 1);
    
    [height, width] = size(img);
    img = max(zeros(height, width), img);
    img = img/max(max(img));
    
    %figure(); 
    %imshow(img);
    %hold on;
    
    for i = 1:h
       y1 = round(max(flagPositions(i,1), 1));
       y2 = round(min(flagPositions(i,2), height));
       
       x1 = round(max(flagPositions(i,3) - lineDist/2, 1));
       x2 = round(min(flagPositions(i,3), width));
       
       %plot([x1 x1 x2 x2 x1], [y1 y2 y2 y1 y1], 'g') ;%
       
       
       projection = horProj(img(y1:y2,x1:x2));
       warning off;
       [pks,leftLocs] = findpeaks(projection, 'MINPEAKDISTANCE', 4, 'MINPEAKHEIGHT', 0.2);
       warning on;
      for j = 1:length(leftLocs)
          %plot((x1+x2)/2, (y1+leftLocs(j)+y1+leftLocs(j))/2, 'rx') ;
       end
       
       
       
       
       x1 = round(max(flagPositions(i,3), 1));
       x2 = round(min(flagPositions(i,3) + lineDist/2, width));
   
       %plot([x1 x1 x2 x2 x1], [y1 y2 y2 y1 y1], 'g') ;
       
       
       projection = horProj(img(y1:y2,x1:x2));
      % figure();
      % plot(projection);
       warning off;
       [pks,rightLocs] = findpeaks(projection, 'MINPEAKDISTANCE', 4, 'MINPEAKHEIGHT', 0.2);
       warning on;
       for j = 1:length(rightLocs)
          %plot((x1+x2)/2, (y1+rightLocs(j)+y1+rightLocs(j))/2, 'gx') ;
       end
       
        
        nFlags = max(length(leftLocs), length(rightLocs));
        if (nFlags == 1)
            values(i) = 8;
            %plot((x1+x2)/2, (y1+y2)/2, 'gx') ;
        elseif(nFlags == 2)
            values(i) = 16;
            %plot((x1+x2)/2, (y1+y2)/2, 'rx') ;
        else
            values(i) = 4;
        end
       
    end
    
    
   

end


% Returns a matrix of n*5 elements, where n is the number of staffs.

function staffs = staffDetection(input)
    
    [h, w] = size(input); 

    input = bwmorph(input,'erode');

    
    
    f = [-1 0 1];
    derivative = abs(imfilter(input,f,'circular'));
    
    %Projects everything on the horizontal plane
    projectedDerivative = horProj(derivative);
    projectedInput = horProj(input == 0);
    
    %figure(); hold on;
    %plot(projectedInput, 'b');
    %plot(7*projectedDerivative, 'k');
    linePoints = max(projectedInput-10*projectedDerivative, 0);
    %plot(linePoints, 'r');
    
    [peaks, locations] = findpeaks(linePoints, 'MINPEAKHEIGHT', 0.1, 'MINPEAKDISTANCE', 2);
    
    
   
    %iterate over possible upper lines
    first = 1;
    last = length(locations) - 4;
    weights = zeros([last, 1]);
    staffs = [];
    lastIndex = 0;
    %pointProducts = zeros(size(weights));
    for i = first:last
        distances = locations(i:i+3) - locations(i+1:i+4);
        diff = sum(abs(distances(2:4) - distances(1:3)));
        
        % calculate product of all five line points
        weights(i) = prod(peaks(i:i+4));
        
                
        % sum of difference cannot be smaller than 10 pixels.
        % TODO: weight on image size.
        
        if (diff < 10)
            notOverlapping = lastIndex+4 < i;
            
            % is it a new staff? Add more space in matrix!
            if (lastIndex == 0 || notOverlapping)
                staffs = cat(1, staffs, zeros([1, 5]));
            end
            
            [row, ~] = size(staffs);
            % is it not overlapping or is the newly found staff BETTER than the old one 
            if (lastIndex == 0 || notOverlapping || weights(i) > weights(lastIndex))
                staffs(row,:) = locations(i:i+4)';
                lastIndex = i;
            end
        end
    end
    
    
    
    %staffs
    %Plot for debugging purposes:
    %figure; hold on;
    %imshow(input);
    %locations
    %for y = locations(:)
    %    plot([0, 1000], [y y], 'b');
    %end
    % 
    %for y = staffs(:)
    %    plot([0, 1000], [y y], 'r');
    %end
end

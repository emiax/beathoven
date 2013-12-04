% Returns a matrix of n*5 elements, where n is the number of staffs.

function staffs = staffDetection(input)
    
    input = bwmorph(input,'erode');

    f = [-1 0 1];
    derivative = imfilter(input,f,'circular');
    
    %Projects everything on the horizontal plane
    projectedDerivative = sum(derivative, 2)/sum(size(derivative));
    projectedInput = sum(input == 0, 2)/sum(size(input));
    
    linePoints = max(projectedInput-10*projectedDerivative, 0);
    [peaks, locations] = findpeaks(linePoints, 'MINPEAKDISTANCE', 2);
    
    
    
    %iterate over possible upper lines
    first = 1;
    last = length(locations) - 4;
    weights = zeros([last, 1]);
    staffs = [];
    for i = first:last
        distances = locations(i:i+3) - locations(i+1:i+4);
        diff = sum(abs(distances(2:4) - distances(1:3)));
        
        % calculate product of all five line points
        pointProduct = prod(peaks(i:i+4)); % maybe needed for improvements
        
        % sum of difference cannot be smaller than 10 pixels.
        % TODO: weight on image size.
        if (diff < 10)
            staffs = cat(1, staffs, locations(i:i+4)');
        end
    end
    
    %Plot for debugging purposes:
    %figure; hold on;
    %imshow(input);
    %for y = staffs(:)
    %    plot([0, 1000], [y y], 'r');
    %end
   
    
end
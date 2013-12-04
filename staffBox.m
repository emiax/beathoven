function [ staffBounds ] = staffBox( lines , BWimg)
    horHist = horProj(BWimg == 0);
    numStaffs = size(lines,1);
    staffBounds = zeros(numStaffs,2);
    %Loop through all lines
    for i = 1:size(lines,1)
        %Loop to upper bounds
        index = lines(i,1);
        while(index > 1)
            index = index - 1;
            %If the y coordinate only has white pixels
            if(horHist(index) == 0)
                staffBounds(i,1) = index;
                break;
            end
        end
        
        %Loop to lower bounds
        index = lines(i,end);
        while(index < size(horHist,1))
            index = index + 1;
            %If the y coordinate only has white pixels
            if(horHist(index) == 0)
                staffBounds(i,2) = index;
                break;
            end
        end
    end
end


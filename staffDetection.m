function staffs = staffDetection(BWimg)
    %Projects everything on the horizontal plane
    horHist = sum(BWimg == 0, 2)/sum(size(BWimg));
    
    %Taken from and modified http://stackoverflow.com/questions/6549591/split-an-array-in-matlab
    %In order to find seperated parts of our horizontal projection
    edgeArray = diff([0; (horHist(:) ~= 0); 0]);    
    indices = [find(edgeArray > 0) find(edgeArray <0)-1];
    
    
    threshHist = zeros(size(horHist));
    for i = 1:size(indices,1)
        group = horHist(indices(i,1):indices(i,2));
        threshold = graythresh(group);
        staffGroup = im2bw(group, threshold);
        if sum(staffGroup == 1) >= 5
            threshHist(indices(i,1):indices(i,2)) = staffGroup;
        end
    end
    staffs = threshHist;
end


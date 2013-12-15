%%%%%%%%%%%%%%%%%%%%%%%%%% 
function strout = beathoven(img) 
 
    img = illumination(img);
    %img = perspectiveCorrection(img);
    
    
    %Straighten the image
    straightened = straighten(img);

    
    %Threshold the image
    imgThresh = thresh(straightened);

    lines = staffDetection(imgThresh);
   

    noLines = lineRemoval(straightened, lines);
    

    staffs = staffBox(imgThresh, lines);
    [nStaffs, ~] = size(staffs);
    
     
    strout = '';   

    for j = 1:nStaffs 
        
        staffImg = noLines(staffs(j, 1):staffs(j, 2),:);
        [stems, heads, misc] = categorize(staffImg, lines);


        [boxes, heads, flagPositions] = boundingBoxes(stems, heads, lineDist(lines));
        
        topLine = lines(j, 1) - staffs(j, 1) + 1;
        bottomLine = lines(j, 5) - staffs(j, 1) + 1;
        

        [nBoxes, ~] = size(boxes);
        values = noteValue(flagPositions, misc, lineDist(lines));
        for k = 1:nBoxes
            [nHeads, ~] = size(heads{k});
            for l = 1:nHeads

                y = heads{k}(l, 2);
                p = pitch(y, topLine, bottomLine);
                value = values(k);
                
                if value == 4
                    p = upper(p);
                elseif value ~= 8
                    p = '';
                end
                
                strout = strcat(strout, p);
            end
        end
        if (j ~= nStaffs)
            strout = strcat(strout, 'n');
        end
    end
end
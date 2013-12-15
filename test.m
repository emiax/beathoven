clear all;
close all;

images = {'im1s';'im3s'; 'im5s'; 'im6s'; 'im8s'; 'im9s'; 'im10s'; 'im13s'};
%images = {'im1s';'im3s'; 'im5s'; 'im6s'};

%images = {'im1s'; 'im3s'};
%images = {'im1s'};

path = 'samples/';
suffix = '.jpg';
numImages = size(images,1);
numGrid = ceil(sqrt(numImages));


[referenceNames, referenceStrings] = textread(strcat(path, 'reference.txt'),'%q %q\n');

%h1 = figure(1);
%set(1, 'name', 'Original Images');
%h2 = figure(2);
%set(2, 'name', 'Straightened');
%h3 = figure(3);
%set(3, 'name', 'Uniform Illumination');

%h4 = figure(4);
%set(4, 'name', 'No lines');
%h5 = figure(5);
%set(5, 'name', 'Stems, flags, heads');

% h3 = figure(3);
% set(3, 'name', 'Threshold');
% h4 = figure(4);
% set(4, 'name', 'No lines');
% h5 = figure(5);
% set(5, 'name', 'No lines');



for i = 1:numImages
    
    %Read the image we want to test
    fileString = char(strcat(path,images{i},suffix));
    img = im2double(imread(fileString));
    
    
    img = illumination(img);
    %img = perspectiveCorrection(img);
    
   

    
    % Show original image
        %figure(h1);
        %a = subplot(numGrid, numGrid, i);
        %imshow(img);
        %title(a, fileString);
    
    %Straighten the image
    straightened = straighten(img);
    
    
    % Show straightened image
        %figure(h2);
        %b = subplot(numGrid, numGrid, i);
        %imshow(straightened);
        %title(b, fileString);
        
    % Uniform illumination
    %illuminated = illumination(straightened);
    
    % Show uniformed illumination
    %    figure(h3);
    %    c = subplot(numGrid, numGrid, i);
    %    imshow(illuminated);
    %    title(c, fileString);
    
    %Threshold the image
    imgThresh = thresh(straightened);
    %figure();
    %imshow(imgThresh);
    

    %Uncomment to view lines
    %figure(h3);
    %c = subplot(numGrid, numGrid, i);
    %imshow(imgThresh);
    %hold on;
    %title(c, fileString);
    %Gets the staffs
    lines = staffDetection(imgThresh);
   
    
    
    %imgThresh = horizontalCrop(imgThresh, lines);

    %figure();
    %imshow(imgThresh);
    
    
    %for y = lines(:)
    %    plot([0, 1000], [y y], 'r');
    %end
    
    %Uncomment to see staffs seperated
    staffBounds = staffBox(imgThresh, lines);
        %for j = 1:size(lines,1)        
    %    figure()
    %    imshow(imgThresh(staffBounds(j,1):staffBounds(j,2),:))
    %end
    %staffBounds
        %Plot for debugging purposes:
   
    %straightened = straightened*1.4;
    %straightened(:) = min(straightened(:), 1);
        
    noLines = lineRemoval(straightened, lines);
    
    %figure();
    %imshow(noLines);
    %hold on;
    %plot([0 1000], [lines(1,1) lines(1,1)], 'r');
    
    %figure(h4);
    %b = subplot(numGrid, numGrid, i);
    %imshow(noLines);
    %title(b, fileString);
    

    staffs = staffBox(imgThresh, lines);
    [nStaffs, ~] = size(staffs);
    
     
    outputString = '';   

    for j = 1:nStaffs 
        
        staffImg = noLines(staffs(j, 1):staffs(j, 2),:);
        staffImgWithLines = imgThresh(staffs(j, 1):staffs(j, 2),:);
        [stems, heads, misc] = categorize(staffImg, lines);

        
        
        topLine = lines(j, 1) - staffs(j, 1) + 1;
        bottomLine = lines(j, 5) - staffs(j, 1) + 1;
        
        [boxes, heads, flagPositions] = boundingBoxes(stems, heads, lineDist(lines), staffImgWithLines, topLine, bottomLine);
        

        
        
        [nBoxes, ~] = size(boxes);
        values = noteValue(flagPositions, misc, lineDist(lines));
        for k = 1:nBoxes
            [nHeads, ~] = size(heads{k});
            for l = 1:nHeads
                %x = headCentroids{k}(l, 1);
                y = heads{k}(l, 2);
               
                p = pitch(y, topLine, bottomLine);
                value = values(k);
                if value == 4
                    p = upper(p);
                elseif value ~= 8
                    p = '';
                end
                
                outputString = strcat(outputString, p);
            end
        end
        if (j ~= nStaffs)
            outputString = strcat(outputString, 'n');
        end
    end
        
    imageName = images(i);
    imageReferenceName = imageName(1:end-1);
    
    referenceIndex = 0;
    for j = 1:numel(referenceNames)
        chName = char(imageName);
        if (strcmp(char(referenceNames(j)), chName(1:end-1)))
            referenceIndex = j;
        end
    end
   
    if (referenceIndex) 
       ref = referenceStrings(referenceIndex);
       d = strdist(char(ref), outputString);
       failRate = double(d)/double(length(char(ref)));
       fprintf('%s %d %#5.0f \n', char(imageName), d, failRate*100);
       fprintf('ref: %s\n', char(ref));
       fprintf('out: %s\n', char(outputString)); 
    end
    
   
    
end

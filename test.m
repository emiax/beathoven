clear all;
close all;

images = {'im1s';'im3s'; 'im5s'; 'im6s'; 'im8s'; 'im9s'; 'im10s'; 'im13s'};
%images = {'im1s';'im3s'; 'im5s'; 'im6s'};

%images = {'im1s'};

path = 'samples/';
suffix = '.jpg';
numImages = size(images,1);
numGrid = ceil(sqrt(numImages));

h1 = figure(1);
set(1, 'name', 'Original Images');
h2 = figure(2);
set(2, 'name', 'Straightened');
h3 = figure(3);
set(3, 'name', 'Uniform Illumination');

h4 = figure(4);
set(4, 'name', 'No lines');
h5 = figure(5);
set(5, 'name', 'Stems, flags, heads');

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
    
    % Show original image
        figure(h1);
        a = subplot(numGrid, numGrid, i);
        imshow(img);
        title(a, fileString);
    
    %Straighten the image
    straightened = straighten(img);
    
    % Show straightened image
        figure(h2);
        b = subplot(numGrid, numGrid, i);
        imshow(straightened);
        title(b, fileString);
        
    % Uniform illumination
    illuminated = illumination(straightened);
    
    % Show uniformed illumination
        figure(h3);
        c = subplot(numGrid, numGrid, i);
        imshow(illuminated);
        title(c, fileString);
    
    %Threshold the image
    imgThresh = thresh(straightened);
    figure();
    imshow(imgThresh);
    

    %Uncomment to view lines
    %figure(h3);
    %c = subplot(numGrid, numGrid, i);
    %imshow(imgThresh);
    %hold on;
    %title(c, fileString);
    %Gets the staffs
    lines = staffDetection(imgThresh);
    
    imgThresh = horizontalCrop(imgThresh, lines);

    %for y = lines(:)
    %    plot([0, 1000], [y y], 'r');
    %end
    
    %Uncomment to see staffs seperated
    staffBounds = staffBox(imgThresh, lines);
        %for j = 1:size(lines,1)        
    %    figure()
    %    imshow(imgThresh(staffBounds(j,1):staffBounds(j,2),:))
    %end
    
        %Plot for debugging purposes:
    
    
    
    
    noLines = lineRemoval(straightened, lines);
    figure(h4);
    b = subplot(numGrid, numGrid, i);
    imshow(noLines);
    title(b, fileString);
    

    staffs = staffBox(imgThresh, lines);
    [nStaffs, ~] = size(staffs);
    
    outputString = '';   

    for j = 1:nStaffs 
        
        staffImg = noLines(staffs(j, 1):staffs(j, 2),:);
        [stems, heads, misc] = categorize(staffImg, lines);
        [boxes, heads, flagPositions] = boundingBoxes(stems, heads, lineDist(lines));
        
        topLine = lines(j, 1) - staffs(j, 1);
        bottomLine = lines(j, 5) - staffs(j, 1);
        
        
        
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
   
    outputString
    
    
    
    %title(b, fileString);

    %Threshold the image
    imgThresh = thresh(illuminated);
    %figure();
    %imshow(imgThresh);
    
%     %Uncomment to view lines
%     %figure(h3);
%     %c = subplot(numGrid, numGrid, i);
%     %imshow(imgThresh);
%     %hold on;
%     %title(c, fileString);
%     %Gets the staffs
%     lines = staffDetection(imgThresh);
%     
%     imgThresh = horizontalCrop(imgThresh, lines);
% 
%     %for y = lines(:)
%     %    plot([0, 1000], [y y], 'r');
%     %end
%     
%     %Uncomment to see staffs seperated
%     staffBounds = staffBox(imgThresh, lines);
%         %for j = 1:size(lines,1)        
%     %    figure()
%     %    imshow(imgThresh(staffBounds(j,1):staffBounds(j,2),:))
%     %end
%     
%         %Plot for debugging purposes:
%     
%     
%     
%     
%     noLines = lineRemoval(straightened, lines);
%     figure(h4);
%     b = subplot(numGrid, numGrid, i);
%     imshow(noLines);
%     title(b, fileString);
%     
%     
%     stemsImage = stemDetection(noLines, lines);
%     figure(h5);
%     b = subplot(numGrid, numGrid, i);
%     imshow(stemsImage);
%     title(b, fileString);

    
    
   
   % hold on;
    % 
  %  for y = lines(:)
  %      plot([0, 1000], [y y], 'r');
  %  end

    %imshow(noLines);
    %imgNoLines = thresh(imgNoLines);
  
    

    %figure()
    %imshow(noLines);
    %imgNoLines = thresh(imgNoLines);
  
    %noteDetection(noLines, staffBounds, lines);

    
end

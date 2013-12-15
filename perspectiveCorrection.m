function [ output ] = perspectiveCorrection( img )


th = graythresh(img);
bw = 1-im2bw(img, th);

%figure;
%imshow(bw);
bw2 = imdilate(bw, ones(4, 8));

%horizontal projection step

hp = horProj(bw2);
%plot(hp);

threshold = max(hp)/20;

starts = [];
stops = [];

[h, w] = size(bw);
for y = 2:h
    if hp(y - 1) < threshold && hp(y) > threshold
        starts(end+1) = y;    
    end

    if hp(y - 1) > threshold && hp(y) < threshold
        stops(end+1) = y;
    end
end

len = min(length(starts), length(stops));




% vertical projection step

filteredStarts = [];
filteredStops = [];

maxStreak = 0;
for i = 1:len
    start = starts(i);
    stop = stops(i);
    %figure();
    proj = vertProj(bw(start:stop, :));
    %plot(vertProj(bw(start:stop, :)));    
    
    zeroPositions = (find(proj == 0));
    differences = zeroPositions(2:end) - zeroPositions(1:end-1);
    
    maxStreak = max(maxStreak, max(differences));
end

%maxStreak

for i = 1:len
    start = starts(i);
    stop = stops(i);
    proj = vertProj(bw(start:stop, :));
    zeroPositions = (find(proj == 0));
    differences = zeroPositions(2:end) - zeroPositions(1:end-1);
    if (max(differences) > maxStreak*0.8)
        filteredStarts(end + 1) = starts(i);
        filteredStops(end + 1) = stops(i);
    end
end

len = length(filteredStarts);
%len

% if we have enough data to fix perspective
if (len > 1)
    

    %begin searching for points

    tlMax = zeros(len, 2);
    trMax = zeros(len, 2);
    blMax = zeros(len, 2);
    brMax = zeros(len, 2);

    for i = 1:len
        start = filteredStarts(i);
        stop = filteredStops(i);

        labeled = bwlabel(bw(start:stop, :));

        props = regionprops(labeled, 'Area', 'PixelList');

        maxAreaIndex = 1;
        for j = 2:numel(props)
            a = props(j).Area;
            if (a > props(maxAreaIndex).Area)
                maxAreaIndex = j;
            end
        end

        seedPoints = props(maxAreaIndex).PixelList(:,:);
        seedPointY = seedPoints(1, 2) + start;
        seedPointX = seedPoints(1, 1);

        midPoint = mean(seedPoints);
        midPoint = [midPoint(2), midPoint(1)]; % Y, X format



        seedPointImg = zeros(size(bw));
        seedPointImg(seedPointY, seedPointX) = 1;



        staffImg = imreconstruct(seedPointImg, bw2);

        tl = [-1, -2];
        tr = [-1, 2];
        bl = [1, -2];
        br = [1, 2];

        tlMax(i,:) = [0 0];
        trMax(i,:) = [0 0];
        blMax(i,:) = [0 0];
        brMax(i,:) = [0 0];

        for y=1:h
            for x=1:w
                this = [y, x];
                if (staffImg(y,x))
                    thisPosition = this-midPoint;

                    tlPosition = tlMax(i,:)-midPoint;
                    trPosition = trMax(i,:)-midPoint;
                    blPosition = blMax(i,:)-midPoint;
                    brPosition = brMax(i,:)-midPoint;

                    tlDiff = thisPosition - tlPosition;
                    trDiff = thisPosition - trPosition;
                    blDiff = thisPosition - blPosition;
                    brDiff = thisPosition - brPosition;

                    if (tlMax(i,1) == 0) 
                        tlMax(i,:) = this;
                        trMax(i,:) = this;
                        blMax(i,:) = this;
                        brMax(i,:) = this;
                    end

                    if (tlDiff*tl' > 0)
                        tlMax(i,:) = this;
                    end
                    if (trDiff*tr' > 0)
                        trMax(i,:) = this;
                    end
                    if (blDiff*bl' > 0)
                        blMax(i,:) = this;
                    end
                    if (brDiff*br' > 0)
                        brMax(i,:) = this;
                    end 
                end
            end
        end
        %
        %figure();
        %imshow(staffImg);
        %hold on;

        %plot(tlMax(i,2), tlMax(i,1), 'rx');
        %plot(trMax(i,2), trMax(i,1), 'rx');
        %plot(blMax(i,2), blMax(i,1), 'rx');
        %plot(brMax(i,2), brMax(i,1), 'rx');

    end


    %calculate distance between top left points in new image

    tlDist = tlMax(2:end,1) - tlMax(1:end-1,1); 
    trDist = trMax(2:end,1) - trMax(1:end-1,1); 
    blDist = blMax(2:end,1) - blMax(1:end-1,1); 
    brDist = brMax(2:end,1) - brMax(1:end-1,1); 

    yDist = (mean(tlDist)+mean(trDist)+mean(blDist)+mean(brDist))/4;

    %calculate staff width in new image
    staffWidth = (mean(trMax(:,2) - tlMax(:,2)) + mean(brMax(:,2) - blMax(:,2)))/2;

    %calculate staff height in new image
    staffHeight = (mean(blMax(:,1) - tlMax(:,1)) + mean(brMax(:,1) - trMax(:,1)))/2;



    tlRef = zeros(len,2);
    trRef = zeros(len,2);
    blRef = zeros(len,2);
    brRef = zeros(len,2);

    for i = 1:len
        tlRef(i,:) = tlMax(1,:) + [yDist*(i-1), 0];
        trRef(i,:) = tlMax(1,:) + [yDist*(i-1), staffWidth];

        blRef(i,:) = tlRef(i,:) + [staffHeight, 0];
        brRef(i,:) = trRef(i,:) + [staffHeight, 0];
    end


    old = vertcat(tlMax, trMax, blMax, brMax);
    new = vertcat(tlRef, trRef, blRef, brRef);


    %figure();
    %imshow(img);
    %hold on;
    %plot(old(:,2), old(:,1), 'rx');
    %hold on;
    %plot(new(:,2), new(:,1), 'gx');

    new = [new(:, 2), new(:, 1)];
    old = [old(:, 2), old(:, 1)];

    %figure();

    tform = cp2tform(new, old, 'projective');
    tform = fliptform(tform); 
    transformed = imtransform(1 - img, tform, 'XData', [1 w], 'YData', [1 h]);
    output = 1 - transformed;
    
    %figure();
    %imshow(output);
else
    output = img;
end


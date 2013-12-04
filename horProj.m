function [ horizontalProjection ] = horProj( image )
    horizontalProjection = sum(image, 2)/sum(size(image));
end


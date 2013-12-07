function [verticalProjection] = vertProj(image)
    verticalProjection = sum(image, 1)/sum(size(image));
end



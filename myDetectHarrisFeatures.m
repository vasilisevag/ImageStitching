function corners = myDetectHarrisFeatures (I, Rthres)
    k = 0.06;
    [imageHeight, imageWidth] = size(I);

    sobelMaskX = [-1 0 1; -2 0 2; -1 0 1];
    sobelMaskY = [-1 -2 -1; 0 0 0; 1 2 1];
    Ix = imfilter(I, sobelMaskX);
    Iy = imfilter(I, sobelMaskY);
    
    g = fspecial('gaussian', 9, 1);
    Ix2 = imfilter(Ix.^2, g);
    Iy2 = imfilter(Iy.^2, g);
    IxIy = imfilter(Ix.*Iy, g);
    
    corners = [];
    for heightIdx = 4 : imageHeight - 3
        for widthIdx = 4 : imageWidth - 3
            p = [heightIdx widthIdx]; 
            if isCorner(Ix2, Iy2, IxIy, p, k, Rthres) == 1
                corners = [corners; p];
            end
        end
    end
end
function myStitch(im1, im2)
    I1 = im2double(rgb2gray(im1));
    I2 = im2double(rgb2gray(im2));
    I1 = imgaussfilt(I1, 1);
    I2 = imgaussfilt(I2, 2);
  
    im1Corners = myDetectHarrisFeatures(I1, 30);
    im2Corners = myDetectHarrisFeatures(I2, 5);
    
    im1CornersTotal = size(im1Corners, 1);
    im2CornersTotal = size(im2Corners, 1);
    cornersDescriptorsIm1 = rand(im1CornersTotal, 37);
    cornersDescriptorsIm2 = rand(im2CornersTotal, 37);
    for cornerIdx = 1 : im1CornersTotal
        cornerDescriptor = myLocalDescriptor(I1, im1Corners(cornerIdx, :), 4, 40, 1, 8);
        if size(cornerDescriptor, 2) ~= 0 
            cornersDescriptorsIm1(cornerIdx, :) = cornerDescriptor; 
        end
    end
    for cornerIdx = 1 : im2CornersTotal
        cornerDescriptor = myLocalDescriptor(I2, im2Corners(cornerIdx, :), 4, 40, 1, 8);
        if size(cornerDescriptor, 2) ~= 0
            cornersDescriptorsIm2(cornerIdx, :) = cornerDescriptor;
        end
    end
    
    [pairedCorners, pairedCornersDistance] = knnsearch(cornersDescriptorsIm1, cornersDescriptorsIm2);
    [~,minDistanceIdxs] = mink(pairedCornersDistance, 2);
    firstPair = [im1Corners(pairedCorners(minDistanceIdxs(1)), :) ; im2Corners(minDistanceIdxs(1), :)];
    secondPair = [im1Corners(pairedCorners(minDistanceIdxs(2)), :) ; im2Corners(minDistanceIdxs(2), :)];
    im1Point = firstPair(1, :) - secondPair(1, :);
    im2Point = firstPair(2, :) - secondPair(2, :);
    rotationAngle = atan2d(abs(det([im2Point; im1Point])),dot(im2Point, im1Point));
    
    im2Rotated = myImgRotation(im2, rotationAngle);
    im2RotatedSize = [size(im2Rotated, 1) size(im2Rotated, 2)];
    
    im2Point = firstPair(2, :) - size(I2)./2;
    im2PointRotatedHeight = floor(im2Point(2)*cosd(rotationAngle) - im2Point(1)*sind(rotationAngle));
    im2PointRotatedWidth  = floor(im2Point(2)*sind(rotationAngle) + im2Point(1)*cosd(rotationAngle));
    
    shiftedInverseRotationHeightIdx = im2PointRotatedHeight + fix(size(im2Rotated, 1)/2);
    shiftedInverseRotationWidthIdx = im2PointRotatedWidth + fix(size(im2Rotated, 2)/2);
    im2PointRotated = [shiftedInverseRotationHeightIdx shiftedInverseRotationWidthIdx];
    im1Point = firstPair(1, :);
    distanceVector = im1Point - im2PointRotated;
    
    newImageSizeHeight = max(im1Point(1), im2PointRotated(1) + distanceVector(1)) + max(size(I1, 1) - im1Point(1), im2RotatedSize(1) - im2PointRotated(1) + distanceVector(1));
    newImageSizeWidth = max(im1Point(2), im2PointRotated(2) + distanceVector(2)) + max(size(I1, 2) - im1Point(2), im2RotatedSize(2) - im2PointRotated(2) + distanceVector(2));
    newImage = uint8(zeros(newImageSizeHeight, newImageSizeWidth, 3));
    
    for heightIdx = 1 : newImageSizeHeight
        for widthIdx = 1: newImageSizeWidth
            if heightIdx < size(I1, 1) && widthIdx < size(I1, 2)
                newImage(heightIdx, widthIdx, :) = im1(heightIdx, widthIdx, :);
            elseif heightIdx > distanceVector(1) && heightIdx < im2RotatedSize(1) + distanceVector(1) && widthIdx > distanceVector(2) && widthIdx < im2RotatedSize(2) + distanceVector(2)
                newImage(heightIdx, widthIdx, :) = im2Rotated(heightIdx - distanceVector(1), widthIdx - distanceVector(2), :);
            end
        end
    end
end
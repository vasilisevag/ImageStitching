function rotImg = myImgRotation(img, angle)
    imageChannelsTotal = size(img, 3);
    imageHeight = size(img, 1);
    imageWidth = size(img, 2);
    
    rotatedImageChannelsTotal = imageChannelsTotal; 
    rotatedImageHeight = ceil(imageHeight*abs(cosd(angle)) + imageWidth*abs(sind(angle)));
    rotatedImageWidth  = ceil(imageHeight*abs(sind(angle)) + imageWidth*abs(cosd(angle)));
    
    rotImg = zeros(rotatedImageHeight, rotatedImageWidth, rotatedImageChannelsTotal, 'uint8');
    
    for heightIdx = 1 : rotatedImageHeight
        
        for widthIdx = 1 : rotatedImageWidth
            
            shiftedHeightIdx = heightIdx - rotatedImageHeight/2;
            shiftedWidthIdx = widthIdx - rotatedImageWidth/2;
            
            inverseRotationHeightIdx = floor(shiftedHeightIdx*cosd(angle) + shiftedWidthIdx*sind(angle));
            inverseRotationWidthIdx  = floor(shiftedWidthIdx*cosd(angle) - shiftedHeightIdx*sind(angle));
            
            shiftedInverseRotationHeightIdx = inverseRotationHeightIdx + fix(imageHeight/2);
            shiftedInverseRotationWidthIdx = inverseRotationWidthIdx + fix(imageWidth/2);
            
            if (1 < shiftedInverseRotationHeightIdx && shiftedInverseRotationHeightIdx < imageHeight) && (1 < shiftedInverseRotationWidthIdx && shiftedInverseRotationWidthIdx < imageWidth)
                
                for channelIdx = 1 : rotatedImageChannelsTotal
                    rotatedImageChannelColor = floor((double(img(shiftedInverseRotationHeightIdx - 1, shiftedInverseRotationWidthIdx, channelIdx)) + double(img(shiftedInverseRotationHeightIdx + 1, shiftedInverseRotationWidthIdx, channelIdx)) + double(img(shiftedInverseRotationHeightIdx, shiftedInverseRotationWidthIdx - 1, channelIdx)) + double(img(shiftedInverseRotationHeightIdx, shiftedInverseRotationWidthIdx + 1, channelIdx)))/4);
                    rotImg(heightIdx, widthIdx, channelIdx) = uint8(rotatedImageChannelColor);
                
                end
                
            end
            
        end
        
    end
end
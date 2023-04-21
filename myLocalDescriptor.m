function d = myLocalDescriptor (I,p,rhom ,rhoM ,rhostep ,N)
    imageHeight = size(I, 1);
    imageWidth = size(I, 2);
    
    d = []; % empty array
    
    dx = I(p(1) + 1, p(2) + 1) + I(p(1), p(2) + 1) + I(p(1) - 1, p(2) + 1) -  I(p(1) + 1, p(2) - 1) - I(p(1), p(2) - 1) - I(p(1) - 1, p(2) - 1);
    dy = I(p(1) + 1, p(2) + 1) + I(p(1) + 1, p(2)) + I(p(1) + 1, p(2) - 1) -  I(p(1) - 1, p(2) + 1) - I(p(1) - 1, p(2)) - I(p(1) - 1, p(2) - 1);
    startingAngle = atan2(dy, dx);
    angleStep = 2*pi/ N;
    for r = rhom : rhostep : rhoM
        
        angle = startingAngle;
        pixelIntensitySum = 0;
        for circlePointIdx = 1 : N
            
            circlePointHeightIdx = floor(p(1) + sin(angle)*r);
            circlePointWidthIdx = floor(p(2) + cos(angle)*r);
            
            if (circlePointHeightIdx <= 1 || imageHeight <= circlePointHeightIdx) || (circlePointWidthIdx <= 1 || imageWidth <= circlePointWidthIdx)
                d = [];
                return;
            end
            
            pixelIntensitySum = pixelIntensitySum + (double(I(circlePointHeightIdx - 1, circlePointWidthIdx)) + double(I(circlePointHeightIdx + 1, circlePointWidthIdx)) + double(I(circlePointHeightIdx, circlePointWidthIdx - 1)) + double(I(circlePointHeightIdx, circlePointWidthIdx + 1)))/4.0;
            angle = angle + angleStep;
        end
        
        pixelIntensityAverage = pixelIntensitySum / N;
        d = [d, pixelIntensityAverage];
    end 
end
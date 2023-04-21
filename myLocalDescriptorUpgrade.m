function d = myLocalDescriptorUpgrade (I,p,rhom ,rhoM ,rhostep ,N)
    imageHeight = size(I, 1);
    imageWidth = size(I, 2);
    
    circlesTotal = fix((rhoM - rhom) / rhostep) + 1;
    d = zeros(circlesTotal, N);
    
    r = rhom;
    angleStep = 2*pi/ N;
    for circleIdx = 1 : circlesTotal
        
        angle = 0;
        for circlePointIdx = 1 : N
            
            circlePointHeightIdx = floor(p(1) + sin(angle)*r);
            circlePointWidthIdx = floor(p(2) + cos(angle)*r);
            
            if (circlePointHeightIdx <= 1 || imageHeight <= circlePointHeightIdx) || (circlePointWidthIdx <= 1 || imageWidth <= circlePointWidthIdx)
                d = [];
                return;
            end
            
            d(circleIdx, circlePointIdx) = (double(I(circlePointHeightIdx - 1, circlePointWidthIdx)) + double(I(circlePointHeightIdx + 1, circlePointWidthIdx)) + double(I(circlePointHeightIdx, circlePointWidthIdx - 1)) + double(I(circlePointHeightIdx, circlePointWidthIdx + 1)))/4.0;
            angle = angle + angleStep;
        end
        
        r = r + rhostep;
    end 
end
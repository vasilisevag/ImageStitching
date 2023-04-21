function c = isCorner(Ix2, Iy2, IxIy, p, k, Rthres)
    gaussianFilter = @(x, y) exp(-(x^2 + y^2)/8);
    
    Ix21 = 0; Iy21 = 0; IxIy1 = 0;
    for windowHeightIdx = p(1) -3 : p(1) + 3
        for windowWidthIdx = p(2) - 3 : p(2) + 3
            Ix21 = Ix21 + Ix2(windowHeightIdx, windowWidthIdx) * gaussianFilter(p(1) - windowHeightIdx, p(2) - windowWidthIdx);
            Iy21 = Iy21 + Iy2(windowHeightIdx, windowWidthIdx) * gaussianFilter(p(1) - windowHeightIdx, p(2) - windowWidthIdx);
            IxIy1 = IxIy1 + IxIy(windowHeightIdx, windowWidthIdx) * gaussianFilter(p(1) - windowHeightIdx, p(2) - windowWidthIdx);
        end
    end
    
    M = [Ix21 IxIy1 ; IxIy1 Iy21];
    R = det(M) - k*trace(M).^2; 
    if R >= Rthres c = 1;   
    else c = 0; 
    end
end
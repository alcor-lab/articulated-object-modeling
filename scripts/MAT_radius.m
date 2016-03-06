function F = MAT_radius(Mask, X, Y)

%% This function computes, or each point inside the mask,  the distance 
% between the nearest point in MAT plus its associated radius
% Author: Marta Sanzari, sanzari@diag.uniroma1.it
    skel = bwmorph(Mask,'skel',Inf);
    DD = double(bwdist(~Mask));
    R = zeros(size(DD));
    R(skel) = DD(skel);
        
    [row, col] = find(skel);
    dist2Mat = (pdist2([X, Y], [row, col]));
    
    min_dist2MAT = zeros(size(dist2Mat,1),1);
    radius_minMat = zeros(size(dist2Mat,1),1);
    for kk=1:size(dist2Mat,1)
        C2 = find(dist2Mat(kk,:) == min(dist2Mat(kk,:)),1);
        ind_min = [row(C2), col(C2)];
        radius_minMat(kk) = R(ind_min(1),ind_min(2));
%         if min(dist2Mat(kk,:)) == 0
%             min_dist2MAT(kk) = radius_minMat(kk)*1.5;
%         else
            min_dist2MAT(kk) = min(dist2Mat(kk,:));
%         end
    end
    F = min_dist2MAT + radius_minMat;
end
function [X, Y, Bound] = find_boundary(M)

% This function computes the boundary points of the mask M, the points
% inside M, and plot them
% Input: mask M of dimension nxm
% Output: row value X of the points inside the mask, of dimension px1
%         column value Y of the points inside the mask, of dimension px1
%         the boundary points Bound of dimension qx2  
%
% Author: Marta Sanzari, sanzari@diag.uniroma1.it

    [X, Y] = find(M);
    bou2 = bwperim(M);
    cont = 1;
    
    for ii=1:size(M,1)
        for jj=1:size(M,2)
            if bou2(ii,jj)==0
                continue;
            end
            Bound(cont,:) = [ii,jj];
            cont = cont+1;
        end
    end
    
%     figure;
%     plot3(X,Y,zeros(size(X)),'.')
%     hold on
%     plot3(Bound(:,1),Bound(:,2),zeros(size(Bound)),'r.','MarkerSize',20)
%     axis equal
    
end
function D = thresholded_delaunay(X,Y,Bnd) 

% This function computes the Delaunay triangulation over the points defined
% by X and Y, and applies a threshold over the length of the edges. If an
% edge is longer than the threshold, it is deleted in the trangulation.
% Input: X x-coordinate of the considered points, of dimension nx1
%        Y y-coordinate of the considered points, of dimension nx1
% Output: D the set of triangles in the computed triangulation, of
%         dimension mx3, each row defines the vertices of a triangle, the
%         indices are defines by the order of the points inside X and Y
% Author: Marta Sanzari, sanzari@diag.uniroma1.it
    DT = delaunayTriangulation(X,Y);
    D = [DT(:,1) DT(:,2) DT(:,3)];
    mu = 1.5;
    iii = 1;
    
    while iii<=size(D,1)
        DD1 = D(iii,1);
        DD2 = D(iii,2);
        DD3 = D(iii,3);
        D1 = sqrt((X(DD1)-X(DD2))^2+(Y(DD1)-Y(DD2))^2);
        D2 = sqrt((X(DD2)-X(DD3))^2+(Y(DD2)-Y(DD3))^2);
        D3 = sqrt((X(DD1)-X(DD3))^2+(Y(DD1)-Y(DD3))^2);
        if D1>mu || D2>mu || D3>mu
            D(iii,:)=[];
        else
            iii = iii+1;
        end
    end

end
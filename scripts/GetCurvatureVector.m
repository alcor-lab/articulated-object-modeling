function [K, curv_min_dist2Bnd, N, Deriv, T] = GetCurvatureVector(Bndx, Bndy, X, Y)
% Author: Marta Sanzari, sanzari@diag.uniroma1.it
    r = [Bndx Bndy];
    r1 = diff([r;r(1,:)], 1); 

    T = bsxfun(@rdivide,r1,sqrt(sum(r1.^2,2))); N = [-T(:,2), T(:,1)]; % unit tangent and normal vectors

dx  = gradient(r(:,1));
ddx = gradient(dx);
dy  = gradient(r(:,2));
ddy = gradient(dy);
num   = dx .* ddy - ddx .* dy;
denom = dx .* dx + dy .* dy;
denom = denom.*denom.*denom;
denom = sqrt(denom);
curvature = num ./ denom;
curvature(denom < 0) = NaN;
K=[curvature r(:,1) r(:,2)];

Deriv=dy./dx;



    dist2Bnd = (pdist2([X, Y], [K(:,2), K(:,3)]));
    curv_min_dist2Bnd = zeros(size(dist2Bnd,1),1);
    
    for kk=1:size(dist2Bnd,1)
        C2 = find(dist2Bnd(kk,:) == min(dist2Bnd(kk,:)),1);
        curv_min_dist2Bnd(kk) = K(C2,1);
        
    end
    
 

end








function indexvertBnd = compute_bnd_index(Bnd,X)

% This function computes the indices of a set of points Bnd inside the set X
% Input: Bnd of dimension nx2
%        X of dimesion mx2
% Output: indexvertBnd of dimension nx1
%
% Author: Marta Sanzari, sanzari@diag.uniroma1.it

    if size(Bnd,2)~=2 || size(X,2)~=2
        error('the second dimension of both arguments must be 2');
    end
    
    indexvertBnd = zeros(size(Bnd,1),1);
    for jj=1:size(Bnd,1)
        a = find(Bnd(jj,1)==X(:,1) & Bnd(jj,2)==X(:,2));
        if isempty(a)
            break
        end
        indexvertBnd(jj,1) = a;
    end
end
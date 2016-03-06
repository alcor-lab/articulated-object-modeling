function [StiffnessMatrix, LoadVector] = FEMloop(D, Coords, Vq, lengthX, alpha, beta, dist2MAT, Curv)

% This function computes the Stiffness matrix and load vector for the
% Finite Element method
% Input: -  D, the set of triangles in the triangulation over the points
%        inside the mask, each row represents the indices of the verices of each
%        triangle
%        -  Coords, 
%        -  Vq, 
%        -  lengthX,
% Output: -  Stiffness
%         -  Load
% Author: Marta Sanzari, sanzari@diag.uniroma1.it

    %% Initialization
    n_zero = 12*12*size(D,1);
    Tmp = zeros(n_zero,3);
    Tmp2 = zeros(12*size(D,1),2);
    n = size(Coords,2);
    if n>=8000
        factor = n/130000;
    elseif n<=2000 && n>500
        factor = n/800;
    elseif n<=500
        factor = n/800;
    elseif n>=2000 && n<2700
        factor = n/15000;
    elseif n>=2700 && n<4000
        factor = n/25000;
    elseif n>=4000 && n<=5000
        factor = n/50000;
    else
        factor = n/60000;
    end
    
    %% Main loop over the triangles to compute the stiffness matrix and load vector
    for kk = 1:size(D,1)
        % Compute the Dunavant quadrature nodes and weights
        [p,q] = DunavantData(1,Coords(kk).Vertices);
        % Initialization
        K = zeros(12);
        F = zeros(1,12);
        b = Coords(kk).L(:,2);
        b1 = b(1);
        b2 = b(2);
        b3 = b(3);
        c = Coords(kk).L(:,3);
        c1 = c(1);
        c2 = c(2);
        c3 = c(3);
        
        % Set the vectors and interpolate the VqX matrices
        x = Coords(kk).Vertices(:,1);
        y = Coords(kk).Vertices(:,2);
        xt = [Coords(kk).Vertices(:,1);p(:,1)];
        yt = [Coords(kk).Vertices(:,2);p(:,2)];
        zt = Vq(D(kk,:));
        vvv = griddata(x,y,zt,xt,yt);
        %zt2 = dist2MAT(D(kk,:));
        %vvv2 = griddata(x,y,zt2,xt,yt);
        %zt3 = Curv(D(kk,:));
        %vvv3 = biharmonic_spline_interp2(x,y,zt3,xt,yt);
        
        % Compute the angles between the triangle edges
        [gamma12, gamma23, gamma31] = Gammaij(Coords(kk).Vertices);
        
        % Loop over the quadrature nodes
        for ii = 1:size(p,1)
                % Compute the stiffness matrix and load vector for each
                % quadrature node
                NL1 = N12_central_first(b1, b2, b3, c1, c2, c3, gamma12, gamma23, gamma31, Coords(kk).Area);
                NL2 = N12_central_second(b1, b2, b3, c1, c2, c3, gamma12, gamma23, gamma31, Coords(kk).Area);
                KK = NL2'*(Coords(kk).J2inv)'*beta*Coords(kk).J2inv*NL2+NL1'*(Coords(kk).J1inv)'*alpha*Coords(kk).J1inv*NL1;
                K = K+KK*q(ii);                
                [~, N12] = N9_central(b1, b2, b3, c1, c2, c3, gamma12, gamma23, gamma31, Coords(kk).Area);
                % Compute the load vector
%                 if sqrt((vvv2(3+ii)-max(dist2MAT))^2)<=(max(dist2MAT)/1.5)
%                     FF = (vvv(3+ii)/vvv2(3+ii))*factor*1.5*N12;
%                 else
                    %FF = (vvv(3+ii)/vvv2(3+ii))*factor*N12;
               % end
               FF = (vvv(3+ii))*factor*N12;
               F = F+FF*q(ii);
        end

        
         % Compute the mapping indices between local and global indices
        ind = D(kk,:);
        mapping = [(ind(1)-1)*4+1:(ind(1)-1)*4+3 (ind(2)-1)*4+1:(ind(2)-1)*4+3 (ind(3)-1)*4+1:(ind(3)-1)*4+3 (ind(1)-1)*4+4 (ind(2)-1)*4+4 (ind(3)-1)*4+4];
        
        % Assemble the vectors in which are saved the rows and columns indices,
        % together with the values used to generate the stiffness matrix and load vector
        B = repmat(mapping,12,1);
        A = repmat(mapping',1,12);
        Tmp((kk-1)*144+1:(kk-1)*144+144,:) = [A(:) B(:) K(:)];
        Tmp2((kk-1)*12+1:(kk-1)*12+12,:) = [mapping' F'];
        
    end
    
    % Create stiffness matrix and load vector
    StiffnessMatrix = sparse(Tmp(:,1),Tmp(:,2),Tmp(:,3),4*lengthX,4*lengthX,n_zero);
    LoadVector = sparse(Tmp2(:,1),ones(12*size(D,1),1),Tmp2(:,2),4*lengthX,1,12*size(D,1));
end
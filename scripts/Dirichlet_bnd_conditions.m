function [StiffnessMatrix, LoadVector] = Dirichlet_bnd_conditions(indexvertBnd, StiffnessMatrix, LoadVector)

% This function specifies the Dirichlet boundary conditions
% Input: -  indexvertBnd, the indices of the boundary points inside the set
%           of points inside the mask
%        -  
% Author: Marta Sanzari, sanzari@diag.uniroma1.it

    %% Specify Dirichlet boundary conditions
    % Find global indices of boundary nodes (Z component)
    Gbnd = (indexvertBnd-1)*4+1;
    
    [i,j,s] = find(StiffnessMatrix);
    n = size(StiffnessMatrix,1);
    m = nnz(StiffnessMatrix);
    [i2,~,s2] = find(LoadVector);
    n2 = length(LoadVector);
    m2 = nnz(LoadVector);
    
    % Replace rows and columns of the stiffness matrix corresponding 
    % to the boundary nodes by zeros (except the diagonal element)
    % Replace the boundary values in the load vector
    
    for ll=1:length(Gbnd)
%         k = StiffnessMatrix(Gbnd(ll),Gbnd(ll));
%         StiffnessMatrix(Gbnd(ll),:) = zeros(1,size(StiffnessMatrix,2));
%         StiffnessMatrix(:,Gbnd(ll)) = zeros(size(StiffnessMatrix,1),1);
%         StiffnessMatrix(Gbnd(ll),Gbnd(ll)) = k;
%         LoadVector(Gbnd(ll),1) = StiffnessMatrix(Gbnd(ll),Gbnd(ll))*0;
%         
        a = Gbnd(ll);
        c = find(i==a & j==a);
        tm = s(c);
        s(i==a) = 0;
        s(j==a) = 0;
        s(c) = tm;
        s2(i2==a) = tm*0;
    end
    StiffnessMatrix = sparse(i,j,s,n,n,m);
    LoadVector = sparse(i2,ones(length(i2),1),s2,n2,1,m2);
end
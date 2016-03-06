function FEM(Obj,path)
% Author: Marta Sanzari, sanzari@diag.uniroma1.it

%% This is the main code of the Finite Element Method

    fnames = fieldnames(Obj);
    %% For each component of the object
    for jj=1:length(fnames)
        
        Component = Obj.(fnames{jj});
        %% For each aspect of the considered component
        for kk=1:length(Component)
            %% Uncomment if you want to resize the image
            %Img = imresize(Obj(kk).Img, Obj.scale);
            Mask = Component(kk).mask;
            if ~islogical(Mask)
                Mask = im2bw(Mask);
            end
            
            if Component(kk).scale(1)~=1
                Mask = imresize(Mask, Component(kk).scale(1));
            end
            Mask = centering(Mask);
            Mask = flipud(Mask);
            %% Define the bending and stretching coefficients matrices
            beta = [0.1 0 0
                    0 0.1 0
                    0 0 0.1];

            alpha = [0.2 0.1
                     0.1 0.2];

            %% Compute the boundary of the object and plot
            [X, Y, Bnd] = find_boundary(Mask);

            %% Compute the indices of the boundary points
            indexvertBnd = compute_bnd_index(Bnd,[X,Y]);

            %% Compute curvature at the mask contour
            [~, Curv, ~, ~, ~] = GetCurvatureVector(Bnd(:,1), Bnd(:,2), X, Y);
            clear Bnd

            %% Compute the distance transform and the vector values to be used 
            %in the FEM algorithm as external forces
            DistMask = bwdist(1-Mask);
            DistMask(DistMask>0) = DistMask(DistMask>0)+3;
            Vq = zeros(size(X));
            for ii=1:length(X)
                Vq(ii,1) = DistMask(X(ii),Y(ii));
            end
            clear DistMask
            
            %% Compute the Delaunay triangulation over the points inside the mask
            D = thresholded_delaunay(X, Y, indexvertBnd);

            %% Compute the baricentric coordinates for each triangle for the FEM
            Coords = barycentric_coordinates(X, Y, D);

            %% Compute, for each poin inside the mask, the distance between the 
            % nearest point in MAT plus its radius
            Dist2MAT = MAT_radius(Mask, X, Y);
            M1 = zeros(size(Mask,1),size(Mask,2));
            for ii=1:length(X)
                M1(X(ii),Y(ii)) = Dist2MAT(ii);
            end
       
            clear M1 Mask

            %% Compute the Stiffness matrix and the load vector
            lengthX = length(X);
            [StiffnessMatrix, LoadVector] = FEMloop(D, Coords, Vq, lengthX, alpha, beta, Dist2MAT, Curv);
            
            clear Coords Vq alpha beta Dist2MAT Curv

            %% Specify Dirichlet boundary conditions
            [StiffnessMatrix, LoadVector] = Dirichlet_bnd_conditions(indexvertBnd, StiffnessMatrix, LoadVector);
            %clear indexvertBnd

            %% Compute and plot the solution 
            RegStiffness = StiffnessMatrix+speye(size(StiffnessMatrix))*0.3;
            clear StiffnessMatrix
            U = RegStiffness\(2*LoadVector);
            clear LoadVector RegStiffness

            Z = U(1:4:4*length(X),:);
            Z = full(Z);
            figure;
            trimesh(D,X,Y,Z,Z);
            axis equal

            %% Scale the obtained point cloud
            
            scale = Component(kk).scale;
%             if scale(1)~=1
%                 X = X*scale(1);
%                 Y = Y*scale(1);
%                 Z = Z*scale(1);
%             end
            if size(scale,2)>1
                if scale(2)~=1
                    Y = Y*scale(2);
                end
                if scale(3)~=1
                    Z = Z*scale(3);
                end
            end
            X = [X;X];
            Y = [Y;Y];
            Z = [-Z;Z];
            
%             Qx = [X'; Y'; Z'];
%             Qx = Component(kk).R*Qx;
%             trep = repmat(Component(kk).t, 1, size(Qx,2));
%             Qx = Qx+trep;
%             X = Qx(1,:)';
%             Y = Qx(2,:)';
%             Z = Qx(3,:)';
            
            %% Compute the faces for the surface symmetric with respect to the z=0 plane
            tmp = D(:,1);
            D = [D(:,3), D(:,2), tmp];
            D2 = [D(:,3), D(:,2) D(:,1)];
            D2 = D2+lengthX;

            %% Put together the final faces and vertices for the closed surface
            FV.faces = [D2;D];
            FV.vertices = [X Y Z];
            %clear X Y Z D2
            
            %% Reduce the patches to be 10% of the overall number
           % [f,v] = reducepatch(FV, 0.1);
            %clear FV
            %fv3.faces = f;
            %fv3.vertices = v;
            %fv=FV;
            %fv3 = smoothpatch(FV);
            %fv2=smoothpatch(FV);
            indexvertBnd = [indexvertBnd;indexvertBnd+lengthX];
            fv = removeBnd(FV,indexvertBnd);
            %% Compute the vertices normals, the faces normals, and the baricenters of each triangle
            if size(D,2)~=3
                error('The faces must be triangles!!')
            end
            clear D
           % [N, faceNormals, Baricenters] = patchnormals(fv);
%             f = FV.faces;
%             v = FV.vertices;
            %% Save the final shape in an .stl file and plot it
    %         stlwrite('C:\Users\Matteo\Documents\MATLAB\provagatto.stl',D, [X Y Z],'FaceColor',[1 1 1]); 
    %         stlwrite('C:\Users\Matteo\Documents\MATLAB\provagatto2.stl',D2, [X Y -Z],'FaceColor',[1 1 1]);
            
            name = [path fnames{jj} '_' num2str(kk) '.stl'];
            stlwrite(name,fv.faces, fv.vertices,'FaceColor',[1 1 1]);
            name2 = [path fnames{jj} '_' num2str(kk) '.pcd'];
            savepcd(name2,[X Y Z]');
            
            

%             figure;
%             trimesh(f,v(:,1),v(:,2),v(:,3),v(:,3));
%             axis equal
%             hold on
%             quiver3(Baricenters(:,1),Baricenters(:,2),Baricenters(:,3),faceNormals(:,1),faceNormals(:,2),faceNormals(:,3), 'color','r');
%             figure;
%             trimesh(f,v(:,1),v(:,2),v(:,3),v(:,3));
%             axis equal
%             hold on
%             quiver3(v(:,1),v(:,2),v(:,3),N(:,1),N(:,2),N(:,3), 'color','r');
% 
%             clear Mask X Y Bnd
        end
    end
end
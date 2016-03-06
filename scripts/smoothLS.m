function Vol_out = smoothLS(Vol_in,weight,x_o,x_f,dx,iter,save_mesh,dirout)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Vol_out = smoothLS(Vol_in,weight,x_o,x_f,dx,iter,save_mesh)
%%%
%%% Function to smooth an implicit volume, according to level set based
%%% curvature flow. TO RUN THIS FUNCTION THE LEVEL SET TOOLBOX FROM IAN MITCHELL
%%% MUST BELONG TO MATLAB PATHS. (http://www.cs.ubc.ca/~mitchell/ToolboxLS/)
%%% 
%%%  INPUT - 'Vol_in' an MxNxQ 3D volume of signed distance function (the zero
%%%          defines the surface),
%%%        - 'weight' an MxNxQ 3D weight applied during evolution,
%%%        - 'x_o','x_f','dx' extremas and dx of the domain. These values must
%%%          be in accord with MxNxQ,
%%%        - 'iter' number of iterations applied
%%%        - 'save_mesh' boolean to save input and output meshes
%%%
%%% OUTPUT - 'Vol_out' the MxNxQ volume after "iter" smoothing iterations
%%% Author: Bruno Cafaro, cafaro@diag.uniroma1.it
if exist('processGrid.m','file') ~= 2
    
    web('http://www.cs.ubc.ca/~mitchell/ToolboxLS/')
    error('Level Set Toolbox not installed, please see the opent web page!')
end

if size(x_o,2) == 3 && size(x_f,2) == 3 && size(dx,2) == 3
    
    g.dim = 3;
    g.min = x_o';
    g.max = x_f';
    g.dx = dx';
    g.bdry=@addGhostPeriodic;
    gout = processGrid(g);
    
else
    
    error('Input variables ("x_o" or "x_f" or "dx") not valids!')
end

if size(Vol_in,2) ~= 1 && size(Vol_in,3) ~= 1
    
    phi0 = Vol_in;
    
    if save_mesh == 1
        
        [ mesh_xs, mesh_data ] = gridnd2mesh(gout, phi0);
        [faces,verts] = isosurface(mesh_xs{:}, mesh_data, 0);
        stlwrite(sprintf('%s%c000.stl',dirout,filesep),faces,verts)
        
    end
    
    derivFunc = @upwindFirstENO;
    integratorFunc = @odeCFL3;
    %derivFunc = @upwindFirstFirst;
    %integratorFunc = @odeCFL1;
    
    %integratorOptions = odeCFLset('factorCFL', 0.5, 'stats', 'on', 'singleStep', 'off');
    integratorOptions = odeCFLset('factorCFL', 0.5, 'stats', 'on', 'singleStep', 'off');
    
    curveFunc = @termCurvature;
    curveData.grid = gout;
    curveData.velocity = 1;
    curveData.curvatureFunc = @curvatureSecond;
    curveData.b = double(weight);
    curveData.derivFunc = derivFunc;
    
    t0 = 0;
    %tAdd = 0.5;
    tAdd = 0.5;
    cc = 0;
    
    disp('Level Set evolution has started ...');
    
    while true
        
        y0 = phi0(:);
        
        tSpan = [ t0, t0 + tAdd];
        
        [ t, y ] = feval(integratorFunc, curveFunc, tSpan, y0, integratorOptions, curveData);
        
        t0 = t(end);
        
        cc = cc + 1;
        
        if cc == iter
            break;
        end
        
        phi0 = reshape(y, gout.shape);

        % begin visualization
        if save_mesh == 1
            [ mesh_xs, mesh_data ] = gridnd2mesh(gout, phi0);
            [faces,verts] = isosurface(mesh_xs{:}, mesh_data, 0);
            stlwrite(sprintf('%s%c%03d.stl',dirout,filesep,cc),faces,verts)
        end
        % end visualization
    end
    
    
else
    error('Input variables ("Vol_in" or "weight") not valids!')
end

Vol_out = reshape(phi0, gout.shape);

figure,
seeVol(Vol_out)

if save_mesh == 1
    
    [ mesh_xs, mesh_data ] = gridnd2mesh(gout, phi0);
    [faces,verts] = isosurface(mesh_xs{:}, mesh_data, 0);
    stlwrite(sprintf('%s%c%03d.stl',dirout,filesep,iter),faces,verts)
    
end

function [vol,gout] = stl2udf(models,res,bd)
% STL2UDF compute the signed distance function based on the patch structure
% of a model.
%  Input:
%    model: structure array containing patch data structures representing 
%           3D models (vertices & faces)
%    res: resolution of the voxel space (currently only multipliers of bd
%    are supported)
%    bd: number of thread blocks per dimension of voxel space
%  Output:
%    vol: volumetric representation of the 3D model
%    gout: a grid data structure describing the voxel space of the model
%  Author: Valsamis Ntouskos, ntouskos@diag.uniroma1.it

eps = 1e-5;
nmodels = length(models);
bblim=[inf(3,1),-inf(3,1)];
for jj=1:nmodels
    bblim(:,1) = min(bblim(:,1),...
                [min(models(jj).vertices(:,1)),min(models(jj).vertices(:,2)),min(models(jj).vertices(:,3))]');
    bblim(:,2) = max(bblim(:,2),...
                [max(models(jj).vertices(:,1)),max(models(jj).vertices(:,2)),max(models(jj).vertices(:,3))]');
end

% compute bounding box of the 3D model and voxel size of the 
minpts = bblim(:,1)';
maxpts = bblim(:,2)';
bboxd = sqrt(sum((maxpts-minpts).^2));

funcfullpath = mfilename('fullpath');
funcpath = fileparts(funcfullpath);
udf_kern = parallel.gpu.CUDAKernel(fullfile(funcpath,'cuda/udf.ptx'),fullfile(funcpath,'cuda/udf_kern.cu')); 
udf_kern.ThreadBlockSize=bd; 
udf_kern.GridSize=res./bd;
     
% initialize GPU variables
minvs = gpuArray(single(minpts-0.1*bboxd));
maxvs = gpuArray(single(maxpts+0.1*bboxd));
delvs = (maxvs-minvs-eps)./(res-1);

vol = [];
for jj=1:nmodels    
    % reinitialize local GPU variables    
    udf_g = inf(res,'single','gpuArray');
    ipf_g = zeros(res,'single','gpuArray');
    ind_g = zeros(res,'uint32','gpuArray');

    % compute normals from patch data
    normals = patchnormals(models(jj));

    % split data in chunks to avoid driver crash when GPU is used for graphics
    numpts = size(models(jj).vertices,1);
    pt_chunk = 2500;

    for ll=1:ceil(numpts/pt_chunk)
        first_ind = (ll-1)*pt_chunk;
        last_ind = min(numpts,ll*pt_chunk);
        pt_count = last_ind-first_ind;
        vert_g = gpuArray(single(models(jj).vertices(first_ind+1:last_ind,:)));
        norm_g = gpuArray(single(normals(first_ind+1:last_ind,:)));
        [udf_g, ipf_g,ind_g] = feval(udf_kern,udf_g,ipf_g,ind_g,vert_g,norm_g,minvs,delvs,res,pt_count);
        % wait(gpu);
    end

    vol_loc = double(gather(ipf_g));
    
    if jj == 1
        vol = vol_loc;
    else
        vol = min(vol_loc,vol);
    end
end

if nargout>1
    %lim = double(gather([minvs;maxvs]))';
    gin.dim = 3;
    gin.min = double(gather(minvs)'-eps);
    gin.max = double(gather(maxvs)'+eps);
    gin.dx = double(gather(delvs)');
    gout = processGrid(gin);
end
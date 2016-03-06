function seeVol(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% function seeVol(varargin)
%%%
%%% This function visualize an implicit surface inside a voxel space.
%%%  
%%% INPUTS: - (volume) 3D volume with its zero level defining an implicit
%%%           surface. Note that 3D volume can be given as a 3D matrix, or
%%%           a [nx1] vector with n = aa^3 (Line 44).
%%%         - (volume,'color') besides the 3D volume a color value can be
%%%           given. Color is {'r','b','g',...}.
%%%         - (volume,'color',alpha) besides the 3D volume and color an alpha 
%%%           value can be given. Alpha is a numeric value in [0-1].
%%%
%%% OUTPUT: plot on screen of the implicit surface.
%%%
%%% Author: Bruno Cafaro, cafaro@diag.uniroma1.it

if size(varargin,1) == 1 && size(varargin,2) == 1

    volume = varargin{1,1};
    color = 'r';
    lph = 0.5;

elseif size(varargin,1) == 1 && size(varargin,2) == 2

    volume = varargin{1,1};
    color = varargin{1,2};
    lph = 0.5;

elseif size(varargin,1) == 1 && size(varargin,2) == 3

    volume = varargin{1,1};
    color = varargin{1,2};
    lph = varargin{1,3};;

else
    error('Input variables not valids!')
    
end

if size(volume,2) == 1

    aa=round(size(volume,1)^(1/3));

    v = reshape(volume,[aa aa aa]);
    
else
    
    v = volume;
    
end
 
v = double(v<0);                              %# just to obtain the solid parts

%# visualize the volume
p = patch(isosurface(v,0));                   %# create isosurface patch
isonormals(v,p)                               %# compute and set normals
set(p,'FaceColor',color,'EdgeColor','none')   %# set surface props
daspect([1 1 1])                              %# axes aspect ratio
view(3), axis vis3d tight, box on, grid on    %# set axes props
camproj perspective                           %# use perspective projection
camlight, lighting phong, alpha(lph)          %# set visualization props

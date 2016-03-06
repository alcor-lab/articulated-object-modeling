function main(Obj,path)

    %% This is the main script
    % Example of usage:
    % main(Object, path)
    % Inputs:
    %   - Object, a structure having as fields the articulated object
    %     main components. Each field is a structure having length the 
    %     number of the component's aspects to be used to model the single
    %     component; each of it has two fiels and values, namely the 
    %     aspect's mask and the scale.
    %   - path, a string with the path to the folder
    %     articulated_object_modeling
    %
    % During the script execution, will be generated two folders, namely
    % the Aspects and Components, in which the .stl files representing
    % aspects and components of the articulated object will be saved. The
    % final object's .stl file will be saved in the All folder. 
    %
    % .stl files can be opened with various programs, such as Blender and 
    % Meshlab
    %
    % Author: Marta Sanzari, sanzari@diag.uniroma1.it
    
    if path(end)~='\'
        path = [path '\'];
    end
    pathAspects = [path 'Aspects\'];
    pathComponents = [path 'Components\'];
    if ~exist(pathAspects,'dir')
        mkdir(pathAspects);
    end
    if ~exist(pathComponents,'dir')
        mkdir(pathComponents);
    end
    
    load([path 'RtAspects.mat']);
    load([path 'RtComponents.mat']);
    
    FEM(Obj,path)
    fnames = dir([path '*.stl']);
    
    for ii=1:length(fnames)
        name = fnames(ii).name;
        aspect_name = strtok(name,'.');
        component_name{ii} = strtok(aspect_name,'_');
        P = stlread([path name]);
        aspect_dir{ii} = [pathAspects aspect_name '\'];
        if ~exist(aspect_dir{ii},'dir')
            mkdir(aspect_dir{ii});
        end
        component_dir{ii} = [pathComponents component_name{ii} '\'];
        if ~exist(component_dir{ii},'dir')
            mkdir(component_dir{ii});
        end
        
       [vol,gridout] = stl2udf(P,[128,128,128],[8,8,8]);
       smoothLS(vol,ones([128,128,128]),gridout.min',gridout.max',gridout.dx',15,true,aspect_dir{ii});
        
       stl_smooth = dir([aspect_dir{ii} '*.stl']);
       copyfile([aspect_dir{ii} stl_smooth(end).name],[component_dir{ii} aspect_name '.stl']);
        
    end
    
    component_dir = unique(component_dir);
    component_name = unique(component_name);
    all_dir = [path 'All\'];
    if ~exist(all_dir,'dir')
        mkdir(all_dir);
    end
    
    
    for ii=1:length(component_dir)
      
        stl_names = dir([component_dir{ii} '*.stl']);
        if length(stl_names)>1
            aspects_stl = [];
            for jj=1:length(stl_names)
                stl = stlread([component_dir{ii} stl_names(jj).name]);
                comp_name = component_name{ii};
                vertices = RtAspects.(comp_name)(jj).R*stl.vertices';
                stl.vertices = vertices' + repmat(RtAspects.(comp_name)(jj).t',size(stl.vertices,1),1);
                aspects_stl = [aspects_stl stl];
            end
            [vol,gridout] = stl2sdf(aspects_stl,[128,128,128],[8,8,8]);
            smoothLS(vol,ones([128,128,128]),gridout.min',gridout.max',gridout.dx',5,true,component_dir{ii});
            
            stl_smooth = dir([component_dir{ii} '*.stl']);
            kk = 1;
            while kk<=length(stl_smooth)
                str = strtok(stl_smooth(kk).name,'.');
                if ~all(isstrprop(str,'digit'))
                    stl_smooth(kk) = [];
                else
                    kk = kk+1;
                end
            end
            copyfile([component_dir{ii} stl_smooth(end).name],[all_dir component_name{ii} '.stl']);
        else
            stl = stlread([component_dir{ii} stl_names.name]);
            comp_name = component_name{ii};
            vertices = RtAspects.(comp_name).R*stl.vertices';
            stl.vertices = vertices' + repmat(RtAspects.(comp_name).t',size(stl.vertices,1),1);
            stlwrite([all_dir component_name{ii} '.stl'],stl.faces, stl.vertices,'FaceColor',[1 1 1]);
        end
        
    end
    
    all_names = dir([all_dir '*.stl']);
    
    if length(all_names)>1
        aspects_stl = [];
        for ii=1:length(all_names)
            stl = stlread([all_dir all_names(ii).name]);
            comp_name = strtok(all_names(ii).name,'.');
            vertices = RtComponents.(comp_name).R*stl.vertices';
            stl.vertices = vertices' + repmat(RtComponents.(comp_name).t',size(stl.vertices,1),1);
            aspects_stl = [aspects_stl stl];
        end
        [vol,gridout] = stl2sdf(aspects_stl,[128,128,128],[8,8,8]);
        smoothLS(vol,ones([128,128,128]),gridout.min',gridout.max',gridout.dx',5,true,all_dir);
    end
    
end

# Component-wise Modeling of Articulated Objects


This repository contains the source code corresponding to the method presented in the paper:

* **Component-wise Modeling of Articulated Objects**, V. Ntouskos, M. Sanzari, B. Cafaro, F. Nardi, F. Natola, F. Pirri, M. Ruiz, ICCV'15.

###Contact: 

Valsamis Ntouskos <ntouskos@diag.uniroma1.it>, [http://www.diag.uniroma1.it/~ntouskos](http://www.diag.uniroma1.it/~ntouskos);

Marta Sanzari <sanzari@diag.uniroma1.it>;

ALCOR Lab <alcor@diag.uniroma1.it> [http://www.diag.uniroma1.it/~alcor](http://www.diag.uniroma1.it/~alcor), 


##Instructions##

In order to perform the modeling, a structure with fields matching the names of the components is required as input. Each field is a structure array with as many elements as the number of aspects used to model this specific component. Finally, each element of this array holds a structure containing the binary segmentation mask of the aspect in the respective image.

To run the program you first need to add the 'third party' folder and all its sub-folders in the Matlab path. Then you need to change the current directory to the 'scripts' folder and run the 'main' function providing as arguments the aforementioned structure and a path were the results will be stored.

Currently, for the example provided with this code, the transformations required for the registration between the aspects and the component assembling have been precomputed and are provided in the files 'RtAspects.mat' and 'RtComponents.mat' respectively. The source code for automatically estimating these transformations will be added soon.

##Quickstart
1. Compile the CUDA kernels located in the `./scripts/cuda` folder. Under Windows you can use the provided Makefile: `nmake -f Makefile.win all`;

1. Download Ian Mitchell's [ToolboxLS](https://bitbucket.org/ian_mitchell/toolboxls "ToolboxLS") and add it to the Matlab path;

1. Add `Third Party` and all its subfolders to Matlab's path;

1. Load the structure containing the required data:
`load('./data/Dog.mat')`;

1. Switch to the scripts directory `cd scripts`, and execute the main script:
`main(Dog,'../data')`.


The `.stl` files of the final object will be saved in `articulated-object-modeling/All`. In the same folder all the iterations of the smoothing algorithm will be also saved.

## External dependencies 
* Ian Mitchell's [ToolboxLS](https://bitbucket.org/ian_mitchell/toolboxls "ToolboxLS")

* Gentian Zavalani's DunavantData function (included in `third party` folder, original available [here](http://www.mathworks.com/matlabcentral/fileexchange/52200-finite-element-methods--master-thesis---matlab-code/content/MSC%20THESIES/DunavantData.m "MSC")) 

* Sven Holcombe's stlwrite function (included in `third party` folder, original available [here](http://www.mathworks.com/matlabcentral/fileexchange/20922-stlwrite-filename--varargin-))

* Eric Johnson's stlread function (included in `third party` folder, original available [here](http://www.mathworks.com/matlabcentral/fileexchange/22409-stl-file-reader/content/STLRead/stlread.m))
 

You also need the CUDA Toolkit (version 6 or later) and a compatible compiler in order to compile the CUDA kernels. 
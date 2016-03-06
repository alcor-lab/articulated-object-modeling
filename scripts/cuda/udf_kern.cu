// Authors: Valsamis Ntouskos, ntouskos@diag.uniroma1.it; Bruno Cafaro, cafaro@diag.uniroma1.it 

#include <math_constants.h>

#define sq(x) ((x)*(x))

__global__ void udf(float *udf, float *ipf, unsigned int *ind, 
                    const float *vert3, const float *normals3,
                    float *min3, float *del3, unsigned int *res3, unsigned int numpts)
{
	unsigned int i = threadIdx.x + blockIdx.x * blockDim.x;
    if (i>=res3[0]) {
        return;
    }
	
    unsigned int j = threadIdx.y + blockIdx.y * blockDim.y;
    if (j>=res3[1]) {
        return;
    }
    
	unsigned int k = threadIdx.z + blockIdx.z * blockDim.z;
    if (k>=res3[2]) {
        return;
    }
    
	unsigned int voxind = i+j*res3[0]+k*res3[0]*res3[1];

	float xvox = min3[0] + del3[0]*(i+0.5);
    float yvox = min3[1] + del3[1]*(j+0.5);
    float zvox = min3[2] + del3[2]*(k+0.5);
    
    for( unsigned int kk = 0; kk < numpts; kk++ ) {
        float xvert = vert3[kk]; 
        float yvert = vert3[numpts*1+kk]; 
        float zvert = vert3[numpts*2+kk];
        
        float dis = sqrt(sq(xvox-xvert)+sq(yvox-yvert)+sq(zvox-zvert));
        
        if (dis < udf[voxind]){
            udf[voxind] = dis;
            ind[voxind] = kk;
            
            float xnorm = normals3[kk];
            float ynorm = normals3[numpts*1+kk];
            float znorm = normals3[numpts*2+kk];
            
            ipf[voxind] = - ((xvox - xvert)*xnorm + (yvox - yvert)*ynorm + (zvox - zvert)*znorm);
        }
    }
	//__syncthreads();
}

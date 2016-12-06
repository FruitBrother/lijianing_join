#include<stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <sys/time.h>
#include "table_item.h"




long getCurrentTime()    
{    
   struct timeval tv;    
   gettimeofday(&tv,NULL);    
   return tv.tv_sec * 1000 + tv.tv_usec / 1000;       
} 
__device__ int hash(char str[])
{
	int result=0;
	int x;
	for(x=0;x<10;x++)
		{
			if(str[x]!='\0')
				result=result*10+(str[x]-'0');
			else
	
				break;		
			
		}
	return result;
}
__global__ void join(struct order_item* g_order, struct user_item* g_user,struct result_item* g_result,int g_o_size,int g_u_size,int *cnt)
{

	
	
	
	

	
        int wh = 0;
	int i,k;
	
	//int row  = blockIdx.y * blockDim.y + threadIdx.y;    
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
	int count = 0;
	int base=((g_u_size/DIM)+1)*10*tid;
	for(i=tid;i<g_u_size;i=i+DIM)
	{
		
	
		int index=(hash(g_user[i].col1)%(g_o_size/10))*10;
		int point=index;
		//if(g_order[point].flag==0)
		//	continue;
		//else
		//{
			do
			{
				if(g_order[point].flag==0)
					break;
				wh = 0;
			
				for(k=0;k<10;k++)
				{
					if(g_order[point].col1[k]!=g_user[i].col1[k])
					{
						wh = 1;
						break;
					}
				}
				if(wh==0)
				{	
					for(k=0;k<10;k++)
					{
				
								g_result[base+count].col1[k]=g_order[point].col1[k];
					
					}
					for(k=0;k<10;k++)
					{
			
								g_result[base+count].col2[k]=g_user[i].col1[k];
		
					}
					for(k=0;k<10;k++)
					{
		
								g_result[base+count].col3[k]=g_order[point].col2[k];
			
					}
					for(k=0;k<10;k++)
					{
	
								g_result[base+count].col4[k]=g_user[i].col2[k];
						
					}	
					g_result[base+count].flag=1;
					
					count++;
					

				}
				point++;
			
			}
			while(point<(index+10));
		//}
	}
	cnt[tid]=count;
			
			
       			
}
extern "C" void to_gpu(struct order_item* order, struct user_item* user,struct join_acce_result *result,int o_size,int u_size)
{
	
	int sum_size=((u_size/DIM)+1)*DIM*10;
	int i;
	int *cnt=(int*)malloc(sizeof(int)*DIM);
	int *gpu_cnt;
	cudaMalloc(&gpu_cnt, sizeof(int)*DIM);
	cudaMemset(gpu_cnt,0,sizeof(int)*DIM);
	struct result_item* g_result;
	
	cudaMalloc(&g_result,sizeof(struct result_item)*sum_size);
	cudaMemset(g_result,0,sizeof(struct result_item)*sum_size);	
		
	struct order_item* g_order;
	struct user_item* g_user;
	
	
	
	
	cudaMalloc(&g_order,sizeof(struct order_item)*o_size);

	cudaMalloc(&g_user,sizeof(struct user_item)*u_size);

	cudaMemcpy(g_order, order, sizeof(struct order_item)*o_size, cudaMemcpyHostToDevice);
	
	cudaMemcpy(g_user, user, sizeof(struct user_item)*u_size, cudaMemcpyHostToDevice);
	
	//dim3 dimBlock(8,8);
	//dim3 dimGrid(1,1);
	join<<<1,8>>>(g_order,g_user,g_result,o_size,u_size,gpu_cnt);

cudaMemcpy(cnt, gpu_cnt, sizeof(int)*DIM, cudaMemcpyDeviceToHost);

	result->result_len=0;
	for(i=0;i<DIM;i++)
		
		{
			
			result->result_len =  result->result_len+cnt[i];
                  	
                }

	
	struct result_item* p_result = (struct result_item*)malloc(sizeof(struct result_item)*sum_size);
	cudaMemcpy(p_result, g_result, sizeof(struct result_item)*sum_size, cudaMemcpyDeviceToHost);
	result->result_addr = p_result;

		

	
	



	
	cudaFree(g_result);
	cudaFree(g_order);
	cudaFree(g_user);

	return ;
}

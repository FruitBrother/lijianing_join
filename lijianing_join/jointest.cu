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
__global__ void join(struct order_item* g_order, struct user_item* g_user,struct result_item* g_result,int g_o_size,int g_u_size,int *cnt)
{
	int dimx=g_o_size/TX+1;
	int dimy=g_u_size/TY+1;
	int base;
        int wh = 0;
	int i,j,k;
	int count = 0;
	int row  = blockIdx.x * blockDim.x + threadIdx.x;    
    	int col =  blockIdx.y * blockDim.y + threadIdx.y;
	base=row*dimx*g_u_size+col*dimx*dimy;
	for(i=row;i<g_o_size;i=i+TX)
		for(j=col;j<g_u_size;j=j+TY)
		{
			wh = 0;
			
			for(k=0;k<10;k++)
			{
				if(g_order[i].col1[k]=='\0'&&g_user[j].col1[k]=='\0')
					break;
				if(g_order[i].col1[k]!=g_user[j].col1[k])
				{
					wh = 1;
					break;
				}
			}
			if(wh==0)
			{	
				for(k=0;k<10;k++)
				{
					if(g_order[i].col1[k]!='\0')
						{
							g_result[base+count].col1[k]=g_order[i].col1[k];
						}
				}
				for(k=0;k<10;k++)
				{
					if(g_user[j].col1[k]!='\0')
						{
							g_result[base+count].col2[k]=g_user[j].col1[k];
						}
				}
				for(k=0;k<10;k++)
				{
					if(g_order[i].col2[k]!='\0')
						{
							g_result[base+count].col3[k]=g_order[i].col2[k];
						}
				}
				for(k=0;k<10;k++)
				{
					if(g_user[j].col2[k]!='\0')
						{
							g_result[base+count].col4[k]=g_user[j].col2[k];
						}
				}	
				g_result[base+count].flag=1;
				count++;
			}
	
		}
	
                              
				cnt[row*TY+col]=count;
				
}
extern "C" void to_gpu(struct order_item* order, struct user_item* user,struct join_acce_result *result,int o_size,int u_size)
{
	int sum_size=(o_size/TX+1)*TX*(u_size/TY+1)*TY;
	int i,j;
	int *cnt=(int*)malloc(sizeof(int)*TX*TY);;
	int *gpu_cnt;
	cudaMalloc(&gpu_cnt, sizeof(int)*TX*TY);
	struct result_item* g_result;
	
	cudaMalloc(&g_result,sizeof(struct result_item)*sum_size);
	cudaMemset(g_result,0,sizeof(struct result_item)*sum_size);	
		
	struct order_item* g_order;
	struct user_item* g_user;
	
	
	
	//struct order_item* g_order=(struct order_item*)malloc(sizeof(struct order_item)*o_size);//cuda
	cudaMalloc(&g_order,sizeof(struct order_item)*o_size);
	//struct user_item* g_user=(struct user_item*)malloc(sizeof(struct user_item)*u_size);//cuda
	cudaMalloc(&g_user,sizeof(struct user_item)*u_size);
	//struct result_item* g_result = (struct result_item*)malloc(sizeof(struct result_item)*o_size*u_size); //cuda
	
	//struct join_acce_result* gpu_result = (struct join_acce_result*)malloc(sizeof(struct join_acce_result)*1);  //cuda
	

	
	//memset(g_result,0,sizeof(struct result_item)*o_size*u_size);  //cuda
	


	//memcpy(g_order,order,sizeof(struct order_item)*o_size);//cuda
	cudaMemcpy(g_order, order, sizeof(struct order_item)*o_size, cudaMemcpyHostToDevice);
	//memcpy(g_user,user,sizeof(struct user_item)*u_size);	//cuda
	cudaMemcpy(g_user, user, sizeof(struct user_item)*u_size, cudaMemcpyHostToDevice);
	
	dim3 dimBlock(8,8);
	dim3 dimGrid(2,2); 
	
	join<<<dimGrid,dimBlock>>>(g_order,g_user,g_result,o_size,u_size,gpu_cnt);
	//memcpy(p_result,gpu_result->result_addr,sizeof(struct result_item)*gpu_result->result_len);//cuda	

cudaMemcpy(cnt, gpu_cnt, sizeof(int)*TX*TY, cudaMemcpyDeviceToHost);

	result->result_len=0;
	for(i=0;i<TX;i++)
		for(j=0;j<TY;j++)
		{
			
			result->result_len =  result->result_len+cnt[i*TY+j];
                       // printf("lalalalalalalalalala%d\n",cnt[i*TY+j]);
                }
       	//printf("zongchangdulalalalalalalalalala%d\n",result->result_len);

	
	struct result_item* p_result = (struct result_item*)malloc(sizeof(struct result_item)*sum_size);
	cudaMemcpy(p_result, g_result, sizeof(struct result_item)*sum_size, cudaMemcpyDeviceToHost);
	result->result_addr = p_result;
//cudaMemcpy(result, gpu_result, sizeof(struct join_acce_result), cudaMemcpyDeviceToHost);
	
		

	
	



	
	cudaFree(g_result);
	cudaFree(g_order);
	cudaFree(g_user);
	return ;
}

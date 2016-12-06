#include<stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <sys/time.h>
#include "table_item.h"

int count = 0;


long getCurrentTime()    
{    
   struct timeval tv;    
   gettimeofday(&tv,NULL);    
   return tv.tv_sec * 1000 + tv.tv_usec / 1000;    
} 

extern "C" void to_gpu(struct order_item* order, struct user_item* user,struct join_acce_result *result,int o_size,int u_size)
{
	
	int sum_size=o_size*u_size;
	int i,j,wh,k;
	struct result_item* g_result = (struct result_item*)malloc(sizeof(struct result_item)*sum_size);
	
	memset(g_result,0,sizeof(struct result_item)*sum_size);


	
	for(i=0;i<o_size;i++)
		for(j=0;j<u_size;j++)
		{
			wh = 0;
			
			for(k=0;k<10;k++)
			{
				if(order[i].col1[k]=='\0'&&user[j].col1[k]=='\0')
					break;
				if(order[i].col1[k]!=user[j].col1[k])
				{
					wh = 1;
					break;
				}
			}
			if(wh==0)
			{	
				for(k=0;k<10;k++)
				{
					if(order[i].col1[k]!='\0')
						{
							//g_result[count].col1[k]=order[i].col1[k];
						}
				}
				for(k=0;k<10;k++)
				{
					if(user[j].col1[k]!='\0')
						{
							//g_result[count].col2[k]=user[j].col1[k];
						}
				}
				for(k=0;k<10;k++)
				{
					if(order[i].col2[k]!='\0')
						{
							//g_result[count].col3[k]=order[i].col2[k];
						}
				}
				for(k=0;k<10;k++)
				{
					if(user[j].col2[k]!='\0')
						{
							//g_result[count].col4[k]=user[j].col2[k];
						}
				}	
				//g_result[count].flag=1;
				count++;
			}
	
		}

	result->result_len=100;

	
	result->result_addr = g_result;

	

	
	



	

	

	return ;
}

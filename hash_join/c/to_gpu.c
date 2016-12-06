#include<stdio.h>
#include "Join_tmp.h"
#include "table_item.h"
#include <stdlib.h>
#include <malloc.h>
#include <dlfcn.h>
#include <string.h>

void *handle;
void (*p_to_gpu)(struct order_item* order, struct user_item* user, struct join_acce_result* result, int o_size,int u_size);
int hash(const char* str)
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

JNIEXPORT jobjectArray JNICALL Java_Join_1tmp_get_1result
 (JNIEnv * env, jclass cls, jobjectArray ocol1, jobjectArray ocol2, jobjectArray ucol1, jobjectArray ucol2, jstring cudaFile,int o_size, int u_size)
{
	
	
	struct order_item* order=(struct order_item*)malloc(sizeof(struct order_item)*o_size*10);
	struct user_item* user=(struct user_item*)malloc(sizeof(struct user_item)*u_size);

	memset(order,0,sizeof(struct order_item)*o_size*10);
	memset(user,0,sizeof(struct user_item)*u_size);	
	
	int i,x;
	for (i = 0; i < o_size; i++) 
	{
		jstring string1 = (jstring)((*env)->GetObjectArrayElement(env,ocol1, i));
		jstring string2 = (jstring)((*env)->GetObjectArrayElement(env,ocol2, i));

		const char * chars1 =  (*env)->GetStringUTFChars(env,string1, 0);
		const char * chars2 =  (*env)->GetStringUTFChars(env,string2, 0);

		int index = (hash(chars1)%o_size)*10;
		

			while(order[index].flag!=0)
			{
				index++;
			}

		order[index].flag=1;
		
	
			for(x=0;x<10;x++)
			{
				if(chars1[x]!='\0')
					order[index].col1[x]=chars1[x];
				else
	
					break;		
			
			}
			for(x=0;x<10;x++)
			{
				if(chars2[x]!='\0')
					order[index].col2[x]=chars2[x];
				else
	
					break;		
					
			}
			
			(*env)->ReleaseStringUTFChars(env,string1, chars1);
			(*env)->ReleaseStringUTFChars(env,string2, chars2);
	}
	for (i = 0; i < u_size; i++) 
	{
		jstring string1 = (jstring)((*env)->GetObjectArrayElement(env,ucol1, i));
		jstring string2 = (jstring)((*env)->GetObjectArrayElement(env,ucol2, i));
	
		const char * chars1 =  (*env)->GetStringUTFChars(env,string1, 0);
		const char * chars2 =  (*env)->GetStringUTFChars(env,string2, 0);
		
		for(x=0;x<10;x++)
		{
			if(chars1[x]!='\0')
				user[i].col1[x]=chars1[x];
			else
		
				break;		
			
		}
		for(x=0;x<10;x++)
		{
			if(chars2[x]!='\0')
				user[i].col2[x]=chars2[x];
			else
		
				break;		
				
		}

		(*env)->ReleaseStringUTFChars(env,string1, chars1);
		(*env)->ReleaseStringUTFChars(env,string2, chars2);
	

	}

	const char *cudaF = NULL;
	cudaF = (*env)->GetStringUTFChars(env,cudaFile, 0);

	handle = dlopen(cudaF,RTLD_NOW);

	if(!handle)
    	{
        	printf("%s \n",dlerror());
		return NULL;
    	}
	dlerror();
	p_to_gpu=dlsym(handle,"to_gpu");
	
	struct join_acce_result result;
	p_to_gpu(order,user,&result,o_size*10,u_size);
	

	jclass objClass = (*env)->FindClass(env, "java/lang/String");
	jobjectArray re= (*env)->NewObjectArray(env,(jsize)result.result_len, objClass, 0);
	jstring jstr;
	int sum_size=((u_size/DIM)+1)*DIM*10;
	int k=0;
	for(i=0;i<sum_size;i++)
	{
		if(result.result_addr[i].flag==1)
		{
			int str_len = strlen(result.result_addr[i].col1)+strlen(result.result_addr[i].col2)+strlen(result.result_addr[i].col3)+strlen(result.result_addr[i].col4)+1;
			char * outcome = (char*)malloc(sizeof(char)*str_len);
			memset(outcome, 0, sizeof(char)*str_len);
			strcat(outcome,result.result_addr[i].col1);
			strcat(outcome,",");
			strcat(outcome,result.result_addr[i].col2);
			strcat(outcome,",");
			strcat(outcome,result.result_addr[i].col3);
			strcat(outcome,",");
			strcat(outcome,result.result_addr[i].col4);
			jstr = (*env)->NewStringUTF( env, outcome );
			(*env)->SetObjectArrayElement(env, re, k++, jstr);
			//printf("%s\n",outcome);
			free(outcome);
		}
	}

	free(order);
	free(user);
	
	free(result.result_addr);
	return re;
}

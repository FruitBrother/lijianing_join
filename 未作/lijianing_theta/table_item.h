#ifndef _TABLE_ITEM_H_
#define _TABLE_ITEM_H_
#define TX 16
#define TY 16
struct order_item{
	char col1[10];
	char col2[10];

};

struct user_item{
	char col1[10];
	char col2[10];

};

struct result_item{
	int flag;
	char col1[10];
	char col2[10];
	char col3[10];
	char col4[10];
};

struct join_acce_result{
	
	int result_len;
	struct result_item* result_addr;
};
#endif

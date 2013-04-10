//
//  PageListViewController.h
//  Gospel_IOS
//
//  Created by sang alfred on 4/10/13.
//  Copyright (c) 2013 sang alfred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@protocol PageListViewControllerProtocol <NSObject>
@required
-(void)reload_with_cur_page_number:(int)cur_page_number;

-(int)set_page_count;

-(void)first_init_data;
-(void)reload_next_page:(int)cur_page_number;
@end

@interface PageListViewController : ListViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,assign,readwrite) id <PageListViewControllerProtocol>delegate;
 

@property(nonatomic,retain,readwrite) NSMutableArray *result_array;
@property(nonatomic,assign,readwrite) int *cur_page_number;
@property(nonatomic,assign,readwrite) int *page_count;



-(void)first_init_data_callback:(NSMutableArray *)r;
-(void)reload_next_page_callback:(NSMutableArray *)r;
@end

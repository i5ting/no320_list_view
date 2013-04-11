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

-(int)set_page_count;

-(void)init_table_data;
-(void)reload_next_page:(int)cur_page_number;

- (UITableViewCell *)page_list_view:(UITableView *)tableView cell_for_row_at_index_path:(NSIndexPath *)indexPath;
- (void)page_list_view:(UITableView *)tableView did_select_row_at_index_path:(NSIndexPath *)indexPath;
- (CGFloat)page_list_view:(UITableView *)tableView height_for_row_at_index_path:(NSIndexPath *)indexPath;
 
@end

@protocol PageListViewWithModeControllerProtocol <PageListViewControllerProtocol>

@required
- (UITableViewCell *)page_list_view_next_page:(UITableView *)tableView cell_for_row_at_index_path:(NSIndexPath *)indexPath has_more_page:(Boolean)has_next;
- (void)page_list_view_next_page:(UITableView *)tableView did_select_row_at_index_path:(NSIndexPath *)indexPath  has_more_page:(Boolean)has_next;
- (CGFloat)page_list_view_next_page:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  has_more_page:(Boolean)has_next;


@optional
//如果没有实现page_list_view_next_page方法，则同所有cell高度
- (CGFloat)page_list_view_next_page:(UITableView *)tableView height_for_row_at_index_path:(NSIndexPath *)indexPath has_more_page:(Boolean)has_next;
@end



@interface PageListViewController : ListViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,assign,readwrite) id <PageListViewWithModeControllerProtocol>delegate;
 

@property(nonatomic,retain,readwrite) NSMutableArray *result_array;
@property(nonatomic,assign,readwrite) int cur_page_number;
@property(nonatomic,assign,readwrite) int page_count;
@property(nonatomic,assign,readwrite) Boolean _has_more_page;



-(void)init_table_data_callback:(NSArray *)r;
-(void)reload_next_page_callback:(NSArray *)r;

-(void)get_next_page;



@end




typedef enum {
    PageListViewModeNone = 0,
    PageListViewModeDrag = 1,
    PageListViewModeCell = 2
} PageListViewMode;


@interface PageListViewWithModeController : PageListViewController{
    PageListViewMode _mode;
}

-(id)init_with_frame:(CGRect)frame  mode:(PageListViewMode)mode;

@end
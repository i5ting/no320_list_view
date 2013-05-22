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


- (UITableViewCell *)page_list_view:(UITableView *)tableView cell_for_row_at_index_path:(NSIndexPath *)indexPath;
- (void)page_list_view:(UITableView *)tableView did_select_row_at_index_path:(NSIndexPath *)indexPath;
- (CGFloat)page_list_view:(UITableView *)tableView height_for_row_at_index_path:(NSIndexPath *)indexPath;

@optional
-(void)init_table_data;
-(void)reload_next_page:(int)cur_page_number;


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


/**
 * PageListViewController 是处理下拉刷新的list view组件
 *
 * 处理2种情况：
 *      - 首次 init_table_data（下啦刷新用这个，一般是viewwillapp里，加载的是第一页）
 *      - 点击加载下一页 reload_next_page（加载的 2+ 页）
 *
 */
@interface PageListViewController : ListViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic,assign,readwrite) id <PageListViewWithModeControllerProtocol>delegate;
 
/**
 * table数据源
 */
@property(nonatomic,retain,readwrite) NSMutableArray *result_array;

/**
 * 当前页码
 */
@property(nonatomic,assign,readwrite) int cur_page_number;

/**
 * 每页最多数
 */
@property(nonatomic,assign,readwrite) int page_count;

/**
 * 是否有下一页
 */
@property(nonatomic,assign,readwrite) Boolean _has_more_page;


/**
 * 首次获取数据成功后的回掉方法
 */
-(void)init_table_data_callback:(NSArray *)r;

/**
 * 获取下一页数据成功后的回掉方法
 */
-(void)reload_next_page_callback:(NSArray *)r;

/**
 * 获取下一页数据
 */
-(void)get_next_page;



- (void)reloadDataSource:(NSArray *)r;

@end




typedef enum {
    PageListViewModeNone = 0, //不使用任何样式 
    PageListViewModeDrag = 1, //上拉加载下一页
    PageListViewModeCell = 2  //点击cell加载下一页
} PageListViewMode;

/**
 * PageListViewWithModeController 是处理下拉刷新，然后在下面有加载下一页的list view组件
 *
 * 有3中加载下一页处理的mode：@see PageListViewMode
 * 
 */
@interface PageListViewWithModeController : PageListViewController{
    PageListViewMode _mode;
}

-(id)init_with_frame:(CGRect)frame  mode:(PageListViewMode)mode;

@end
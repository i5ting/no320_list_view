//
//  PageListViewController.m
//  Gospel_IOS
//
//  Created by sang alfred on 4/10/13.
//  Copyright (c) 2013 sang alfred. All rights reserved.
//

#import "PageListViewController.h"

@interface PageListViewController()

//根据返回数据长度，判断是否有下一页
-(void)set_is_has_next_page:(int)cur_arrry_count;


@end

@implementation PageListViewController
@synthesize delegate;
@synthesize result_array,cur_page_number,page_count;
@synthesize _has_more_page;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ListViewController

// This is the core method you should implement
- (void)reloadTableViewDataSource {
	_reloading = YES;
    
    self.cur_page_number = 1;
    // Here you would make an HTTP request or something like that
    
    if ([delegate respondsToSelector:@selector(init_table_data)]) {
         [delegate init_table_data];
    }
}


-(void)init_table_data_callback:(NSArray *)r
{
    self.cur_page_number = 1;
    self.result_array = r;
    
    if ([delegate respondsToSelector:@selector(set_page_count)]) {
        self.page_count = [delegate set_page_count] > 0 ?  [delegate set_page_count]: [self.result_array count];
    }else{
        self.page_count = [self.result_array count];
    }
    
    NSLog(@"-----%@",[NSString stringWithFormat:@"%d",self.cur_page_number]);
    
    [self set_is_has_next_page:[r count]];
    [self.table reloadData];
    
    // Call [self doneLoadingTableViewData] when you are done
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}



-(void)reloadNextPage{
    self.cur_page_number = self.cur_page_number + 1;
    
    NSLog(@"-----%@",[NSString stringWithFormat:@"%d",self.cur_page_number]);
    
    if ([delegate respondsToSelector:@selector(reload_next_page:)]) {
        [delegate reload_next_page:self.cur_page_number];
    }
}


-(void)reload_next_page_callback:(NSArray *)p
{
    NSMutableArray *r = [NSMutableArray arrayWithArray:self.result_array];
    [r addObjectsFromArray:p];
    self.result_array = r;
      
    [self set_is_has_next_page:[p count]];
    [self.table reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.result_array count];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
//    }
//    
//    NSDictionary *d = [self.result_array objectAtIndex:indexPath.row];
//    if ([[d objectForKey:@"news"] count]>0) {
//        NSString *title = [[[d objectForKey:@"news"] objectAtIndex:0] objectForKey:@"title"];
//        cell.textLabel.text = [NSString stringWithFormat:@"#%d %@", indexPath.row,title];
//    }else{
//        cell.textLabel.text = [NSString stringWithFormat:@"#%d  ", indexPath.row];
//    }
//    
//    return cell;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	return [NSString stringWithFormat:@"Section %i", section];
//}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected cell at section #%d and row #%d", indexPath.section, indexPath.row);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_has_more_page) {
        int contentHeight = scrollView.contentSize.height;
        contentHeight = contentHeight>=scrollView.bounds.size.height?contentHeight:scrollView.bounds.size.height;
        int extraHeight = contentHeight - scrollView.bounds.size.height;
        if (scrollView.contentOffset.y>extraHeight + 45) {
            [self get_next_page];
        }
    }
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated{
    [self reloadTableViewDataSource];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload]; // Always call superclass methods first, since you are using inheritance
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Public methods

-(void)get_next_page{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadNextPage) object:nil];
    [self performSelector:@selector(reloadNextPage) withObject:nil afterDelay:.1];
}



#pragma mark - Private methods

-(void)set_is_has_next_page:(int)cur_arrry_count
{
    //根据返回数据长度，判断是否有下一页
    if (cur_arrry_count == self.page_count) {
        _has_more_page = YES;
    }else{
        _has_more_page = NO;
    }
}

@end






@implementation PageListViewWithModeController


-(id)init_with_frame:(CGRect)frame  mode:(PageListViewMode)mode{
    if (self = [super initWithFrame:frame]) {
        _mode = mode;
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_mode) {
        case PageListViewModeNone:
             return  [self.result_array count];
            break;
        case PageListViewModeDrag:
            return  [self.result_array count];
            break;
            
        case PageListViewModeCell:
            return  [self.result_array count] + 1;
            break;
            
        default:
            break;
    }
    
    return  0;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_mode == PageListViewModeCell || _mode == PageListViewModeDrag) {
        if (self._has_more_page) {
            int contentHeight = scrollView.contentSize.height;
            contentHeight = contentHeight>=scrollView.bounds.size.height?contentHeight:scrollView.bounds.size.height;
            int extraHeight = contentHeight - scrollView.bounds.size.height;
            if (scrollView.contentOffset.y>extraHeight + 45) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadNextPage) object:nil];
                [self performSelector:@selector(reloadNextPage) withObject:nil afterDelay:.1];
            }
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.delegate respondsToSelector:@selector(page_list_view_next_page:cell_for_row_at_index_path:has_more_page:)]) {
        assert(@"cellForRowAtIndexPath fail");
    }
    
    switch (_mode) {
        case PageListViewModeNone:
            return  [self.delegate page_list_view:tableView cell_for_row_at_index_path:indexPath];
            break;
        case PageListViewModeDrag:
            return  [self.delegate page_list_view:tableView cell_for_row_at_index_path:indexPath];
            break;
        case PageListViewModeCell:
            if (indexPath.row< [self.result_array count]) {
                return  [self.delegate page_list_view:tableView cell_for_row_at_index_path:indexPath];
            }else{
                return  [self.delegate page_list_view_next_page:tableView cell_for_row_at_index_path:indexPath has_more_page:self._has_more_page];
            }
            
            break;
            
        default:
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.delegate respondsToSelector:@selector(page_list_view:did_select_row_at_index_path:)]) {
        return ;
    }
    
    switch (_mode) {
        case PageListViewModeNone:
            [self.delegate page_list_view:tableView did_select_row_at_index_path:indexPath];
            break;
        case PageListViewModeDrag:
            [self.delegate page_list_view:tableView did_select_row_at_index_path:indexPath];
            break;
        case PageListViewModeCell:
            if ([self.delegate respondsToSelector:@selector(page_list_view_next_page:heightForRowAtIndexPath:has_more_page:)]) {
                if (indexPath.row< [self.result_array count]) {
                    [self.delegate page_list_view:tableView did_select_row_at_index_path:indexPath];
                }else{
                    [self.delegate page_list_view_next_page:tableView did_select_row_at_index_path:indexPath has_more_page:self._has_more_page];
                }
            }else{
                [self page_list_view_next_page:tableView did_select_row_at_index_path:indexPath has_more_page:self._has_more_page];
            }
            break;
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.delegate respondsToSelector:@selector(page_list_view_next_page:height_for_row_at_index_path:has_more_page:)]) {
        return 44.0f;
    }
    switch (_mode) {
        case PageListViewModeNone:
            return [self.delegate page_list_view:tableView height_for_row_at_index_path:indexPath];
            break;
        case PageListViewModeDrag:
            return [self.delegate page_list_view:tableView height_for_row_at_index_path:indexPath];
            break;
        case PageListViewModeCell:
            //如果没有实现page_list_view_next_page方法，则同所有cell高度
            if ([self.delegate respondsToSelector:@selector(page_list_view_next_page:height_for_row_at_index_path:has_more_page:)]) {
                if (indexPath.row< [self.result_array count]) {
                    return [self.delegate page_list_view:tableView height_for_row_at_index_path:indexPath];
                }else{
                    return [self.delegate page_list_view_next_page:tableView height_for_row_at_index_path:indexPath has_more_page:self._has_more_page];
                }
            }else{
                return [self.delegate page_list_view:tableView height_for_row_at_index_path:indexPath];
            }
            
            break;
            
        default:
            break;
    }

}


- (void)page_list_view_next_page:(UITableView *)tableView did_select_row_at_index_path:(NSIndexPath *)indexPath  has_more_page:(Boolean)has_next
{
    if (has_next) {
        [self get_next_page];
    }
}

@end

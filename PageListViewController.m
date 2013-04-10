//
//  PageListViewController.m
//  Gospel_IOS
//
//  Created by sang alfred on 4/10/13.
//  Copyright (c) 2013 sang alfred. All rights reserved.
//

#import "PageListViewController.h"

@implementation PageListViewController
@synthesize delegate;
@synthesize result_array,cur_page_number,page_count;

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
    
    
    if ([delegate respondsToSelector:@selector(first_init_data)]) {
         [delegate first_init_data];
    }
    
    
  
}


-(void)first_init_data_callback:(NSMutableArray *)r
{
    self.cur_page_number = 1;
    self.result_array = r;
    
    if ([delegate respondsToSelector:@selector(set_page_count)]) {
        self.page_count = [delegate set_page_count] > 0 ?  [delegate set_page_count]: [self.result_array count];
    }else{
        self.page_count = [self.result_array count];
    }
    
    NSLog(@"-----%@",[NSString stringWithFormat:@"%d",self.cur_page_number]);
    
    [self.table reloadData];
    
    // Call [self doneLoadingTableViewData] when you are done
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}




-(void)reloadNextPage{
    self.cur_page_number = 2;
    
    NSLog(@"-----%@",[NSString stringWithFormat:@"%d",self.cur_page_number]);
    
    if ([delegate respondsToSelector:@selector(reload_next_page:)]) {
        [delegate reload_next_page:self.cur_page_number];
    }
}


-(void)reload_next_page_callback:(NSMutableArray *)p
{
    NSMutableArray *r = [NSMutableArray arrayWithArray:self.result_array];
    [r addObjectsFromArray:p];
    self.result_array = r;
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    NSDictionary *d = [self.result_array objectAtIndex:indexPath.row];
    if ([[d objectForKey:@"news"] count]>0) {
        NSString *title = [[[d objectForKey:@"news"] objectAtIndex:0] objectForKey:@"title"];
        cell.textLabel.text = [NSString stringWithFormat:@"#%d %@", indexPath.row,title];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"#%d  ", indexPath.row];
    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	return [NSString stringWithFormat:@"Section %i", section];
//}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected cell at section #%d and row #%d", indexPath.section, indexPath.row);
}

#pragma mark - View lifecycle


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentHeight = scrollView.contentSize.height;
    contentHeight = contentHeight>=scrollView.bounds.size.height?contentHeight:scrollView.bounds.size.height;
    int extraHeight = contentHeight - scrollView.bounds.size.height;
    if (scrollView.contentOffset.y>extraHeight + 45) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadNextPage) object:nil];
        [self performSelector:@selector(reloadNextPage) withObject:nil afterDelay:.1];
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [self reloadTableViewDataSource];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Pull down example";
   
}

- (void)viewDidUnload
{
    [super viewDidUnload]; // Always call superclass methods first, since you are using inheritance
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

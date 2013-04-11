//
//  ListViewController
//  Gospel_IOS
//
//  Created by sang alfred on 4/10/13.
//  Copyright (c) 2013 sang alfred. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"

@interface ListViewController : UIViewController <EGORefreshTableHeaderDelegate> {

    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    CGRect _frame;
}

@property (nonatomic, retain) IBOutlet UITableView* table;


-(id)initWithFrame:(CGRect)frame;

// 设置是否显示下拉UI
-(void)set_pull_down_enable:(Boolean)is_pull_down;

@end

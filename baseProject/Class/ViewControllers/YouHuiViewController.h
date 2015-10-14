//
//  YouHuiViewController.h
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

@interface YouHuiViewController : BaseViewController <CWRefreshTableViewDelegate> {
    
    IBOutlet UIButton *_leftBtn;
    IBOutlet UIButton *_rightBtn;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

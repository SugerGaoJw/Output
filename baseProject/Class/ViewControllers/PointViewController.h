//
//  PointViewController.h
//  baseProject
//
//  Created by Li on 15/3/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

@interface PointViewController : BaseViewController <CWRefreshTableViewDelegate>{
    
    IBOutlet UIButton *_leftBtn;
    IBOutlet UIButton *_rightBtn;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

//
//  SecondViewController.h
//  IOS
//
//  Created by lihj on 14-2-8.
//  Copyright (c) 2014年 Lihj. All rights reserved.
//

#import "BaseViewController.h"

@interface SecondViewController : BaseViewController <CWRefreshTableViewDelegate>{
    
    IBOutlet UIView *_headerView;
    
    
    IBOutlet UIButton *_topBtn0;
    IBOutlet UIButton *_topBtn1;
    IBOutlet UIButton *_topBtn2;
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;



@end

//
//  FourthViewController.h
//  IOS
//
//  Created by lihj on 14-2-8.
//  Copyright (c) 2014年 Lihj. All rights reserved.
//

#import "BaseViewController.h"

@interface FourthViewController : BaseViewController {
    
    IBOutlet UIView *_headerView;
    IBOutlet UIButton *_userDetailBtn;
    IBOutlet UIButton *_userAddBtn;
    IBOutlet UILabel *_topLine;
    IBOutlet UILabel *_userNameLbl;
    IBOutlet UIButton *_loginBtn;
}


@property (strong , nonatomic) IBOutlet UITableView *tableView;

@end

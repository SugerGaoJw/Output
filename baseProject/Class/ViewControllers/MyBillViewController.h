//
//  MyBillViewController.h
//  baseProject
//
//  Created by Li on 15/1/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

@interface MyBillViewController : BaseViewController <CWRefreshTableViewDelegate> {
    
    IBOutlet UILabel *_shouruLbl;
    IBOutlet UILabel *_zhichuLbl;
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

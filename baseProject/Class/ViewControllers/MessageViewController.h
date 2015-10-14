//
//  MessageViewController.h
//  baseProject
//
//  Created by Li on 15/1/13.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageViewController : BaseViewController <CWRefreshTableViewDelegate> {
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

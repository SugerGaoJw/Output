//
//  MyAccountViewController.h
//  baseProject
//
//  Created by Li on 15/1/6.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

@interface MyAccountViewController : BaseViewController {
    
}

@property (copy, nonatomic)NSString* integral; //积分
@property (copy, nonatomic)NSString* balance; //余额
@property (copy, nonatomic)NSString* amountNo; //帐号

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

//
//  MyOrderDetailViewController.h
//  baseProject
//
//  Created by Li on 15/2/6.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^MyOrderDetailViewControllerBlock)();

@interface MyOrderDetailViewController : BaseViewController {
    
    IBOutlet UIView *_headerView;
    IBOutlet UIView *_footerView;
    
    IBOutlet UILabel *_nameLbl;
    IBOutlet UILabel *_phoneLbl;
    IBOutlet UILabel *_createTime;
    IBOutlet UILabel *_arriveTime;
    IBOutlet UILabel *_messageLbl;
    IBOutlet UILabel *_addrLbl;
    IBOutlet UILabel *_couponLbl;
    
    IBOutlet UIButton *_cancelBtn;
    IBOutlet UIButton *_payBtn;
}

@property (copy)MyOrderDetailViewControllerBlock block;            //已取消block

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSDictionary *dataDic;

@end

//
//  OrderViewController.h
//  baseProject
//
//  Created by Li on 15/2/5.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderViewController : BaseViewController <CWRefreshTableViewDelegate>{
    
    IBOutlet UIButton *_typeBtn;
    IBOutlet UIView *_popView;
    IBOutlet UILabel *_tipLbl;
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *popTableView;
@property (nonatomic, assign) NSInteger selectType;

//套餐详情-猜你喜欢进来
@property (nonatomic, copy) NSDictionary *subDic;

@end

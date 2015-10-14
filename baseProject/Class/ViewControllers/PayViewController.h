//
//  PayViewController.h
//  baseProject
//
//  Created by Li on 15/3/21.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

@interface PayViewController : BaseViewController {
    
    IBOutlet UILabel *_priceLbl;
    IBOutlet UIButton *_payBtn;
}

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSDate *arrivalTime;

@property (nonatomic, copy) NSDictionary *numDic;

//是否从礼品兑换进入
@property (nonatomic, assign) BOOL gift;

//我的订单-付款进入
@property (nonatomic, copy) NSString *orderNum;


@property (nonatomic, copy) NSDictionary *couponDic;

@end

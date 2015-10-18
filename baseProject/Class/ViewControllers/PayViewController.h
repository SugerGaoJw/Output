//
//  PayViewController.h
//  baseProject
//
//  Created by Li on 15/3/21.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"
#import "TPKeyboardAvoidingCollectionView.h"
typedef NS_ENUM(NSInteger, PayType){
    /*!
     *  现金支付
     */
    PayTypeCash = 0,
    /*!
     *  支付宝支付
     */
    PayTypeALiPay,
    /*!
     *  易付宝支付
     */
    PayTypeYeePay,
    /*!
     *  微信支付
     */
    PayTypeWXPay,
    /*!
     *  优惠支付
     */
    PayTypeGiftPay,
};
@interface PayViewController : BaseViewController {
    
    __weak IBOutlet UILabel *_priceLbl;
    __weak IBOutlet UIButton *_payBtn;
    
    //统计面板显示
    __weak IBOutlet UILabel *_cntTotalPrice; //总计
    __weak IBOutlet UILabel *_cntDiscountPrice; //优惠
    __weak IBOutlet UILabel *_cntFinalPrice;    //合计
    
    __weak IBOutlet TPKeyboardAvoidingCollectionView *_mainScrollView;
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

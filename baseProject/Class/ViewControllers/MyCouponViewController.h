
//
//  MyCouponViewController.h
//  baseProject
//
//  Created by Li on 15/1/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"
/*!
 *  优惠劵类型
 */
typedef NS_ENUM(NSInteger,ENCouponType){
    /*!
     *  打折优惠劵
     */
    EnSaleOffCouponType = 0,
    /*!
     *  立减优惠劵
     */
    EnDiscountCouponType,
};

@protocol MyCouponDelegate <NSObject>
- (void)calBakCouponType:(ENCouponType)enCouponType CouponNum:(NSString *)couponNum;
@end

/*!
 *  我的优惠劵界面
 */

@interface MyCouponViewController : BaseViewController <CWRefreshTableViewDelegate> {
    
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;
//point to who's pushed
@property (weak, nonatomic)id<MyCouponDelegate> couponDelegate;
@end

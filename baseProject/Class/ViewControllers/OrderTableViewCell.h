//
//  OrderTableViewCell.h
//  baseProject
//
//  Created by Li on 15/2/5.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OrderTableViewCellNumBlock)(NSString *text);

@interface OrderTableViewCell : UITableViewCell {
    
    IBOutlet UIImageView *_imgVIew;
    IBOutlet UILabel *_nameLbl;
    IBOutlet UILabel *_priceLbl;
    
}

@property (copy)OrderTableViewCellNumBlock numBlock;

@property (strong, nonatomic) IBOutlet UILabel *countLbl;
@property (strong, nonatomic) IBOutlet UIButton *couponBtn;
@property (strong, nonatomic) IBOutlet UIButton *subtractBtn;
@property (strong, nonatomic) IBOutlet UIButton *plustBtn;


@property (nonatomic, copy) NSDictionary *dataDic;

////优惠券-优惠套餐进入
//@property (nonatomic, assign) BOOL ifYouhuiMeal;

@end

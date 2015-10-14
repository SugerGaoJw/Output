//
//  MyCouponTableViewCell.h
//  baseProject
//
//  Created by Li on 15/1/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponTableViewCell : UITableViewCell {
    
    IBOutlet UIImageView *_bkImageView;
    IBOutlet UILabel *_priceLbl;
    IBOutlet UILabel *_typeLbl;
    IBOutlet UILabel *_decLbl;
    IBOutlet UILabel *_timeLbl;
}

@property (nonatomic, copy) NSDictionary *dataDic;
@property (strong, nonatomic) IBOutlet UIButton *getCouponBtn;
@property (strong, nonatomic) IBOutlet UILabel *getCouponLbl;
@property (strong, nonatomic) IBOutlet UILabel *stateLbl;

@end

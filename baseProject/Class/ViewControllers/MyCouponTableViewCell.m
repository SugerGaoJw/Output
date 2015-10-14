//
//  MyCouponTableViewCell.m
//  baseProject
//
//  Created by Li on 15/1/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MyCouponTableViewCell.h"

@implementation MyCouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    if ([[dataDic objectForKey:@"couponType"] isEqualToString:@"折扣"]) {
        _bkImageView.image = [UIImage imageNamed:@"05-优惠券_折扣券.png"];
        _typeLbl.text = @"折扣券";
    }
    else if ([[dataDic objectForKey:@"couponType"] isEqualToString:@"抵用"]) {
        _bkImageView.image = [UIImage imageNamed:@"05-优惠券_现金券.png"];
        _typeLbl.text = @"元现金券";
    }
    _priceLbl.text = [dataDic objectForKey:@"couponPrice"];
    _decLbl.text = [NSString stringWithFormat:@"适用于%@套餐", [dataDic objectForKey:@"couponUseRegionDescription"]];
    _stateLbl.text = [dataDic objectForKey:@"useStatus"];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[dataDic objectForKey:@"couponStartTime"]];
    NSDate *date1 = [dateFormatter dateFromString:[dataDic objectForKey:@"couponEndTime"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSString *dateStr1 = [dateFormatter stringFromDate:date1];
    _timeLbl.text = [NSString stringWithFormat:@"使用时间：%@ - %@", dateStr, dateStr1];
}

@end

//
//  GiftTableViewCell.m
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "GiftTableViewCell.h"

@implementation GiftTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"imgUrl"]] placeholderImage:nil];
    _titleLbl.text = [dataDic objectForKey:@"name"];
    NSString *paymentCurrency = [dataDic objectForKey:@"paymentCurrency"];
    if ([paymentCurrency isEqualToString:@"Integral"]) {
        _pointLbl.text = [NSString stringWithFormat:@"需积分：%@", [dataDic objectForKey:@"price"]];
    }
    else if ([paymentCurrency isEqualToString:@"RMB"]) {
        _pointLbl.text = [NSString stringWithFormat:@"￥%@", [dataDic objectForKey:@"price"]];
    }
}

@end

//
//  MyOrderDetailTableViewCell.m
//  baseProject
//
//  Created by Li on 15/2/6.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MyOrderDetailTableViewCell.h"

@implementation MyOrderDetailTableViewCell

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
    _nameLbl.text = [dataDic objectForKey:@"foodsName"];
    _priceLbl.text = [NSString stringWithFormat:@"￥%@ x %@", [dataDic objectForKey:@"price"], [dataDic objectForKey:@"number"]];
    
    if ([[dataDic objectForKey:@"commentFields"] count] || _evalute) {
        _evaluateBtn.userInteractionEnabled = NO;
        [_evaluateBtn setTitle:@"已评价" forState:UIControlStateNormal];
    }
    else {
        _evaluateBtn.userInteractionEnabled = YES;
        [_evaluateBtn setTitle:@"评价" forState:UIControlStateNormal];
    }
}

@end

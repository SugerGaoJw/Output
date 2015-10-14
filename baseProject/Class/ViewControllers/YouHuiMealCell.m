//
//  YouHuiMealCell.m
//  baseProject
//
//  Created by Li on 15/2/28.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "YouHuiMealCell.h"

@implementation YouHuiMealCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    _nameLbl.text = [dataDic objectForKey:@"name"];
    _priceLbl.text = [NSString stringWithFormat:@"￥%@", [dataDic objectForKey:@"price"]];
    _numLbl.text = [NSString stringWithFormat:@"剩余%@份", [dataDic objectForKey:@"number"]];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"imgUrl"]] placeholderImage:nil];
}

@end

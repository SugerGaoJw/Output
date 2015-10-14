//
//  PresentTableViewCell.m
//  baseProject
//
//  Created by Li on 15/3/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "PresentTableViewCell.h"

@implementation PresentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    _timeLbl.text = [dataDic objectForKey:@"createTime"];
    _stateLbl.text = [NSString stringWithFormat:@"%@/%@", [dataDic objectForKey:@"status"], [dataDic objectForKey:@"payChannel"]];
    if ([[dataDic objectForKey:@"paymentCurrency"] isEqualToString:@"Integral"]) {
        _decLbl.text = [NSString stringWithFormat:@"积分%@", [dataDic objectForKey:@"total"]];
    }
    else {
        _decLbl.text = [NSString stringWithFormat:@"￥%@", [dataDic objectForKey:@"total"]];
    }
    NSArray *arr = [dataDic objectForKey:@"orderItem"];
    if (arr.count) {
        NSDictionary *dic = [arr objectAtIndex:0];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"imgUrl"]] placeholderImage:nil];
        _nameLbl.text = [dic objectForKey:@"goodsName"];
    }
}

@end

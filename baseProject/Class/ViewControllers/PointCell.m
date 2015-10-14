//
//  PointCell.m
//  baseProject
//
//  Created by Li on 15/3/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "PointCell.h"

@implementation PointCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    _titleLbl.text = [dataDic objectForKey:@"remark"];
    _timeLbl.text = [dataDic objectForKey:@"createTime"];
    _moneyLbl.text = [NSString stringWithFormat:@"%@%@", [dataDic objectForKey:@"incomeOrExpense"], [dataDic objectForKey:@"balance"]];
}

@end

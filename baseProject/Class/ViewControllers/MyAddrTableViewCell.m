//
//  MyAddrTableViewCell.m
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MyAddrTableViewCell.h"

@implementation MyAddrTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    _nameLbl.text = [NSString stringWithFormat:@"%@ %@", [dataDic objectForKey:@"name"], [dataDic objectForKey:@"phone"]];
    _addrLbl.text = [dataDic objectForKey:@"allAddress"];
}

@end

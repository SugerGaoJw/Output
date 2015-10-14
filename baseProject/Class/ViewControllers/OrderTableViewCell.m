//
//  OrderTableViewCell.m
//  baseProject
//
//  Created by Li on 15/2/5.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    [_imgVIew sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"imgUrl"]] placeholderImage:nil];
    _nameLbl.text = [dataDic objectForKey:@"name"];
    if (!_nameLbl.text.length) {
        _nameLbl.text = [dataDic objectForKey:@"foodsName"];
    }
    _priceLbl.text = [NSString stringWithFormat:@"￥%@", [dataDic objectForKey:@"price"]];
}

- (IBAction)plusBtnClick:(id)sender {
    _countLbl.text = [NSString stringWithFormat:@"%d", [_countLbl.text intValue]+1];
    if (self.numBlock) {
        self.numBlock(_countLbl.text);
    }
}

- (IBAction)subtractBtnClick:(id)sender {
    if ([_countLbl.text intValue] > 0) {
        _countLbl.text = [NSString stringWithFormat:@"%d", [_countLbl.text intValue]-1];
        if (self.numBlock) {
            self.numBlock(_countLbl.text);
        }
    }
}

@end

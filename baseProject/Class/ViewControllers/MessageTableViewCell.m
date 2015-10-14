//
//  MessageTableViewCell.m
//  baseProject
//
//  Created by Li on 15/1/13.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    _titleLbl.text = [dataDic objectForKey:@"title"];
    _decLbl.text = [dataDic objectForKey:@"centent"];
}

@end

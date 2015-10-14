//
//  MyBillTableViewCell.h
//  baseProject
//
//  Created by Li on 15/1/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBillTableViewCell : UITableViewCell {
    
    IBOutlet UILabel *_titleLbl;
    IBOutlet UILabel *_timeLbl;
    IBOutlet UILabel *_moneyLbl;
}

@property (nonatomic, copy) NSDictionary *dataDic;

@end

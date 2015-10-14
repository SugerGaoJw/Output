//
//  GiftTableViewCell.h
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftTableViewCell : UITableViewCell {
    
    IBOutlet UIImageView *_imgView;
    IBOutlet UILabel *_titleLbl;
    IBOutlet UILabel *_pointLbl;
}

@property (nonatomic, copy) NSDictionary *dataDic;
@property (strong, nonatomic) IBOutlet UIButton *exchangeBtn;

@end

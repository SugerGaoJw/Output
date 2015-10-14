//
//  SecondTableViewCell.h
//  baseProject
//
//  Created by Li on 15/2/5.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondTableViewCell : UITableViewCell {
    
    IBOutlet UIImageView *_imgView;
    IBOutlet UILabel *_timeLbl;
    IBOutlet UILabel *_stateLbl;
    IBOutlet UILabel *_nameLbl;
    IBOutlet UILabel *_addrLbl;
    IBOutlet UILabel *_priceLbl;
    IBOutlet UILabel *_tipLbl;
}

@property (nonatomic, copy) NSDictionary *dataDic;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *payBtn;

@end

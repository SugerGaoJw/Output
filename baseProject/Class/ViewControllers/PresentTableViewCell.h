//
//  PresentTableViewCell.h
//  baseProject
//
//  Created by Li on 15/3/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentTableViewCell : UITableViewCell {
    
    IBOutlet UIImageView *_imgView;
    IBOutlet UILabel *_timeLbl;
    IBOutlet UILabel *_stateLbl;
    IBOutlet UILabel *_nameLbl;
    IBOutlet UILabel *_decLbl;
}

@property (nonatomic, copy) NSDictionary *dataDic;

@end

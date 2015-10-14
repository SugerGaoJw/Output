//
//  YouHuiMealCell.h
//  baseProject
//
//  Created by Li on 15/2/28.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouHuiMealCell : UITableViewCell {
    
    IBOutlet UILabel *_nameLbl;
    IBOutlet UILabel *_priceLbl;
    IBOutlet UILabel *_numLbl;
    IBOutlet UIImageView *_imgView;
}

@property(nonatomic, copy) NSDictionary *dataDic;
@property (strong, nonatomic) IBOutlet UIButton *buyBtn;

@end

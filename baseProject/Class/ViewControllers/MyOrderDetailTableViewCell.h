//
//  MyOrderDetailTableViewCell.h
//  baseProject
//
//  Created by Li on 15/2/6.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderDetailTableViewCell : UITableViewCell {
    
    IBOutlet UIImageView *_imgView;
    IBOutlet UILabel *_nameLbl;
    IBOutlet UILabel *_priceLbl;
}

@property (nonatomic, copy) NSDictionary *dataDic;
@property (strong, nonatomic) IBOutlet UIButton *evaluateBtn;
@property (nonatomic, assign) BOOL evalute;

@end

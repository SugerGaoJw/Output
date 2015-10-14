//
//  OrderDetailViewController.h
//  baseProject
//
//  Created by Li on 15/2/6.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailViewController : BaseViewController {
    
}

@property (nonatomic, copy) NSDictionary *dataDic;
@property (strong, nonatomic) IBOutlet UIButton *dismissBtn;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UILabel *decLbl;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UIButton *imgView;
@property (strong, nonatomic) IBOutlet UILabel *priceLbl;
@property (strong, nonatomic) IBOutlet UILabel *countLbl;
@property (strong, nonatomic) IBOutlet UIButton *SubtracteBtn;
@property (strong, nonatomic) IBOutlet UIButton *plusBtn;

@end

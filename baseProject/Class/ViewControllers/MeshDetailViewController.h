//
//  MeshDetailViewController.h
//  baseProject
//
//  Created by Li on 15/1/13.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

@interface MeshDetailViewController : BaseViewController {
    
    IBOutlet UILabel *_nameLbl;
    IBOutlet UILabel *_addrLbl;
    IBOutlet UILabel *_telLbl;
}

@property (nonatomic, copy) NSDictionary *dataDic;

- (IBAction)telBtnClick:(id)sender;

@end

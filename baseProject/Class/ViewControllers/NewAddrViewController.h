//
//  NewAddrViewController.h
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^NewAddrViewControllerBlock) ();

@interface NewAddrViewController : BaseViewController {
    
    IBOutlet UIButton *_areaBtn;
    IBOutlet UIButton *_roadBtn;
    IBOutlet UITextField *_nameTextField;
    IBOutlet UITextField *_mobileTextField;
    IBOutlet UITextField *_addrTextField;
    IBOutlet UIButton *_checkBoxBtn;
}

@property (copy) NewAddrViewControllerBlock block;
@property (nonatomic, assign) BOOL update;
@property (nonatomic, copy) NSDictionary *dataDic;

//下单-定位位置-根据省市县名称查县的ID
@property (nonatomic, copy) NSString *locateAreaId;
@property (nonatomic, copy) NSString *locateName;

@end

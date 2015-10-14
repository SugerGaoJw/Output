//
//  BingPhoneViewController.h
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface BingPhoneViewController : BaseViewController {
    
    IBOutlet UIButton *_leftBtn;
    IBOutlet UIButton *_rightBtn;
    IBOutlet UIView *_leftView;
    IBOutlet UIView *_rightView;
    IBOutlet UIButton *_timerBtn;
    IBOutlet UITextField *_newPhoneTextField;
    IBOutlet UITextField *_newCodeTextField;
    IBOutlet UITextField *_newPsdTextField;
    IBOutlet UITextField *_oldPhoneTextField;
    IBOutlet UITextField *_oldCodeTextField;
}

@property (nonatomic ,copy) id<ISSPlatformUser> dataDic;

@end

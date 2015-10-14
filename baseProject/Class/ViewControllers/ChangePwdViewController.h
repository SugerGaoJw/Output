//
//  ChangePwdViewController.h
//  baseProject
//
//  Created by Li on 15/1/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangePwdViewController : BaseViewController {
    IBOutlet UITextField *_oldPwdTextField;
    IBOutlet UITextField *_newPwdTextField;
    IBOutlet UITextField *_newPwd1TextField;
}

@property (nonatomic, assign) BOOL paymentPwd;      //修改支付密码

@end

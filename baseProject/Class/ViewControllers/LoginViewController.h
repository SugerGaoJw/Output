//
//  LoginViewController.h
//  baseProject
//
//  Created by Li on 14/12/30.
//  Copyright (c) 2014年 Li. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController {
    
    IBOutlet UITextField *_phoneTextField;
    IBOutlet UITextField *_pwdTextField;
}

- (IBAction)loginBtnClick:(id)sender;
- (IBAction)getCodeBtnClick:(id)sender;
- (IBAction)qqLoginBtnClick:(id)sender;
- (IBAction)weChatBtnClick:(id)sender;

@end

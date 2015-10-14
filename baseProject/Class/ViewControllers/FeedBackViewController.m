//
//  GeXingQianMing.m
//  XMU
//
//  Created by lihj on 13-7-10.
//  Copyright (c) 2013年 林小果. All rights reserved.
//

#import "FeedBackViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kMaxWords 600

@interface FeedBackViewController ()

@end

static int rightBtnIndex = 0;

@implementation FeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)backAction {
    if (_textView.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未发送，是否放弃所做输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else {
        [super backAction];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"意见反馈";
    [self setRBtn:@"发送" image:nil imageSel:nil target:self action:@selector(rightClick)];
    rightBtnIndex = 0;

    _textView.layer.cornerRadius = 6;
	_textView.layer.masksToBounds = YES;
//    [_textView becomeFirstResponder];
    
    if (kMaxWords > 0) {
        [_wordsLbl setText:[NSString stringWithFormat:@"0/%d", kMaxWords]];
    }
    else {
        [_wordsLbl removeFromSuperview];
    }

    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}

- (void)rightClick {
    if (_textView.text.length > kMaxWords) {
        [shareFun showAlert:@"字数超过最大字数了！"];
        return;
    }
    if (_textView.text.length < 1) {
        [shareFun showAlert:@"您还没有输入"];
        return;
    }
    [self postFeedBack];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.textColor = [UIColor blackColor];
    textView.text = @"";
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > kMaxWords) {
        [_wordsLbl setTextColor:[UIColor redColor]];
    }
    else {
        [_wordsLbl setTextColor:[UIColor whiteColor]];
    }
    [_wordsLbl setText:[NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length, kMaxWords]];
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
     /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height time:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification {    
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
    */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
//    [self autoMovekeyBoard:0 time:animationDuration];
}

- (void)autoMovekeyBoard:(float)h time:(NSTimeInterval)time{
    DLog(@"%f", h);
    int hh = 0;
    
    _textView.height = __MainScreen_Height - 44 - 15 - h - hh;
    _wordsLbl.top = __MainScreen_Height - 44 - 28 - h - hh;
}

- (void)postFeedBack {
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:_textView.text forKey:@"content"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/feedback/add", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            _textView.text = @"";
            [self backAction];
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

@end

//
//  GeXingQianMing.m
//  XMU
//
//  Created by lihj on 13-7-10.
//  Copyright (c) 2013年 林小果. All rights reserved.
//

#import "CustomTextViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomTextViewController ()

@end

static int rightBtnIndex = 0;

@implementation CustomTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)backAction {
    if (_textView.text.length && _needContent) {
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
    [self setLbtnNormal];
    [self setRBtn:nil image:@"nav_OK" imageSel:nil target:self action:@selector(rightClick)];
    rightBtnIndex = 0;
    if (_needEmoji) {
//        NSRange r;
//        r.location = 0;
//        r.length = 0;
//        
//        _textView.selectedRange = r;
//
//        _emojiScrollView.delegate = self;
//        [_emojiScrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
//        for (int i=0; i<6; i++) {
//            FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(15+320*i, 12, facialViewWidth, facialViewHeight)];
//            [fview setBackgroundColor:[UIColor clearColor]];
//            [fview loadFacialView:i size:CGSizeMake(42, 46)];
//            fview.delegate=self;
//            [_emojiScrollView addSubview:fview];
//        }
//        [_pageControl setCurrentPage:0];
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
//            _pageControl.pageIndicatorTintColor=kRGBACOLOR(195, 179, 163, 1);
//            _pageControl.currentPageIndicatorTintColor=kRGBACOLOR(132, 104, 77, 1);
//        }
//        _pageControl.numberOfPages = 6;//指定页面个数
//        [_pageControl setBackgroundColor:[UIColor clearColor]];
//        [_emojiScrollView setContentSize:CGSizeMake(320*6, 216)];
    }
    else {
        _toolBarView.hidden = YES;
    }

    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
//    if (_text.length == 0) {
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    }
    
    if (_text) {
        [_textView setText:_text];
    }
    _textView.layer.cornerRadius = 6;
	_textView.layer.masksToBounds = YES;
    if (_keyboardType == 1) {
        _textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (_keyboardType == 2) {
        _textView.keyboardType = UIKeyboardTypeEmailAddress;
    }
    [_textView becomeFirstResponder];
    
    if (_maxWords > 0) {
        [_wordsLbl setText:[NSString stringWithFormat:@"0/%d", _maxWords]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    _textView = nil;
    _wordsLbl = nil;
    _toolBarView = nil;
    _emojiScrollView = nil;
    _pageControl = nil;
    [super viewDidUnload];
}

- (void)rightClick {
    if (_textView.text.length > _maxWords && _maxWords) {
        [shareFun showAlert:@"字数超过最大字数了！"];
        return;
    }
    if ([self.title isEqualToString:@"邮件"]) {
        if (![shareFun isValidateEmail:_textView.text]) {
            [shareFun showAlert:@"请输入正确的邮件地址"];
            return;
        }
    }
    if (_needContent) {
        if (_textView.text.length < 1) {
            [shareFun showAlert:@"您还没有输入"];
            return;
        }
    }
    if (rightBtnIndex == 0) {
        if (self.block) {
            self.block(_textView.text);
        }
        [super backAction];
    }
    rightBtnIndex ++;
}

- (void) setText:(NSString *)text
{
    _text = text;
    
    if (_maxWords > 0) {
        [_wordsLbl setText:[NSString stringWithFormat:@"0/%d", _maxWords]];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > _maxWords) {
        [_wordsLbl setTextColor:[UIColor redColor]];
    }
    else {
        [_wordsLbl setTextColor:[UIColor whiteColor]];
    }
    [_wordsLbl setText:[NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length, _maxWords]];
    
//    if (textView.text.length > 0) {
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }
//    else
//        self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark -
#pragma mark UISCROLLVIEW delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _emojiScrollView) {
        int page = _emojiScrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
        _pageControl.currentPage = page;//pagecontroll响应值的变化
    }
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
    int hh = _needEmoji == YES ? 40 : 0;
    
    _textView.height = __MainScreen_Height - 44 - 15 - h - hh;
    _wordsLbl.top = __MainScreen_Height - 44 - 28 - h - hh;

    [UIView animateWithDuration:time animations:^{
        if (_selectEmoji == NO) {
            if (h == 0) {
                _toolBarView.top = __MainScreen_Height-44-40;
            }
            else {
                _toolBarView.top = __MainScreen_Height-44-40-h;
            }
        }
        else {
            _toolBarView.top = __MainScreen_Height-44-40-216;
        }
    }completion:^(BOOL finished) {
        
    }];
}

- (IBAction)addEmojiBtnClick:(id)sender {
    if (_textView.isFirstResponder) {
        _selectEmoji = YES;
        [_textView resignFirstResponder];
    }
    else {
        if (_toolBarView.frame.origin.y == __MainScreen_Height-44-40) {
            [self autoMovekeyBoard:216 time:0.3f];
        }
        else {
            _selectEmoji = NO;
            [_textView becomeFirstResponder];
        }
    }
}

//- (void)selectedFacialView:(NSString*)str {
//    if ([str isEqualToString:@"删除"]) {
//        if (_textView.text.length > 0 && _textView.selectedRange.location > 0) {
//            NSRange r = _textView.selectedRange;
//            r.location = _textView.selectedRange.location - 2 < 0 ? 0 : _textView.selectedRange.location - 2;
//            r.length = 2;
//            
//            NSMutableString *t_str = [NSMutableString stringWithString:_textView.text];
//            
//            if ([[Emoji allEmoji] containsObject:[_textView.text substringWithRange:r]]) {
//                [t_str deleteCharactersInRange:r];
//            }
//            else{
//                r.location = _textView.selectedRange.location - 1 < 0 ? 0 : _textView.selectedRange.location - 1;
//                r.length = 1;
//                
//                [t_str deleteCharactersInRange:r];
//            }
//            _textView.text=t_str;
//            [_textView setSelectedRange:r];
//        }
//    }
//    else{
//        NSRange r;
//        r.location = _textView.selectedRange.location+1;
//        r.length = _textView.selectedRange.length;
//        
//        NSMutableString *t_str = [NSMutableString stringWithString:_textView.text];
//        DLog(@"%@",t_str);
//        [t_str insertString:str atIndex:_textView.selectedRange.location];
//        
//        [_textView setText:t_str];
//        [_textView setSelectedRange:r];
//    }
//    [self textViewDidChange:_textView];
//}

@end

//
//  GeXingQianMing.h
//  XMU
//
//  Created by lihj on 13-7-10.
//  Copyright (c) 2014年 Lihj. All rights reserved.
//

#import "BaseViewController.h"
//#import "FacialView.h"

#define facialViewWidth 300
#define facialViewHeight 170

typedef void (^textViewBlock)(NSString *text);

@interface CustomTextViewController : BaseViewController <UIScrollViewDelegate>{
    
    IBOutlet UITextView *_textView;
    IBOutlet UILabel *_wordsLbl;
    
    IBOutlet UIView *_toolBarView;
    BOOL _selectEmoji;
    IBOutlet UIScrollView *_emojiScrollView;
    IBOutlet UIPageControl *_pageControl;
}

@property (copy)textViewBlock block;            //保存时textView内容的block

@property (nonatomic, copy)NSString *text;
@property (nonatomic, assign)int maxWords;      //最大字数
@property (nonatomic, assign)int keyboardType;  //1-数字 2-email
@property (nonatomic, assign)BOOL needEmoji;    //default NO
@property (nonatomic, assign)BOOL needContent;    //default NO


- (IBAction)addEmojiBtnClick:(id)sender;

@end

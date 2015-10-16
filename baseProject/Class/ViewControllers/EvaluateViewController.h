//
//  EvaluateViewController.h
//  baseProject
//
//  Created by Li on 15/2/6.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"
#import "RatingBar.h"

typedef void (^EvaluateViewControllerBlock) ();

@interface EvaluateViewController : BaseViewController<UITextViewDelegate> {
    
    IBOutlet RatingBar *_star0;
    IBOutlet RatingBar *_star1;
    IBOutlet RatingBar *_star2;
    IBOutlet RatingBar *_star3;
    IBOutlet RatingBar *_star4;
    
    IBOutlet UIImageView *_imgVIew;
    IBOutlet UILabel *_nameLbl;
    IBOutlet UILabel *_priceLbl;
    __weak IBOutlet UITextView *_messageTextView;
    __weak UILabel* _messagePlaceHolder;
}

@property (copy) EvaluateViewControllerBlock block;
@property (nonatomic, copy) NSDictionary *dataDic;
@property (nonatomic, assign) int row;

@end

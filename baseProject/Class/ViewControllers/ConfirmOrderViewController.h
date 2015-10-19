//
//  ConfirmOrderViewController.h
//  baseProject
//
//  Created by Li on 15/3/19.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "BMapKit.h"
#import "SZTextView.h"

@interface ConfirmOrderViewController : BaseViewController <BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;

    IBOutlet TPKeyboardAvoidingScrollView *_scrollView;
    IBOutlet SZTextView *_textView;
    IBOutlet UIView *_timePopView;
    IBOutlet UIDatePicker *_datePicker;
    IBOutlet UIView *_couponPopView;
    IBOutlet UIButton *_orderBtn;
}

@property (strong, nonatomic) IBOutlet UILabel *tipLbl;
@property (strong, nonatomic) IBOutlet UITableView *tableView0;
@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (strong, nonatomic) IBOutlet UITableView *popTableView;

@property (nonatomic, copy) NSMutableDictionary *numDic;
@property (nonatomic, copy) NSDictionary *defaultAddressDictionary;
//是否从礼品兑换进入
@property (nonatomic, assign) BOOL gift;

//是否从套餐那进入
@property (nonatomic, assign) BOOL taoCan;

@end

//
//  baseViewController.h
//  tempPrj
//
//  Created by lihj on 13-4-9.
//  Copyright (c) 2013年 lihj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPageSize 20

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL ifNavBarHide;

@property (nonatomic, strong) CWRefreshTableView *refreshTableView;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int pageTotal;

@property (nonatomic, copy) NSMutableArray *dataSource;

- (NSMutableDictionary *)creatRequestDic;

- (void)setLbtnNormal;
- (void)setLBtn:(NSString *)t_str image:(NSString *)t_img imageSel:(NSString *)t_imgSel target:(id)target action:(SEL)action;
- (void)setRBtn:(NSString *)t_str image:(NSString *)t_img imageSel:(NSString *)t_imgSel target:(id)target action:(SEL)action;
- (void)setLBtnHidden:(BOOL)hidden;
- (void)backAction;

@end

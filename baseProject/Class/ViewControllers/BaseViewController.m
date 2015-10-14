//
//  baseViewController.m
//  tempPrj
//
//  Created by lihj on 13-4-9.
//  Copyright (c) 2013年 lihj. All rights reserved.
//

#import "BaseViewController.h"
#import "PublicInstance.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if (kIOS7OrLater) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
            
            
//            [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                     forBarMetrics:UIBarMetricsDefault];
//            self.navigationController.navigationBar.shadowImage = [UIImage new];
//            self.navigationController.navigationBar.translucent = YES;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:kRGBCOLOR(246, 246, 246)];
    
    if (!_ifNavBarHide) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    _page = 1;
    _pageSize = kPageSize;
    
//    if (self.navigationController.viewControllers.count > 1) {
//        [self setLbtnNormal];
//    }
    
//    if ([self.navigationController.viewControllers count] > 1 && ![shareFun isNetWorkReachable]) {
//        self.view.hidden = YES;
//        return;
//    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    NSLog(@"***********************%@ dealloc**********************", NSStringFromClass([self class]));
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)setLBtnHidden:(BOOL)hidden {
    self.navigationItem.hidesBackButton = YES;
}

- (NSMutableDictionary *)creatRequestDic {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    return dic;
}

- (void)setLbtnNormal {
    UIImage *image = [UIImage imageNamed:@"nav_back.png"];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    if (kIOS7OrLater) {
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
    else {
        UIBarButtonItem *fixedSpaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpaceButtonItem.width = 10;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:fixedSpaceButtonItem, leftButtonItem, nil] animated:NO];
    }
}

- (void)setLBtn:(NSString *)t_str image:(NSString *)t_img imageSel:(NSString *)t_imgSel target:(id)target action:(SEL)action {
    UIImage *image;
    if (t_img) {
        image = [UIImage imageNamed:t_img];
    }
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    if (!image) {
        leftButton.frame = CGRectMake(0, 0, 44, 44);
        [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    [leftButton setTitle:t_str forState:UIControlStateNormal];
    if (image) {
        [leftButton setImage:[UIImage imageNamed:t_img] forState:UIControlStateNormal];
        if (t_imgSel) {
            [leftButton setImage:[UIImage imageNamed:t_imgSel] forState:UIControlStateHighlighted];
        }
    }
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    if (kIOS7OrLater) {
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
    else {
        UIBarButtonItem *fixedSpaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpaceButtonItem.width = 10;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:fixedSpaceButtonItem, leftButtonItem, nil] animated:NO];
    }
}

- (void)setRBtn:(NSString *)t_str image:(NSString *)t_img imageSel:(NSString *)t_imgSel target:(id)target action:(SEL)action {
    UIImage *image;
    if (t_img) {
        image = [UIImage imageNamed:t_img];
    }
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    if (!image) {
        rightButton.frame = CGRectMake(0, 0, 60, 44);
        [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    [rightButton setTitle:t_str forState:UIControlStateNormal];
    if (image) {
        [rightButton setImage:image forState:UIControlStateNormal];
        if (t_imgSel) {
            [rightButton setImage:[UIImage imageNamed:t_imgSel] forState:UIControlStateHighlighted];
        }
    }
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightButton.titleLabel setTextColor:[UIColor whiteColor]];
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    if (kIOS7OrLater) {
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    else {
        UIBarButtonItem *fixedSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpaceButtonItem.width = 10;
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:fixedSpaceButtonItem, rightButtonItem, nil] animated:NO];
    }
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end

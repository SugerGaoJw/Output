//
//  MeshDetailViewController.m
//  baseProject
//
//  Created by Li on 15/1/13.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MeshDetailViewController.h"

@interface MeshDetailViewController ()

@end

@implementation MeshDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"网点详情";
    
    _nameLbl.text = [_dataDic objectForKey:@"name"];
    _addrLbl.text = [_dataDic objectForKey:@"address"];
    _telLbl.text = [_dataDic objectForKey:@"phone"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)telBtnClick:(id)sender {
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", [_dataDic objectForKey:@"phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end

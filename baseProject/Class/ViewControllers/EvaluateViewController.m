//
//  EvaluateViewController.m
//  baseProject
//
//  Created by Li on 15/2/6.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "EvaluateViewController.h"
#import "RatingBar.h"
#import "NSObject+HXAddtions.h"

@interface EvaluateViewController ()

@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"评价";

    [_imgVIew sd_setImageWithURL:[[[_dataDic objectForKey:@"orderItem"] objectAtIndex:_row] objectForKey:@"imgUrl"] placeholderImage:nil];
    _nameLbl.text = [[[_dataDic objectForKey:@"orderItem"] objectAtIndex:_row] objectForKey:@"foodsName"];
    _priceLbl.text = [NSString stringWithFormat:@"￥%@", [[[_dataDic objectForKey:@"orderItem"] objectAtIndex:_row] objectForKey:@"price"]];
    
    [self getData];
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

- (IBAction)postBtnClick:(id)sender {
    if (_star0.starNumber == 0 || _star1.starNumber == 0 || _star2.starNumber == 0 || _star3.starNumber == 0 || _star4.starNumber == 0) {
        [SVProgressHUD showErrorWithStatus:@"请对所有评价项进行评分"];
        return;
    }
    else {
        [self postData];
    }
}

- (void)getData {
    
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:[[[_dataDic objectForKey:@"orderItem"] objectAtIndex:_row] objectForKey:@"fkFsId"] forKey:@"foodsId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/order/get-comment-field", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            NSArray *rows = [tDic objectForKey:@"rows"];
            [self.dataSource addObjectsFromArray:rows];
            
            for (int i=0; i<rows.count; i++) {
                NSDictionary *dic = [rows objectAtIndex:i];
                UILabel *lbl = (UILabel *)[self.view viewWithTag:10+i];
                lbl.text = [dic objectForKey:@"fieldName"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (void)postData {
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:[[[_dataDic objectForKey:@"orderItem"] objectAtIndex:_row] objectForKey:@"pkId"] forKey:@"orderItemId"];
    [dic setObject:[_dataDic objectForKey:@"pkId"] forKey:@"orderNumber"];
    
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableDictionary *dic0 = [NSMutableDictionary dictionary];
    [dic0 setObject:[NSString stringWithFormat:@"%ld", (long)_star0.starNumber] forKey:@"score"];
    [dic0 setObject:[[self.dataSource objectAtIndex:0] objectForKey:@"fkSfId"] forKey:@"fkSfId"];
    [arr addObject:dic0];
    
    dic0 = [NSMutableDictionary dictionary];
    [dic0 setObject:[NSString stringWithFormat:@"%ld", (long)_star1.starNumber] forKey:@"score"];
    [dic0 setObject:[[self.dataSource objectAtIndex:1] objectForKey:@"fkSfId"] forKey:@"fkSfId"];
    [arr addObject:dic0];
    
    dic0 = [NSMutableDictionary dictionary];
    [dic0 setObject:[NSString stringWithFormat:@"%ld", (long)_star2.starNumber] forKey:@"score"];
    [dic0 setObject:[[self.dataSource objectAtIndex:2] objectForKey:@"fkSfId"] forKey:@"fkSfId"];
    [arr addObject:dic0];
    
    dic0 = [NSMutableDictionary dictionary];
    [dic0 setObject:[NSString stringWithFormat:@"%ld", (long)_star3.starNumber] forKey:@"score"];
    [dic0 setObject:[[self.dataSource objectAtIndex:3] objectForKey:@"fkSfId"] forKey:@"fkSfId"];
    [arr addObject:dic0];
    
    dic0 = [NSMutableDictionary dictionary];
    [dic0 setObject:[NSString stringWithFormat:@"%ld", (long)_star4.starNumber] forKey:@"score"];
    [dic0 setObject:[[self.dataSource objectAtIndex:4] objectForKey:@"fkSfId"] forKey:@"fkSfId"];
    [arr addObject:dic0];
    
    [dic setObject:arr forKey:@"fields"];
    
    NSString *json = [NSString jsonStringWithDictionary:dic];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/order/comment", kSERVE_URL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:data];
    [request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              // 成功后的处理
                                              DLog(@"JSON: %@", responseObject);
                                              NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
                                              if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
                                                  [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
                                              }
                                              else {
                                                  if (self.block) {
                                                      self.block();
                                                  }
                                                  [self backAction];
                                                  [SVProgressHUD showSuccessWithStatus:@"评价成功"];
                                              }
                                          }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              // 失败后的处理
                                              [SVProgressHUD showErrorWithStatus:@"评价失败"];
                                          }];
    [manager.operationQueue addOperation:operation];
}


@end

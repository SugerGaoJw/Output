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
#import "IQKeyBoardManager.h"

@interface EvaluateViewController () {
    NSArray* _stars;
    NSArray* _sels;
}
@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"评价";

    [_imgVIew sd_setImageWithURL:[[[_dataDic objectForKey:@"orderItem"] objectAtIndex:_row] objectForKey:@"imgUrl"] placeholderImage:nil];
    _nameLbl.text = [[[_dataDic objectForKey:@"orderItem"] objectAtIndex:_row] objectForKey:@"foodsName"];
    _priceLbl.text = [NSString stringWithFormat:@"￥%@", [[[_dataDic objectForKey:@"orderItem"] objectAtIndex:_row] objectForKey:@"price"]];
    [confirm setEnabled:NO];
    
//    [self getData];
    [self configEvalueateStart];
    [self configMessageView];
    [IQKeyBoardManager installKeyboardManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IQKeyBoardManager disableKeyboardManager];
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

#pragma mark -- Evalueate Start 
- (void)configEvalueateStart {
    
    _star0 = [[RatingBar alloc]initWithFrame:CGRectMake(126, 104, 160, 33)];
    _star1 = [[RatingBar alloc]initWithFrame:CGRectMake(126, 154, 160, 33)];
    _star2 = [[RatingBar alloc]initWithFrame:CGRectMake(126, 204, 160, 33)];
    _star3 = [[RatingBar alloc]initWithFrame:CGRectMake(126, 254, 160, 33)];
    
    _stars = @[ _star0, _star1,  _star2, _star3 ];
    _sels  = @[ _sel0 ,  _sel1,   _sel2,  _sel3 ];
    
    NSArray* titls = @[@"服务相当周到",@"服务还不错",@"服务一般",@"服务很差"];
    NSArray* nums = @[@"5",@"4",@"3",@"1"];
    
    for (int i = 0 ; i < 4; i ++) {
        UILabel *lbl = (UILabel *)[self.view viewWithTag:10+i];
        lbl.text = titls[i];
        RatingBar* star = _stars[i];
        star.starNumber = [nums[i] integerValue];
        star.sel = _sels[i];
        [self.view addSubview:star];
    }
}

- (IBAction)calbakRatingBarBySel:(UIButton *)sender {
    
    [confirm setEnabled:YES];
    RatingBar* star = [_stars objectAtIndex:sender.tag];
    [star.sel setSelected:YES];
    for (int i = 0 ; i < 4 ; i ++ ) {
        if (_sels[i] == star.sel) {
            continue;
        }
        [_sels[i] setSelected:NO];
    }
}

#pragma mark -- Message TextView
- (void)configMessageView {
    //textView placeHolder 其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
    CGRect rect =  CGRectMake(17, 8, _messageTextView.size.width , 20);
    UILabel* label = [[UILabel alloc]initWithFrame:rect];
    label.text = @"请为本次服务作出评价 ^_^";
    label.enabled = NO;//lable必须设置为不可用
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    [_messageTextView addSubview:label];
    _messagePlaceHolder = label;
    //圆角
    _messageTextView.backgroundColor = [UIColor whiteColor];
    _messageTextView.layer.borderWidth = 1.f;
    _messageTextView.layer.borderColor = [UIColor lightTextColor].CGColor;
    _messageTextView.layer.cornerRadius = 5.f;
    _messageTextView.layer.masksToBounds = YES;
    
    //iphone4s
    if (__MainScreen_Height <= 640) {
        CGRect orgianlRect = _messageTextView.frame;
        CGRect newRect = CGRectMake(orgianlRect.origin.x, orgianlRect.origin.y, CGRectGetWidth(orgianlRect), CGRectGetHeight(orgianlRect) - 10.f);
        _messageTextView.frame = newRect;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
   
    //键盘 return 事件响应
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    //字数限制 待完善
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = 60 -[new length];
    if(res >= 0){
        return YES;
    }
    else{
        
//        NSRange rg = {0,[text length]+res};
//        if (rg.length>0) {
//            NSString *s = [text substringWithRange:rg];
//            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
//        }
        return NO;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    //placeHolder 实现
    if (textView.text.length == 0) {
        _messagePlaceHolder.text = @"请为本次服务作出评价 ^_^";
    }else{
        _messagePlaceHolder.text = @"";
    }
    
    NSInteger MaxNumberOfDescriptionChars = 60;
    NSString *toBeString = textView.text;
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [textView markedTextRange];
        
        //获取高亮部分
        
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        
        if (!position) {
            
            if (toBeString.length > MaxNumberOfDescriptionChars) {
                
                textView.text = [toBeString substringToIndex:MaxNumberOfDescriptionChars];
                
                
            }else{
//                self.lblFontNum.text = [NSString stringWithFormat:@"剩余%ld字",(long)(MaxNumberOfDescriptionChars -textView.text.length)];
                
            }
            
        }
        
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        
        else{
            
            
            
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (toBeString.length > MaxNumberOfDescriptionChars) {
            
            textView.text = [toBeString substringToIndex:MaxNumberOfDescriptionChars];
            
        }else{
//            self.lblFontNum.text = [NSString stringWithFormat:@"剩余%ld字",(long)(MaxNumberOfDescriptionChars -textView.text.length)];
        }
        
    }

}





@end

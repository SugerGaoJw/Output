//
//  NewAddrViewController.m
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "NewAddrViewController.h"
#import "NewAreaViewController.h"

@interface NewAddrViewController () {
    NSString *_areaId;
    NSString *_roadId;
}

@end

@implementation NewAddrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"新增";
    [self setRBtn:@"保存" image:nil imageSel:nil target:self action:@selector(rightBtnClick)];

    _areaBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaSelcet:) name:@"areaSelcet" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roadSelcet:) name:@"roadSelcet" object:nil];
    
    if (_update) {
        _nameTextField.text = [_dataDic objectForKey:@"name"];
        _mobileTextField.text = [_dataDic objectForKey:@"phone"];
        _addrTextField.text = [_dataDic objectForKey:@"address"];
        if ([[_dataDic objectForKey:@"isDefault"] intValue] == 1) {
            _checkBoxBtn.selected = YES;
        }
        NSString *allAddress = [_dataDic objectForKey:@"allAddress"];
        NSArray *arr = [allAddress componentsSeparatedByString:@" "];
        if (arr.count >= 4) {
            [_areaBtn setTitle:[NSString stringWithFormat:@"%@%@%@", [arr objectAtIndex:0], [arr objectAtIndex:1] , [arr objectAtIndex:2]] forState:UIControlStateNormal];
            [_roadBtn setTitle:[arr objectAtIndex:3] forState:UIControlStateNormal];
        }
        NSString *addressIds = [_dataDic objectForKey:@"addressIds"];
        NSArray *idsArr = [addressIds componentsSeparatedByString:@" "];
        if (idsArr.count >= 4) {
            _areaId = [idsArr objectAtIndex:2];
            _roadId = [idsArr objectAtIndex:3];
        }
    }
    if (_locateAreaId) {
        _areaId = _locateAreaId;
        [_areaBtn setTitle:_locateName forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnClick {
    [self.view endEditing:YES];
    if (_nameTextField.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系人"];
        return;
    }
    if (_mobileTextField.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (_areaId.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请选择所在地区"];
        return;
    }
    if (_roadId.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请选择所在街道"];
        return;
    }
    if (_addrTextField.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入详细地址"];
        return;
    }
    [self postData];
}

- (void)areaSelcet:(NSNotification *)notify {
    NSDictionary *userInfo = [notify userInfo];
    DLog(@"%@", userInfo);
    
    [_areaBtn setTitle:[userInfo objectForKey:@"parentName"] forState:UIControlStateNormal];
    _areaId = [[userInfo objectForKey:@"pkId"] stringValue];
}

- (void)roadSelcet:(NSNotification *)notify {
    NSDictionary *userInfo = [notify userInfo];
    DLog(@"%@", userInfo);
    
    [_roadBtn setTitle:[userInfo objectForKey:@"name"] forState:UIControlStateNormal];
    _roadId = [[userInfo objectForKey:@"pkId"] stringValue];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)checkBoxClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)areaBtnClick:(id)sender {
    [self.view endEditing:YES];
    NewAreaViewController *vc = [[NewAreaViewController alloc] initWithNibName:@"NewAreaViewController" bundle:nil];
    vc.parentId = @"1";
    vc.parentName = @"";
    vc.title = @"选择省份";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)roadBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (_areaId.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请选择地区"];
        return;
    }
    NewAreaViewController *vc = [[NewAreaViewController alloc] initWithNibName:@"NewAreaViewController" bundle:nil];
    vc.parentId = _areaId;
    vc.parentName = @"";
    vc.title = @"选择街道";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)postData {
    NSMutableDictionary *dic1 = [self creatRequestDic];
    [dic1 setObject:_addrTextField.text forKey:@"address"];
    if (_checkBoxBtn.selected) {
        [dic1 setObject:@"1" forKey:@"isDefault"];
    }
    else {
        [dic1 setObject:@"0" forKey:@"isDefault"];
    }
    [dic1 setObject:_nameTextField.text forKey:@"name"];
    [dic1 setObject:_mobileTextField.text forKey:@"phone"];
    [dic1 setObject:_roadId forKey:@"streeId"];
    
    NSString *url;
    if (_update) {
        [dic1 setObject:[_dataDic objectForKey:@"pkId"] forKey:@"id"];
        url = @"/member/delivery/update";
    }
    else {
        url = @"/member/delivery/add";
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@", kSERVE_URL, url] parameters:dic1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];

}

@end

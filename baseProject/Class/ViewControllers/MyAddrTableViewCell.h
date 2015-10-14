//
//  MyAddrTableViewCell.h
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAddrTableViewCell : UITableViewCell {
    
    IBOutlet UILabel *_nameLbl;
    IBOutlet UILabel *_addrLbl;
}

@property (nonatomic, copy) NSDictionary *dataDic;

@end

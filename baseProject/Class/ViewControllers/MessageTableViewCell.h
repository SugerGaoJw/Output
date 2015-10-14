//
//  MessageTableViewCell.h
//  baseProject
//
//  Created by Li on 15/1/13.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell {
    
    IBOutlet UILabel *_titleLbl;
    IBOutlet UILabel *_decLbl;
}

@property (nonatomic, copy) NSDictionary *dataDic;

@end

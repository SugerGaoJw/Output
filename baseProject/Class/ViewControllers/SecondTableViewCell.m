//
//  SecondTableViewCell.m
//  baseProject
//
//  Created by Li on 15/2/5.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "SecondTableViewCell.h"

@implementation SecondTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    NSArray *orderItem = [dataDic objectForKey:@"orderItem"];
    if (orderItem.count) {
        NSDictionary *orderItemDic = [orderItem objectAtIndex:0];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[orderItemDic objectForKey:@"imgUrl"]] placeholderImage:nil];
    }
    NSMutableArray *name = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in orderItem) {
        [name addObject:[dic objectForKey:@"foodsName"]];
    }
    _nameLbl.text = [name componentsJoinedByString:@" "];
    _timeLbl.text = [dataDic objectForKey:@"createTime"];
    _stateLbl.text = [NSString stringWithFormat:@"%@/%@", [dataDic objectForKey:@"status"], [dataDic objectForKey:@"payChannel"]];
    _priceLbl.text = [NSString stringWithFormat:@"￥%@", [dataDic objectForKey:@"preferentialPrice"]];
    _addrLbl.text = [NSString stringWithFormat:@"%@ %@", [[dataDic objectForKey:@"deliveryInfo"] objectForKey:@"consignee"], [[dataDic objectForKey:@"deliveryInfo"] objectForKey:@"address"]];
    
    NSString *status = [dataDic objectForKey:@"status"];
    
    _cancelBtn.enabled = YES;
    _cancelBtn.left = 164;
    [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];

    if ([status isEqualToString:@"待派送"]) {
        _cancelBtn.hidden = NO;
        _cancelBtn.left = 242;
        _payBtn.hidden = YES;

        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* startDate     = [dateFormatter dateFromString:[dataDic objectForKey:@"createTime"]];
        NSDate* toDate    = [ [ NSDate alloc] init];
        NSTimeInterval time = [toDate timeIntervalSinceDate:startDate];
        if (time > 1200.0f) {
            _tipLbl.text = @"订单等待派送中";
            _cancelBtn.enabled = NO;
        }
        else {
            _tipLbl.text = @"下单20分钟内可取消订单";
        }
    }
    else if ([status isEqualToString:@"待付款"]) {
        _tipLbl.text = @"请在24小时之内支付或取消订单";
        _cancelBtn.hidden = NO;
        _payBtn.hidden = NO;
    }
    else if ([status isEqualToString:@"派送中"]) {
        _tipLbl.text = @"订单派送中";
        _cancelBtn.hidden = YES;
        _payBtn.hidden = YES;
    }
    else if ([status isEqualToString:@"订单成功"]) {
        _tipLbl.text = @"订单成功";
        _payBtn.hidden = YES;
        _cancelBtn.left = 242;
        _cancelBtn.hidden = NO;
        [_cancelBtn setTitle:@"重新下单" forState:UIControlStateNormal];
    }
    else if ([status isEqualToString:@"订单关闭"]) {
        _tipLbl.text = @"订单关闭";
        _payBtn.hidden = YES;
        _cancelBtn.left = 242;
        _cancelBtn.hidden = NO;
        [_cancelBtn setTitle:@"重新下单" forState:UIControlStateNormal];
    }
    else if ([status isEqualToString:@"已退款"]) {
        _tipLbl.text = @"已退款";
        _payBtn.hidden = YES;
        _cancelBtn.left = 242;
        _cancelBtn.hidden = NO;
        [_cancelBtn setTitle:@"重新下单" forState:UIControlStateNormal];
    }
    else if ([status isEqualToString:@"退款中"]) {
        _tipLbl.text = @"订单退款中";
        _payBtn.hidden = YES;
        _cancelBtn.hidden = YES;
    }
}

@end

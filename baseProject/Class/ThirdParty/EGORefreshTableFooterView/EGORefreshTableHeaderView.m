//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#define  RefreshViewHight 65.0f

#import "EGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor darkGrayColor]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void) initControl;
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;
@synthesize direction = _direction;

- (id)initWithFrame:(CGRect)frame byDirection:(EGOPullRefreshDirection) direc
{	
    if ((self = [super initWithFrame:frame])) {		
        _direction = direc;		        		
        [self initControl:frame];
    }
    return self;	
}

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		[self initControl:frame];			
    }
	
    return self;
}

- (id)initWithFrame:(CGRect)frame {	
    self = [super initWithFrame:frame];
    if (self) {		
        _direction = EGOOPullRefreshDown; //默认下拉刷新		        		
		[self initControl:frame];		
    }	
    return self;	
}

- (void) initControl:(CGRect)frame
{
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.backgroundColor = [UIColor clearColor];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.font = [UIFont systemFontOfSize:12.0f];
	label.textColor = TEXT_COLOR;
//	label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//	label.shadowOffset = CGSizeMake(0.0f, 1.0f);
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = NSTextAlignmentCenter;
	[self addSubview:label];
	_lastUpdatedLabel=label;
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.font = [UIFont boldSystemFontOfSize:13.0f];
	label.textColor = TEXT_COLOR;
//	label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//	label.shadowOffset = CGSizeMake(0.0f, 1.0f);
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = NSTextAlignmentCenter;
	[self addSubview:label];
	_statusLabel=label;
	
	CALayer *layer = [CALayer layer];
	layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
	layer.contentsGravity = kCAGravityResizeAspect;
	layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		layer.contentsScale = [[UIScreen mainScreen] scale];
	}
#endif
	
	[[self layer] addSublayer:layer];
	_arrowImage=layer;
	
	UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
	[self addSubview:view];
	_activityView = view;
	
	[self setState:EGOOPullRefreshNormal];
}

#pragma mark -
#pragma mark Setters
- (void)setStatusText:(NSString *) aText{
	_statusLabel.text = aText;
    _activityView.hidden = YES;
}

- (void)doDownRefreshLoading:(UIScrollView *) tView{
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
    [UIImage imageNamed:@""];
	if (!_loading) {
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:3];
		tView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];	
		
		[tView setContentOffset:CGPointMake(0, -60)];

		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:direction:)]) {					
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self direction:_direction];					
		}		
	}	
}

- (void)refreshLastUpdatedDate {
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		_lastUpdatedLabel.text = nil;
	}
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"释放更新...", @"释放更新...");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
            switch (_direction) {					
                case EGOOPullRefreshUp:					
                    _statusLabel.text = NSLocalizedString(@"上拉即可更新...", @"上拉即可更新...");					
                    break;
                case EGOOPullRefreshDown:					
                    _statusLabel.text = NSLocalizedString(@"下拉刷新...", @"下拉刷新...");
                    break;
                default:
                    break;
            }			
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"加载中...", @"加载中...");
            _activityView.hidden = NO;
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	if (_direction == EGOOPullRefreshUpLoadMore){
		_statusLabel.text = NSLocalizedString(@"加载中...", @"加载中...");
	}
	_state = aState;
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {//更新中...
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
        switch (_direction) {
            case EGOOPullRefreshUp:
                scrollView.contentInset = UIEdgeInsetsMake(-60.0, 0.0f, 0.0f, 0.0f);				
                break;				
            case EGOOPullRefreshDown:				
                scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);				
                break;
            default:
                break;
        }		
	}
    else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		switch (_direction) {				
            case EGOOPullRefreshUp:				
                if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight && scrollView.contentOffset.y > 0.0f && !_loading) {					
                    [self setState:EGOOPullRefreshNormal];					
                }else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight  && !_loading) {					
                    [self setState:EGOOPullRefreshPulling];					
                }				
                break;	
			case EGOOPullRefreshUpLoadMore:
                if (scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight && scrollView.contentOffset.y > 10.0f && !_loading) {					
                    [self setState:EGOOPullRefreshLoading];
				}
                break;
            case EGOOPullRefreshDown:				
                if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {					
                    [self setState:EGOOPullRefreshNormal];					
                }else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {					
                    [self setState:EGOOPullRefreshPulling];					
                }				
                break;				
        }
		
		if (scrollView.contentInset.bottom != 0) {			
			scrollView.contentInset = UIEdgeInsetsZero;
		}		
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
    switch (_direction) {			
        case EGOOPullRefreshUp:			
            if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height  && !_loading) {
				[self setState:EGOOPullRefreshLoading];
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.2];
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
				[UIView commitAnimations];
                
                if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:direction:)]) {
                    [_delegate egoRefreshTableHeaderDidTriggerRefresh:self direction:_direction];					
                }                
            }			
            break;		
		case EGOOPullRefreshUpLoadMore:
            if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height - 60.0f && !_loading) {

				[self setState:EGOOPullRefreshLoading];
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.2];
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
				[UIView commitAnimations];
                
                if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:direction:)]) {
                    [_delegate egoRefreshTableHeaderDidTriggerRefresh:self direction:_direction];					
                }                
            }			
			break;
        case EGOOPullRefreshDown:
            if (scrollView.contentOffset.y <= - 65.0f && !_loading) {

				[self setState:EGOOPullRefreshLoading];
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.2];
                scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
				[UIView commitAnimations];
				
				if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:direction:)]) {					
                    [_delegate egoRefreshTableHeaderDidTriggerRefresh:self direction:_direction];					
                }                
            }			
            break;			
    }	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];   
    [UIView commitAnimations];
    switch (_direction) {
        case EGOOPullRefreshUpLoadMore:
            [self setState:EGOOPullRefreshLoading];
            break;
        case EGOOPullRefreshUp:	
        case EGOOPullRefreshDown:
            [self setState:EGOOPullRefreshNormal];
            break;
    }
}

@end

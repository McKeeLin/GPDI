//
//  UITipView.m
//  UnifiedC
//
//  Created by lipeng on 13-9-9.
//  Copyright (c) 2013年 liwei. All rights reserved.
//

#import "UITipView.h"
#import <QuartzCore/CALayer.h>
#define tipFont [UIFont systemFontOfSize:14]

#define UI_SHOW_TIP_TAG 20000

@interface UITipView()

/**
 *  关闭计时器
 */
@property (retain, nonatomic) NSTimer *theTimer;

@property UIView *view;

@end

@implementation UITipView{
    
    /**
        提示显示控件
     */
    UILabel *_tipLabel;
}
@synthesize theTimer,view;

+ (void)showTip:(NSString*)tip atView:(UIView*)view
{
    [UITipView showTip:tip withWaitTime:2.8 atView:view];
}

+ (void)showTip:(NSString*)tip delay:(NSTimeInterval)delayTime
{
    [UITipView showTip:tip delay:delayTime withWaitTime:2.8];
}

+ (void)showTip:(NSString*)tip withWaitTime:(NSInteger)waitTime atView:(UIView*)view
{
    if( !view ){
        return;
    }
    __block NSString *__tip = [tip copy];
    __block NSInteger __waitTime = waitTime;
    dispatch_async( dispatch_get_main_queue(), ^{
        
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        //保证某一时刻只显示1个提示框
        UITipView *tipView = (UITipView*)[view viewWithTag:UI_SHOW_TIP_TAG];
        if (tipView) {
            [tipView clear];
        }
        
        CGSize size = [tip sizeWithFont:tipFont constrainedToSize:CGSizeMake(160, 220)];
        
        
        CGRect rect = view.bounds;
        rect.origin.x = (rect.size.width - (size.width + 20))/2;
        rect.origin.y = (rect.size.height - (size.height+20))/2;
        rect.size.width = size.width+20;
        rect.size.height = size.height+20;
        
        
        tipView = [[[UITipView alloc] initWithFrame:rect] autorelease];
        tipView.tag = UI_SHOW_TIP_TAG;
        tipView.tipMessage = __tip;
        tipView.displayTime = __waitTime;//2.8;
        tipView.layer.cornerRadius = 8;
        tipView.layer.masksToBounds = YES;
        tipView.alpha = 0.0f;
        tipView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        
        [view addSubview:tipView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        tipView.alpha = 0.95f;
        tipView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [UIView commitAnimations];
        
        [__tip release];
    });
}

+ (void)showTip:(NSString*)tip delay:(NSTimeInterval)delayTime withWaitTime:(NSInteger)waitTime
{
    __block NSString *__tip = [tip copy];
    __block NSInteger __waitTime = waitTime;
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(delayTime);
        dispatch_async( dispatch_get_main_queue(), ^{

            [UITipView showTip:__tip withWaitTime:__waitTime];
            [__tip release];
        });
    });
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self createTipView];
    }
    return self;
}

- (UITipView*)initWithMessage:(NSString*)message displayTime:(NSInteger)sec
{
    self = [super init];
    if ( self ){
        self.tipMessage = message;
        self.displayTime = sec;
        
        [self createTipView];
    }
    return self;
}

- (void)dealloc
{
    self.theTimer = nil;
    self.tipMessage = nil;
    [super dealloc];
}

- (void)createTipView
{
    self.backgroundColor = [UIColor blackColor];
    UIFont *font = tipFont;
    _tipLabel = [[[UILabel alloc] initWithFrame:self.bounds] autorelease];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.numberOfLines = 0;
    [_tipLabel setFont:font];
    [_tipLabel setTextColor:[UIColor whiteColor]];
    _tipLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_tipLabel];

}

- (void)layoutSubviews
{
    CGRect rect = self.bounds;
    rect = CGRectOffset(rect, 10, 10);
    rect.size.width -= 20;
    rect.size.height -= 20;
    _tipLabel.frame = rect;
}

- (void)didMoveToSuperview
{
    [_tipLabel setText:self.tipMessage];
    self.theTimer = [NSTimer scheduledTimerWithTimeInterval:self.displayTime target:self selector:@selector(timer:) userInfo:nil repeats:NO];
}

- (void)timer:(NSTimer*)theTimer
{
    
    dispatch_async( dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^(){
            self.alpha = 0.0f;
            self.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }completion:^(BOOL finised){
            [self removeFromSuperview];
        }];
    });
    
}
- (void)clear
{
    [self.theTimer fire];
    self.theTimer = nil;
}

@end

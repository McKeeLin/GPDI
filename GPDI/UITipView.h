//
//  UITipView.h
//  UnifiedC
//
//  Created by liwei on 13-9-9.
//  Copyright (c) 2013年 CDC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
   提示信息显示类，一般会显示几秒钟 
 */
@interface UITipView : UIView

/**
    要显示的提示信息
 */
@property (retain, nonatomic) NSString *tipMessage;

/**
    显示时间，时间完成后显示视图自动消失
 */
@property (assign, nonatomic) NSInteger displayTime;

/**
    显示提示信息，默认显示等待时间2.8秒
    @param tip 要显示的提示信息
 */
+ (void)showTip:(NSString*)tip atView:(UIView*)view;

/**
    显示提示信息，默认显示等待时间2.8秒
    @param tip 要显示的提示信息
    @param delayTime 多长时间后显示
 */
+ (void)showTip:(NSString*)tip delay:(NSTimeInterval)delayTime;

/**
    显示提示信息
    @param tip 要显示的提示信息
    @param waitTime 提示显示时间
 */
+ (void)showTip:(NSString*)tip withWaitTime:(NSInteger)waitTime atView:(UIView*)view;

/**
 *  显示提示信息
 *
 *  @param tip       要显示的提示信息
 *  @param delayTime 多长时间后显示
 *  @param waitTime  提示显示时间
 */
+ (void)showTip:(NSString*)tip delay:(NSTimeInterval)delayTime withWaitTime:(NSInteger)waitTime;
@end

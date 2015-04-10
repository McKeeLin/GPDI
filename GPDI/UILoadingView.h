//
//  UILoadingView.h
//  CloudContacts
//
//  Created by liwei on 13-9-23.
//  Copyright (c) 2013年 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
	等待加载视图结束码定义
 */
typedef enum{
	kLoadingView_Finised = 0, /**< 正常结束 */
	kLoadingView_Canceled = 1 /**< 被用户取消 */
}LoadingViewCode;


@protocol UILoadingViewDelegate;

/**
	加载等待视图
    主要用于等待异步操作返回显示等待界面
 */
@interface UILoadingView : UIView

/**
	提示内容
 */
@property (retain, nonatomic) NSString *message;
@property (assign, nonatomic) id<UILoadingViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame canClose:(BOOL)canClose;


/**
	显示等待加载视图
	@param tipString 要显示的提示文本
    @param delegate  回调委托对象
	@returns 等待视图对象
 */
+ (UILoadingView*)waitWithTipMessage:(NSString*)tipString delegate:(id<UILoadingViewDelegate>)delegate;

+ (UILoadingView*)waitWithTipMessage:(NSString*)tipString forView:(UIView*)view canClose:(BOOL)canClose;

+ (UILoadingView*)waitWithTipMessage:(NSString*)tipString completion:(void (^)(NSInteger))completion;

/**
	结束等待
	@param code 回调编码
 */
- (void)endWaitWithCode:(LoadingViewCode)code;

/**
	显示等待视图
 */
- (void)show:(UIView *)view;

/**
	以模式方式显示，显示后不会继续运行后面的语句，直接结束显示
 */
- (void)showModal;


@end


/**
    等待加载视图回调协议定义
 */
@protocol UILoadingViewDelegate <NSObject>

/**
	等待加载结束事件
	@param loadingView 事件触发视图
	@param code 返回编码，0表示正常结束，1表示取消
 */
- (void)loadingView:(UILoadingView*)loadingView endWithCode:(LoadingViewCode)code;


@end

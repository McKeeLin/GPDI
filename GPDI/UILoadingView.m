//
//  UILoadingView.m
//  CloudContacts
//
//  Created by lipeng on 13-9-23.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "UILoadingView.h"
#import <QuartzCore/CALayer.h>
//Optima-Bold
#define tipFont [UIFont systemFontOfSize:12]


#define activityViewWidth 26

typedef void (^PLoadingViewCompletionBlock)(NSInteger);

@interface UILoadingView()

@property (assign, nonatomic) PLoadingViewCompletionBlock completinBlock;

@property (retain, nonatomic) NSDate *startTime;

@property (assign, nonatomic) BOOL _canClose;

@end

@implementation UILoadingView{
    
    UIView *_tipView;
    UILabel *_tipLabel;
    UIActivityIndicatorView *aiView;
    CFRunLoopRef _currentRunLoop;
    NSString *_message;
}

@synthesize message = _message;
@synthesize delegate,_canClose;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _canClose = YES;
        [self createView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame canClose:(BOOL)canClose
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _canClose = canClose;
        [self createView];
    }
    return self;
}

- (void)dealloc
{
    self.startTime = nil;
    if ( self.completinBlock )
    {
        [self.completinBlock release];
        self.completinBlock = nil;
    }
    self.message = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)createView
{
    int height = 40;
    CGFloat width = 120;
    CGRect rect = CGRectMake(0, 0, width, height);
    _tipView = [[[UIView alloc] initWithFrame:rect] autorelease];
    _tipView.backgroundColor = [UIColor blackColor];
    _tipView.layer.cornerRadius = 4;
    _tipView.layer.masksToBounds = YES;
    
    //label
    rect.origin.x = 4;
    rect.origin.y = 4;
    rect.size.width -= (4 + 2 + activityViewWidth + 6 + 40);
    rect.size.height -= 8;
    _tipLabel = [[[UILabel alloc] initWithFrame:rect] autorelease];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.numberOfLines = 1;
    [_tipLabel setFont:tipFont];
    [_tipLabel setTextColor:[UIColor whiteColor]];
    _tipLabel.backgroundColor = [UIColor clearColor];
//    _tipLabel.autoresizesSubviews = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    [_tipView addSubview:_tipLabel];
    
    //loading view
    
    aiView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    rect.origin.x += rect.size.width + 2;
    rect.origin.y = (height - activityViewWidth)/2;
    rect.size = CGSizeMake(activityViewWidth, activityViewWidth);
    [aiView setFrame:rect];
    aiView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_tipView addSubview:aiView];
    
    if( _canClose )
    {
        //sep line
        UIImage *sepImage = [UIImage imageNamed:@"sep.png"];
        rect.origin.x = width - 32 - 1 - 4;
        rect.origin.y = 0;
        rect.size.width = 1;
        rect.size.height = height;
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin;
        imageView.backgroundColor = [UIColor clearColor];
        [imageView setImage: sepImage];
        imageView.alpha = 0.5;
        [_tipView addSubview:imageView];
        
        //close button
        rect.origin.x =width - 32 - 4;
        rect.origin.y = (height-32)/2;
        rect.size = CGSizeMake(32, 32);
        UIImage *closeImage = [UIImage imageNamed:@"close_btn.png"];
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.backgroundColor = [UIColor clearColor];
        closeButton.frame = rect;
        [closeButton setImage:closeImage forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonHandle:) forControlEvents:
         UIControlEventTouchUpInside];
        closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleHeight;
        [_tipView addSubview:closeButton];

    }
    else{
        CGRect newFrame = _tipView.frame;
        newFrame.size.width -= 32 + 4;
        _tipView.frame = newFrame;
    }
    
    [self addSubview:_tipView];
    _tipView.backgroundColor = [UIColor blackColor];
    
    [aiView startAnimating];
}

- (void)setMessage:(NSString *)message
{
    if ( _message )
    {
        [_message release];
        _message = nil;
    }
    _message = [message copy];
    [_tipLabel setText:_message];
}

- (void)show:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGSize size = [self.message sizeWithFont:tipFont forWidth:200 lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect rect = self.bounds;
    CGFloat tipViewWidth = 10 + size.width + 10 + activityViewWidth + 10;
    if( _canClose ){
        tipViewWidth += 4 + 32;
    }
    rect.size.width = tipViewWidth;
    rect.size.height = size.height + 8;
    if ( rect.size.height < 40 )
        rect.size.height = 40;
    rect.origin.x = (self.bounds.size.width - rect.size.width)/2;
    rect.origin.y = (self.bounds.size.height - rect.size.height)/2;
    [_tipView setFrame:rect];
    
    CGRect labelRect = rect;
    labelRect.origin.x = 10;
    labelRect.size.height = size.height;
    labelRect.origin.y = ( _tipView.frame.size.height - size.height ) / 2;
    labelRect.size.width = size.width;
    [_tipLabel setFrame:labelRect];
    [_tipLabel setText:self.message];
    
    if( _canClose ){
        //sep line
        UIImage *sepImage = [UIImage imageNamed:@"sep.png"];
        CGRect lineFrame = rect;
        lineFrame.origin.x = tipViewWidth - 32 - 1 - 4;
        lineFrame.origin.y = 0;
        lineFrame.size.width = 1;
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:lineFrame] autorelease];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin;
        imageView.backgroundColor = [UIColor clearColor];
        [imageView setImage: sepImage];
        imageView.alpha = 0.5;
        imageView.backgroundColor = [UIColor whiteColor];
        [_tipView addSubview:imageView];
        
        //close button
        CGRect buttonFrame;
        buttonFrame.origin.x =tipViewWidth - 32 - 4;
        buttonFrame.origin.y = (rect.size.height-32)/2;
        buttonFrame.size = CGSizeMake(32, 32);
        UIImage *closeImage = [UIImage imageNamed:@"close_btn.png"];
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.backgroundColor = [UIColor clearColor];
        closeButton.frame = buttonFrame;
        [closeButton setImage:closeImage forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonHandle:) forControlEvents:
         UIControlEventTouchUpInside];
        closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleHeight;
        [_tipView addSubview:closeButton];
    }
    
    CGFloat aiViewTop = ( _tipView.frame.size.height - aiView.frame.size.height ) / 2;
    CGFloat aiViewLeft = labelRect.origin.x + labelRect.size.width + 10;
    aiView.frame = CGRectMake(aiViewLeft, aiViewTop, activityViewWidth, activityViewWidth);
    
    self.alpha = 0.0;
    self.transform = CGAffineTransformMakeScale(0.7, 0.7);
    if (view == nil) {
        [window addSubview:self];
    }else{
        [_tipView setFrame:CGRectMake(rect.origin.x, rect.origin.y - 20 - 44, rect.size.width, rect.size.height)];
        [view addSubview:self];
    }
    
    self.startTime = [NSDate date];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
       self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)showModal
{
    [self show:nil];
    
    /*
    _currentRunLoop = CFRunLoopGetCurrent();
    CFRunLoopRun();
    */
}

- (void)closeButtonHandle:(id)sender
{
    [self endWaitWithCode:kLoadingView_Canceled];
}

+ (UILoadingView*)waitWithTipMessage:(NSString*)tipString delegate:(id<UILoadingViewDelegate>)delegate
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UILoadingView *loadingView = [[[UILoadingView alloc] initWithFrame:window.bounds] autorelease];
    loadingView.delegate = delegate;
    loadingView.message = tipString;
    loadingView.backgroundColor = [UIColor clearColor];

    return loadingView;
}

+ (UILoadingView*)waitWithTipMessage:(NSString*)tipString completion:(void (^)(NSInteger))completion
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UILoadingView *loadingView = [[[UILoadingView alloc] initWithFrame:window.bounds] autorelease];
    loadingView.completinBlock = [completion copy];
    loadingView.message = tipString;
    loadingView.backgroundColor = [UIColor clearColor];
    
    return loadingView;
}

+ (UILoadingView*)waitWithTipMessage:(NSString*)tipString forView:(UIView*)view canClose:(BOOL)canClose
{
    UILoadingView *loadingView = [[[UILoadingView alloc] initWithFrame:view.bounds canClose:canClose] autorelease];
    loadingView.delegate = nil;
    loadingView.message = tipString;
    loadingView.backgroundColor = [UIColor clearColor];
    
    return loadingView;

}

/**
 结束等待
 @param code 回调编码
 */
- (void)endWaitWithCode:(LoadingViewCode)code
{
    if ( [self.delegate respondsToSelector:@selector(loadingView:endWithCode:)] )
        [self.delegate loadingView:self endWithCode:code];
    
    if ( self.completinBlock )
    {
        self.completinBlock(code);
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    
        NSDate *now = [NSDate date];
        if ( [now timeIntervalSinceDate:self.startTime] > 1 ) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alpha = 0;
                self.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }else
            [self removeFromSuperview];
    }];
    
    /*
    if ( _currentRunLoop )
    {
        CFRunLoopStop( _currentRunLoop );
        _currentRunLoop = nil;
    }
    */
}

@end

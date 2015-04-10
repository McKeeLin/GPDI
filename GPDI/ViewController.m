//
//  ViewController.m
//  GPDI
//
//  GPDI
//  Copyright (c) 2015年 GPDI. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
{
    IBOutlet UIView *_contentView;
    IBOutlet UITextField *_accountTF;
    IBOutlet UITextField *_pwdTF;
    CGRect _contentViewFrame;
    UITapGestureRecognizer *_tgr;
    UITextField *_currentTextField;
    CGFloat _yOffset;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _yOffset = 0;
    _accountTF.delegate = self;
    _pwdTF.delegate = self;
    _tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardFrameWillShowNotification:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat viewHeight = self.view.bounds.size.height;
    _contentViewFrame = _contentView.frame;
    _contentViewFrame.origin.x = (viewWidth - _contentViewFrame.size.width) / 2;
    _contentViewFrame.origin.y = (viewHeight - _contentViewFrame.size.height) / 2;
    _contentView.frame = _contentViewFrame;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)onKeyboardFrameWillShowNotification:(NSNotification*)notification
{
    [self.view addGestureRecognizer:_tgr];
    
    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSValue *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGSize keyboardSize = [endFrameValue CGRectValue].size;
    CGRect endFrame;
    double duration;
    [endFrameValue getValue:&endFrame];
    [durationValue getValue:&duration];
    [UIView beginAnimations:@"keyboardWillShow" context:nil];
    [UIView setAnimationCurve:curve.unsignedIntegerValue];
    [UIView setAnimationDuration:duration];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frameInSelfView = [_contentView convertRect:_contentView.frame toView:self.view];
    CGRect keyboardFrameSelfView = [window convertRect:endFrame toView:self.view];
    CGFloat diff = keyboardFrameSelfView.origin.y - (frameInSelfView.origin.y + frameInSelfView.size.height + 5);
    //CGFloat diff = (self.view.bounds.size.height - keyboardSize.height) - (_contentView.frame.origin.y + _contentView.frame.size.height);
    if( diff >= 0 )
    {
        _contentView.frame = _contentViewFrame;
    }
    else{
        CGRect newFrame = CGRectOffset(_contentView.frame, 0, diff);
        _contentView.frame = newFrame;
        NSLog(@"%s,%@", __func__, _contentView);
    }
    [UIView commitAnimations];
}

- (void)onKeyboardWillHideNotification:(NSNotification*)notification
{
    [self.view removeGestureRecognizer:_tgr];
    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSValue *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect endFrame;
    double duration;
    [endFrameValue getValue:&endFrame];
    [durationValue getValue:&duration];
    [UIView beginAnimations:@"keyboardWillHide" context:nil];
    [UIView setAnimationCurve:curve.unsignedIntegerValue];
    [UIView setAnimationDuration:duration];
    _contentView.frame = _contentViewFrame;
    [UIView commitAnimations];
}


- (void)onViewTap:(UITapGestureRecognizer*)tgr
{
    [_currentTextField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    return YES;
}


@end

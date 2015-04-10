//
//  loginVC.m
//  GPDI
//
//  Copyright (c) 2015年 GPDI. All rights reserved.
//

#import "loginVC.h"
#import "gisDataMgr.h"
#import "UILoadingView.h"
#import "UITipView.h"
#import "mainVC.h"

@interface loginVC ()<UITextFieldDelegate>
{
    UIImageView *_logoImg;
    UIImageView *_accountIco;
    UIImageView *_passwordIco;
    UIView *_accountLine;
    UIView *_passwordLine;
    UIView *_containerView;
    UITextField *_accountTf;
    UITextField *_passwordTf;
    UIButton *_loginButton;
    CGRect _containerFrame;
    UITapGestureRecognizer *_tgr;
    UITextField *_currentTextField;
    CGFloat _yOffset;
    UILoadingView *_loadingView;
}
@end

@implementation loginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat viewHeight = self.view.bounds.size.height;
    CGFloat containerWidth = 280;
    CGFloat containerHeight = 425;
    _containerFrame.origin.x = (viewWidth - containerWidth) / 2;
    _containerFrame.origin.y = (viewHeight - containerHeight) / 2;
    _containerFrame.size.width = containerWidth;
    _containerFrame.size.height = containerHeight;
    _containerView = [[UIView alloc] initWithFrame:_containerFrame];
    [self.view addSubview:_containerView];
    
    _logoImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_containerView addSubview:_logoImg];
    
    _accountIco = [[UIImageView alloc] initWithFrame:CGRectZero];
    _accountIco.image = [UIImage imageNamed:@"login_user_logo"];
    [_containerView addSubview:_accountIco];
    
    _accountTf = [[UITextField alloc] initWithFrame:CGRectZero];
    _accountTf.font = [UIFont systemFontOfSize:14];
    _accountTf.delegate = self;
    [_containerView addSubview:_accountTf];
    
    _accountLine = [[UIView alloc] initWithFrame:CGRectZero];
    _accountLine.backgroundColor = [UIColor blueColor];
    [_containerView addSubview:_accountLine];
    
    _passwordIco = [[UIImageView alloc] initWithFrame:CGRectZero];
    _passwordIco.image = [UIImage imageNamed:@"login_pwd_logo"];
    [_containerView addSubview:_passwordIco];
    
    _passwordTf = [[UITextField alloc] initWithFrame:CGRectZero];
    _passwordTf.delegate = self;
    _passwordTf.secureTextEntry = YES;
    [_containerView addSubview:_passwordTf];
    
    _passwordLine = [[UIView alloc] initWithFrame:CGRectZero];
    _passwordLine.backgroundColor = [UIColor blueColor];
    [_containerView addSubview:_passwordLine];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setTitle:@"login" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(onTouchLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_loginButton];
    
    _logoImg.frame = CGRectMake(6, 0, 268, 284);
    _accountIco.frame = CGRectMake(8, 292, 32, 32);
    _accountTf.frame = CGRectMake(51, 294, 216, 30);
    _accountLine.frame = CGRectMake(6, 325, 268, 1);
    _passwordIco.frame = CGRectMake(8, 330, 32, 32);
    _passwordTf.frame = CGRectMake(51, 332, 216, 30);
    _passwordLine.frame = CGRectMake(6, 363, 268, 1);
    _loginButton.frame = CGRectMake(6, 383, 268, 36);
    
    _yOffset = 0;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)onKeyboardFrameWillShowNotification:(NSNotification*)notification
{
    [self.view addGestureRecognizer:_tgr];
    
    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSValue *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect endFrame;
    double duration;
    [endFrameValue getValue:&endFrame];
    [durationValue getValue:&duration];
    [UIView beginAnimations:@"keyboardWillShow" context:nil];
    [UIView setAnimationCurve:curve.unsignedIntegerValue];
    [UIView setAnimationDuration:duration];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect keyboardFrameSelfView = [window convertRect:endFrame toView:self.view];
    CGRect newFrame = _containerView.frame;
    newFrame.origin.y = keyboardFrameSelfView.origin.y - newFrame.size.height;
    _containerView.frame = newFrame;
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
    _containerView.frame = _containerFrame;
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

- (void)onTouchLogin:(id)sender
{
    if( _accountTf.text.length == 0 ){
        [UITipView showTip:NSLocalizedString(@"inputAccountTips", @"") atView:self.view];
        return;
    }
    if( _passwordTf.text.length == 0 ){
        [UITipView showTip:NSLocalizedString(@"inputPassword", @"") atView:self.view];
        return;
    }
    
    _loadingView = [UILoadingView waitWithTipMessage:NSLocalizedString(@"loginning", @"") forView:self.view canClose:NO];
    [gisDataMgr asyncLogin:_accountTf.text password:_passwordTf.text block:^(int status, NSString *msg){
        [_loadingView endWaitWithCode:kLoadingView_Finised];
        if( status == 0 ){
            ;
        }
        else{
            [UITipView showTip:msg atView:self.view];
        }
    }];
}


@end

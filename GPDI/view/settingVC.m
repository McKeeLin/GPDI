//
//  settingVC.m
//  GPDI
//
//  Created by McKee on 15/4/13.
//  Copyright (c) 2015年 mckeelin. All rights reserved.
//

#import "settingVC.h"

@interface settingVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    UITableView *_tv;
    UITextField *_tf1;
    UITextField *_tf2;
    UITextField *_tf3;
    UITextField *_tf4;
    UITextField *_currentTextField;
    
    UITapGestureRecognizer *_tgr;
    UISwipeGestureRecognizer *_swipeUpGesture;
    UISwipeGestureRecognizer *_swipeDownGesture;
    CGFloat _yOffset;
}

@end

@implementation settingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tf1 = [[UITextField alloc] initWithFrame:CGRectZero];
    _tf1.text = @"";
    _tf1.placeholder = @"请输入版本号";
    _tf1.font = [UIFont systemFontOfSize:14];
    _tf1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _tf1.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_tf1];
    
    _tv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tv.backgroundColor = [UIColor clearColor];
    _tv.dataSource = self;
    _tv.delegate = self;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tv];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CANCEL", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onTouchUpInCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OK", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onTouchUpInOK:)];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardFrameWillShowNotification:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification object:nil];
    
    _tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollViewTap:)];
    _swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollViewSwipe:)];
    _swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    _swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollViewSwipe:)];
    _swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.numberOfLines = 1;
    if( section == 0 ){
        titleLabel.text = @"版本号";
    }
    else if( section == 1 ){
        titleLabel.text = @"国内主机地址";
    }
    else if( section == 2 ){
        titleLabel.text = @"海外主机地址1";
    }
    else{
        titleLabel.text = @"海外主机地址2";
    }
    [headerView addSubview:titleLabel];
    return headerView;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    return YES;
}


- (void)onKeyboardFrameWillShowNotification:(NSNotification*)notification
{
    _tv.scrollEnabled = NO;
    [_tv addGestureRecognizer:_tgr];
    [_tv addGestureRecognizer:_swipeUpGesture];
    [_tv addGestureRecognizer:_swipeDownGesture];
    
    
    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame;
    [endFrameValue getValue:&endFrame];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frameInSelfView = [_currentTextField convertRect:_currentTextField.frame toView:self.view];
    CGRect keyboardFrameSelfView = [window convertRect:endFrame toView:self.view];
    CGFloat diff = keyboardFrameSelfView.origin.y - (frameInSelfView.origin.y + frameInSelfView.size.height + 5);
    NSLog(@"%s, diff:%.02f", __func__, diff);
    if( diff >= 0 )
    {
        return;
    }
    else{
        if( _yOffset != 0 ){
            _yOffset += diff;
        }
        else{
            _yOffset = diff;
        }
        _tv.contentOffset = CGPointMake(_tv.contentOffset.x, _tv.contentOffset.y - diff);
    }
}

- (void)onKeyboardWillHideNotification:(NSNotification*)notification
{
    _tv.scrollEnabled = YES;
    [_tv removeGestureRecognizer:_tgr];
    [_tv removeGestureRecognizer:_swipeUpGesture];
    [_tv removeGestureRecognizer:_swipeDownGesture];
    _tv.contentOffset = CGPointMake(_tv.contentOffset.x, _tv.contentOffset.y + _yOffset);
    _yOffset = 0;
}


- (void)onScrollViewTap:(UITapGestureRecognizer*)tgr
{
    [_currentTextField resignFirstResponder];
}

- (void)onScrollViewSwipe:(UIPanGestureRecognizer*)pgr
{
    [_currentTextField resignFirstResponder];
}


- (void)onTouchUpInOK:(id)sender
{
}

- (void)onTouchUpInCancel:(id)sender
{
}


@end

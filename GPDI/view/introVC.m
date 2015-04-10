//
//  introVC.m
//  GPDI
//
//  Copyright (c) 2015年 mckeelin. All rights reserved.
//

#import "introVC.h"

@interface introVC ()
{
    IBOutlet UILabel *_mainTitleLabel;
    IBOutlet UILabel *_subTitleLabel;
    IBOutlet UIWebView *_webView;
}

@end

@implementation introVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainTitleLabel.text = NSLocalizedString(@"welcom", @"");
    _subTitleLabel.text = NSLocalizedString(@"welcom2", @"");
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

@end

//
//  mainVC.m
//  GPDI
//
//  Copyright (c) 2015年 GPDI. All rights reserved.
//

#import "mainVC.h"
#import "barItemCustomView.h"
#import "controlsBar.h"
#import "introVC.h"
#import "aboutVC.h"
#import "settingVC.h"
#import "KxMenu.h"


@interface mainVC ()<UISearchBarDelegate,UISearchDisplayDelegate>
{
    IBOutlet UIBarButtonItem *_layerItem;
    IBOutlet UIBarButtonItem *_introItem;
    IBOutlet UIBarButtonItem *_sightItem;
    IBOutlet UIBarButtonItem *_flyItem;
    IBOutlet UIBarButtonItem *_setingItem;
    controlsBar *_controlsBar;
    UIToolbar *_toolBar;
    UISearchDisplayController *_searchDisplayController;
}

@end

@implementation mainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    barItemCustomView *layerView = [self loadBarItemCustomView];
    layerView.imageView.image = [UIImage imageNamed:@"bottom_layers"];
    layerView.label.text = NSLocalizedString(@"layer", @"");
    _layerItem.customView = layerView;
    [layerView.button addTarget:self action:@selector(onTouchLayer:) forControlEvents:UIControlEventTouchUpInside];
    
    barItemCustomView *introView = [self loadBarItemCustomView];
    introView.imageView.image = [UIImage imageNamed:@"bottom_intro"];
    introView.label.text = NSLocalizedString(@"intro", @"");
    [introView.button addTarget:self action:@selector(onTouchIntro:) forControlEvents:UIControlEventTouchUpInside];
    _introItem.customView = introView;
    
    barItemCustomView *sightView = [self loadBarItemCustomView];
    sightView.imageView.image = [UIImage imageNamed:@"bottom_sight"];
    sightView.label.text = NSLocalizedString(@"sight", @"");
    _sightItem.customView = sightView;
    [sightView.button addTarget:self action:@selector(onTouchSight:) forControlEvents:UIControlEventTouchUpInside];
    
    barItemCustomView *flyView = [self loadBarItemCustomView];
    flyView.imageView.image = [UIImage imageNamed:@"bottom_fly"];
    flyView.label.text = NSLocalizedString(@"fly", @"");
    _flyItem.customView = flyView;
    [flyView.button addTarget:self action:@selector(onTouchFly:) forControlEvents:UIControlEventTouchUpInside];
    
    barItemCustomView *settingView = [self loadBarItemCustomView];
    settingView.imageView.image = [UIImage imageNamed:@"bottom_intro"];
    settingView.label.text = NSLocalizedString(@"setting", @"");
    _setingItem.customView = settingView;
    [settingView.button addTarget:self action:@selector(onTouchSetting:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat viewWidth = self.view.frame.size.width;
    _controlsBar = [[[NSBundle mainBundle] loadNibNamed:@"Views" owner:nil options:nil] objectAtIndex:1];
    CGRect controlsBarFrame = _controlsBar.frame;
    controlsBarFrame.size.width = viewWidth - 100;
    _controlsBar.frame = controlsBarFrame;
    _controlsBar.searchBar.delegate = self;
    UIView *barView = [_controlsBar.searchBar.subviews objectAtIndex:0];
    for( UIView *subView in barView.subviews ){
        if( [subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")] ){
            [subView removeFromSuperview];
            break;
        }
    }
    [_controlsBar.searchButton addTarget:self action:@selector(onTouchSearch:) forControlEvents:UIControlEventTouchUpInside];
    [_controlsBar.playButton addTarget:self action:@selector(onTouchPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_controlsBar.pauseButton addTarget:self action:@selector(onTouchPause:) forControlEvents:UIControlEventTouchUpInside];
    [_controlsBar.stopButton addTarget:self action:@selector(onTouchStop:) forControlEvents:UIControlEventTouchUpInside];
    [_controlsBar.othersButton addTarget:self action:@selector(onTouchOthers:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_controlsBar];
    /*
     UISearchBar
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_controlsBar.searchBar contentsController:self];
    _searchDisplayController.displaysSearchBarInNavigationBar = YES;
    _searchDisplayController.delegate = self;
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect controlsBarFrame = _controlsBar.frame;
    controlsBarFrame.size.width = self.view.bounds.size.width - 100;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [_controlsBar setNeedsDisplay];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (barItemCustomView*)loadBarItemCustomView
{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"Views" owner:nil options:nil];
    barItemCustomView *customView = (barItemCustomView*)objs.firstObject;
    customView.frame = CGRectMake(0, 0, 60, 30);
    return customView;
}

- (void)onTouchLayer:(id)sender
{
    ;
}

- (void)onTouchIntro:(id)sender
{
    introVC *vc = [[introVC alloc] initWithNibName:@"intro" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchSight:(id)sender
{
}

- (void)onTouchFly:(id)sender
{
}

- (void)onTouchSetting:(id)sender
{
    ;
}

- (void)onTouchSearch:(id)sender
{
    [_controlsBar showSearchBar];
}

- (void)onTouchPlay:(id)sender
{
    
}

- (void)onTouchPause:(id)sender
{
    
}

- (void)onTouchStop:(id)sender
{
    
}

- (void)onTouchAbout:(id)sender
{
    [self.navigationController pushViewController:[aboutVC viewController] animated:YES];
}


- (void)onTouchLogout:(id)sender
{
    ;
}

- (void)onTouchOthers:(id)sender
{
    UIButton *button = (UIButton*)sender;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect buttonFrame = [window convertRect:button.frame fromView:button.superview];
    NSArray *items =
    @
    [
     [KxMenuItem menuItem:@"设置" image:nil target:self action:@selector(onTouchSetting:)],
     [KxMenuItem menuItem:@"关于" image:nil target:self action:@selector(onTouchAbout:)],
     [KxMenuItem menuItem:@"注销" image:nil target:self action:@selector(onTouchLogout:)]
    ];
    [KxMenu showMenuInView:window
                  fromRect:buttonFrame
                 menuItems:items];
}

- (void)onSearch
{
    ;
}


#pragma mark - UISearchBarDelegate UISearchDisplayDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_controlsBar dismissSearchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    ;
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    _controlsBar.searchBar.showsCancelButton = YES;
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    _controlsBar.searchBar.showsCancelButton = NO;
}

@end

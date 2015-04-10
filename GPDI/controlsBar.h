//
//  controlsBar.h
//  GPDI
//
//  Copyright (c) 2015年 GPDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface controlsBar : UIView

@property (nonatomic,strong) IBOutlet UIButton *searchButton;

@property (nonatomic,strong) IBOutlet UIButton *playButton;

@property (nonatomic,strong) IBOutlet UIButton *pauseButton;

@property (nonatomic,strong) IBOutlet UIButton *stopButton;

@property (nonatomic,strong) IBOutlet UIButton *othersButton;

@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;

@property (nonatomic,strong) IBOutlet UIView *containerView;

- (void)showSearchBar;

- (void)dismissSearchBar;

@end

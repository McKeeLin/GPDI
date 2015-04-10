//
//  controlsBar.m
//  GPDI
//
//  Copyright (c) 2015年 GPDI. All rights reserved.
//

#import "controlsBar.h"

@interface controlsBar ()
{
    CGRect _containerViewFrame;
    CGRect _searchBarFrame;
}

@end

@implementation controlsBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    _containerViewFrame = self.containerView.frame;
    _searchBar.hidden = YES;
    _searchBarFrame = _containerViewFrame;
    _searchBarFrame.size.width -= 10;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _searchBarFrame = self.bounds;
    _searchBarFrame.size.width -= 10;
}

- (void)showSearchBar
{
    [UIView animateWithDuration:1 animations:^(){
        _searchBar.hidden = NO;
        _searchBar.frame = _searchBarFrame;
        _containerView.frame = CGRectOffset(_containerViewFrame, _containerViewFrame.size.width, 0);
        _containerView.hidden = YES;
    }];
}

- (void)dismissSearchBar
{
    [UIView animateWithDuration:1 animations:^(){
        _searchBar.hidden = YES;
        CGRect searchBarFrame = _searchBarFrame;
        searchBarFrame.size.width = 0;
        _searchBar.frame = searchBarFrame;
        _containerView.frame = _containerViewFrame;
        _containerView.hidden = NO;
    }];
}

@end

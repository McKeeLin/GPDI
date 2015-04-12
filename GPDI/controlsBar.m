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
    _containerViewFrame.origin.x = self.bounds.size.width - _containerViewFrame.size.width - 10;
    _containerView.frame = _containerViewFrame;
}

- (void)showSearchBar
{
    [UIView animateWithDuration:1 animations:^(){
        _searchBar.hidden = NO;
        _searchBar.alpha = 1;
        _searchBar.frame = _searchBarFrame;
        _containerView.frame = CGRectOffset(_containerViewFrame, _containerViewFrame.size.width, 0);
    } completion:^(BOOL finished){
        _containerView.alpha = 0;
    }];
}

- (void)dismissSearchBar
{
    [UIView animateWithDuration:1 animations:^(){
        _searchBar.alpha = 0;
        [_searchBar resignFirstResponder];
        CGRect searchBarFrame = _searchBarFrame;
        searchBarFrame.size.width = 0;
        _searchBar.frame = searchBarFrame;
        _containerView.frame = _containerViewFrame;
        _containerView.alpha = 1;
    } completion:^(BOOL finished){
        _searchBar.hidden = YES;
    }];
}

@end

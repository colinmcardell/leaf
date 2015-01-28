//
//  LFDelayViewController.m
//
//  leaf - iOS Synthesizer
//  Copyright (C) 2015 Colin McArdell
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "LFDelayViewController.h"
#import "LFDelaySliderViewController.h"

#import <Classy/Classy.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "LFDelayViewModel.h"
#import "LFButton.h"

@interface LFDelayViewController ()

@property (strong, nonatomic, readwrite) LFDelaySliderViewController *delaySliderViewController;
@property (strong, nonatomic) LFButton *delayToggleButton;
@property (strong, nonatomic) LFButton *delaySyncToggleButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) LFDelayViewModel *viewModel;

@end

@implementation LFDelayViewController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _viewModel = [LFDelayViewModel new];
    _delaySliderViewController = [LFDelaySliderViewController delaySliderViewController];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self defineLayout];
    
    RAC(self.titleLabel, text) = RACObserve(self.viewModel, title);
    
    // Glide Toggle Bindings
    RAC(self.delayToggleButton, selected) = [self.viewModel delayToggleSignal];
    [self.delayToggleButton rac_liftSelector:@selector(setTitle:forState:)
                                 withSignals:[self.viewModel delayToggleTitleSignal], [RACSignal return:@(UIControlStateNormal)], nil];
    [self.delayToggleButton setRac_command:[self.viewModel delayToggleWasSelectedCommand]];
    
    // Delay Sync Toggle Bindings
    RAC(self.delaySyncToggleButton, selected) = [self.viewModel syncToggleSignal];
    [self.delaySyncToggleButton rac_liftSelector:@selector(setTitle:forState:)
                                     withSignals:[self.viewModel syncToggleTitleSignal], [RACSignal return:@(UIControlStateNormal)], nil];
    [self.delaySyncToggleButton setRac_command:[self.viewModel syncToggleWasSelectedCommand]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.viewModel setActive:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.viewModel setActive:NO];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Private Methods

- (void)setupUI
{
    [self setTitleLabel:[UILabel new]];
    [self.view addSubview:[self titleLabel]];
    
    [self setDelayToggleButton:[LFButton new]];
    [self.view addSubview:[self delayToggleButton]];
    
    [self setDelaySyncToggleButton:[LFButton new]];
    [self.view addSubview:[self delaySyncToggleButton]];
    
    [self addChildViewController:[self delaySliderViewController]];
    [self.view addSubview:[self.delaySliderViewController view]];
    [self.delaySliderViewController didMoveToParentViewController:self];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(10.0f);
        make.height.equalTo(@20.0f);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.delayToggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10.0f);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5f).with.offset(-5.0f);
        make.bottom.equalTo(self.view).multipliedBy(0.25f);
    }];
    
    [self.delaySyncToggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.delayToggleButton);
        make.left.equalTo(self.delayToggleButton.mas_right).with.offset(10.0f);
        make.width.equalTo(self.delayToggleButton);
        make.bottom.equalTo(self.delayToggleButton);
    }];
    
    [self.delaySliderViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.delayToggleButton.mas_bottom).with.offset(10.0f);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

@end

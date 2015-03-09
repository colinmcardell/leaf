//
//  LFGlideViewController.m
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

#import "LFGlideViewController.h"
#import "LFGlideSliderViewController.h"

#import <Classy/Classy.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "LFGlideViewModel.h"
#import "LFButton.h"

@interface LFGlideViewController ()

@property (strong, nonatomic, readwrite) LFGlideSliderViewController *glideSliderViewController;
@property (strong, nonatomic) LFButton *glideToggleButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) LFGlideViewModel *viewModel;

@end

@implementation LFGlideViewController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _viewModel = [LFGlideViewModel new];
    _glideSliderViewController = [LFGlideSliderViewController glideSliderViewController];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
    [self defineLayout];
    
    // Glide Toggle Bindings
    RAC(self.glideToggleButton, selected) = [self.viewModel glideToggleSignal];
    [self.glideToggleButton rac_liftSelector:@selector(setTitle:forState:)
                                 withSignals:[self.viewModel glideTitleSignal], [RACSignal return:@(UIControlStateNormal)], nil];
    [self.glideToggleButton setRac_command:[self.viewModel glideToggleWasSelectedCommand]];
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
    [self setGlideToggleButton:[LFButton new]];
    [self.view addSubview:[self glideToggleButton]];
    
    [self addChildViewController:[self glideSliderViewController]];
    [self.view addSubview:[self.glideSliderViewController view]];
    [self.glideSliderViewController didMoveToParentViewController:self];
}

- (void)defineLayout
{
    [self.glideToggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).multipliedBy(0.2f);
    }];
    
    [self.glideSliderViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.glideToggleButton.mas_bottom).with.offset(10.0f);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

@end

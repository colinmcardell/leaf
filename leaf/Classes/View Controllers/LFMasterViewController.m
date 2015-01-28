//
//  LFMasterViewController.m
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

#import "LFMasterViewController.h"
#import "LFMasterSliderViewController.h"
#import "LFMasterViewModel.h"
#import "LFStepper.h"
#import "LFSynthControllerConstants.h"

#import <Classy/Classy.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LFMasterViewController ()

@property (strong, nonatomic, readwrite) LFMasterSliderViewController *masterSliderViewController;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) LFStepper *tempoStepper;
@property (strong, nonatomic) LFMasterViewModel *viewModel;

@end

@implementation LFMasterViewController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _viewModel = [LFMasterViewModel new];
    _masterSliderViewController = [LFMasterSliderViewController masterSliderViewController];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
    [self defineLayout];
    
    RAC(self.titleLabel, text) = RACObserve(self.viewModel, title);
    RACChannelTerminal *viewModelTempoTerminal = RACChannelTo(self.viewModel, tempo);
    RACChannelTerminal *tempoStepperValueTerminal = [self.tempoStepper rac_newValueChannelWithNilValue:@0];
    [viewModelTempoTerminal subscribe:tempoStepperValueTerminal];
    [tempoStepperValueTerminal subscribe:viewModelTempoTerminal];
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
    
    [self setTempoStepper:[LFStepper new]];
    [self.tempoStepper setMinimumValue:20.0f];
    [self.tempoStepper setMaximumValue:900.0f];
    [self.view addSubview:[self tempoStepper]];
    
    [self addChildViewController:[self masterSliderViewController]];
    [self.view addSubview:[self.masterSliderViewController view]];
    [self.masterSliderViewController didMoveToParentViewController:self];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(10.0f);
        make.height.equalTo(@20.0f);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.tempoStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10.0f);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5f);
        make.bottom.equalTo(self.view);
    }];
    
    [self.masterSliderViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10.0f);
        make.right.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5f);
        make.bottom.equalTo(self.view);
    }];
}

@end

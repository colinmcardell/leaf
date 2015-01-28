//
//  LFOscRangeViewController.m
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

#import "LFOscRangeViewController.h"
#import <Classy/Classy.h>
#import <Masonry/Masonry.h>
#import "LFOscRangeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LFStepper.h"

@interface LFOscRangeViewController ()

@property (strong, nonatomic) LFStepper *rangeStepper;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation LFOscRangeViewController

+ (LFOscRangeViewController *)osc1RangeViewController
{
    return [[self alloc] initWithViewModel:[LFOscRangeViewModel osc1RangeViewModel]];
}

+ (LFOscRangeViewController *)osc2RangeViewController
{
    return [[self alloc] initWithViewModel:[LFOscRangeViewModel osc2RangeViewModel]];
}

- (instancetype)initWithViewModel:(LFOscRangeViewModel *)viewModel
{
    self = [super init];
    if (!self) return nil;
    
    _viewModel = viewModel;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self defineLayout];
    
    RACChannelTerminal *viewModelRangeTerminal = RACChannelTo(self.viewModel, range);
    RACChannelTerminal *rangeStepperValueTerminal = [self.rangeStepper rac_newValueChannelWithNilValue:@0];
    [viewModelRangeTerminal subscribe:rangeStepperValueTerminal];
    [rangeStepperValueTerminal subscribe:viewModelRangeTerminal];
    
    RAC(self.titleLabel, text) = RACObserve(self.viewModel, title);
}

#pragma mark - Private Methods

- (void)setupUI
{
    [self.view setCas_styleClass:@"controlsContainer"];
    
    [self setRangeStepper:[LFStepper new]];
    [self.rangeStepper setVertical:NO];
    [self.rangeStepper setMinimumValue:0.0f];
    [self.rangeStepper setMaximumValue:4.0f];
    [self.view addSubview:[self rangeStepper]];
    
    [self setTitleLabel:[UILabel new]];
    [self.view addSubview:[self titleLabel]];
}

- (void)defineLayout
{
    UIView *superview = [self view];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(superview);
        make.top.equalTo(superview).with.offset(5.0f);
        make.height.equalTo(@20);
    }];
    
    [self.rangeStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(superview);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10.0f);
    }];
}

@end

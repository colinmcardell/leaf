//
//  LFPatternViewController.m
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

#import "LFPatternViewController.h"
#import "LFButton.h"
#import "LFPatternSliderViewController.h"
#import "LFPatternViewModel.h"
#import <Classy/Classy.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LFPatternViewController ()

@property (strong, nonatomic) LFButton *patternClockDivisionHalfButton;
@property (strong, nonatomic) LFButton *patternClockDivisionQuarterButton;
@property (strong, nonatomic) LFButton *patternClockDivisionEighthButton;
@property (strong, nonatomic) LFButton *patternClockDivisionSixteenthButton;
@property (strong, nonatomic) UIView *patterClockDivisionButtonContainerView;
@property (strong, nonatomic) LFPatternSliderViewController *patternSliderViewController;
@property (strong, nonatomic) LFButton *patternToggleButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) LFPatternViewModel *viewModel;

@end

@implementation LFPatternViewController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _viewModel = [LFPatternViewModel new];
    
    [self.view setCas_styleClass:@"controlsContainer"];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self defineLayout];
    
    RAC(self.titleLabel, text) = RACObserve(self.viewModel, title);
    
    // Pattern Toggle Bindings
    RAC(self.patternToggleButton, selected) = [self.viewModel patternToggleSignal];
    [self.patternToggleButton rac_liftSelector:@selector(setTitle:forState:)
                                   withSignals:[self.viewModel patternTitleSignal], [RACSignal return:@(UIControlStateNormal)], nil];
    [self.patternToggleButton setRac_command:[self.viewModel patternToggleWasSelectedCommand]];
    
    // Clock Division Button Bindings
    {
        RAC(self.patternClockDivisionHalfButton, selected) = [self.viewModel halfSelected];
        [self.patternClockDivisionHalfButton setRac_command:[self.viewModel halfWasSelectedCommand]];
        
        RAC(self.patternClockDivisionQuarterButton, selected) = [self.viewModel quarterSelected];
        [self.patternClockDivisionQuarterButton setRac_command:[self.viewModel quarterWasSelectedCommand]];
        
        RAC(self.patternClockDivisionEighthButton, selected) = [self.viewModel eighthSelected];
        [self.patternClockDivisionEighthButton setRac_command:[self.viewModel eighthWasSelectedCommand]];
        
        RAC(self.patternClockDivisionSixteenthButton, selected) = [self.viewModel sixteenthSelected];
        [self.patternClockDivisionSixteenthButton setRac_command:[self.viewModel sixteenthWasSelectedCommand]];
    }
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
    
    // Clock Division Buttons
    {
        [self setPatterClockDivisionButtonContainerView:[UIView new]];
        [self.view addSubview:[self patterClockDivisionButtonContainerView]];
        
        UIView *container = [self patterClockDivisionButtonContainerView];
        
        [self setPatternClockDivisionHalfButton:[LFButton new]];
        [self.patternClockDivisionHalfButton setTitle:@"1/2" forState:UIControlStateNormal];
        [container addSubview:[self patternClockDivisionHalfButton]];
        
        [self setPatternClockDivisionQuarterButton:[LFButton new]];
        [self.patternClockDivisionQuarterButton setTitle:@"1/4" forState:UIControlStateNormal];
        [container addSubview:[self patternClockDivisionQuarterButton]];
        
        [self setPatternClockDivisionEighthButton:[LFButton new]];
        [self.patternClockDivisionEighthButton setTitle:@"1/8" forState:UIControlStateNormal];
        [container addSubview:[self patternClockDivisionEighthButton]];
        
        [self setPatternClockDivisionSixteenthButton:[LFButton new]];
        [self.patternClockDivisionSixteenthButton setTitle:@"1/16" forState:UIControlStateNormal];
        [container addSubview:[self patternClockDivisionSixteenthButton]];
    }
    
    [self setPatternSliderViewController:[LFPatternSliderViewController patternSliderViewController]];
    [self.view addSubview:[self.patternSliderViewController view]];
    [self.patternSliderViewController didMoveToParentViewController:self];
    
    [self setPatternToggleButton:[LFButton new]];
    [self.view addSubview:[self patternToggleButton]];
}

- (void)defineLayout
{
    UIView *superview = [self view];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(superview).with.insets(UIEdgeInsetsMake(10.0f, 0, 0, 0));
        make.height.equalTo(@20.0f);
    }];
    
    [self.patternSliderViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(superview);
        make.bottom.equalTo(superview);
        make.right.equalTo(self.patternToggleButton.mas_left);
    }];
    
    [self.patternToggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10.0f);
        make.right.equalTo(superview).with.offset(-10.0f);
        make.height.equalTo(superview).multipliedBy(0.2f);
        make.width.equalTo(superview.mas_height).multipliedBy(0.2f);
    }];
    
    // Pattern Clock Division Buttons
    {
        [self.patterClockDivisionButtonContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.patternToggleButton.mas_bottom).with.offset(5.0f);
            make.left.and.right.equalTo(self.patternToggleButton);
            make.bottom.equalTo(self.view).with.offset(-5.0f);
        }];
        
        UIView *superview = [self patterClockDivisionButtonContainerView];
        
        [self.patternClockDivisionHalfButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.equalTo(superview);
            make.height.equalTo(superview).multipliedBy(0.25f);
        }];
        
        [self.patternClockDivisionQuarterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.patternClockDivisionHalfButton.mas_bottom);
            make.left.and.right.equalTo(superview);
            make.height.equalTo(self.patternClockDivisionHalfButton);
        }];
        
        [self.patternClockDivisionEighthButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.patternClockDivisionQuarterButton.mas_bottom);
            make.left.and.right.equalTo(superview);
            make.height.equalTo(self.patternClockDivisionHalfButton);
        }];
        
        [self.patternClockDivisionSixteenthButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.patternClockDivisionEighthButton.mas_bottom);
            make.left.and.right.equalTo(superview);
            make.height.equalTo(self.patternClockDivisionHalfButton);
        }];
    }
}

@end

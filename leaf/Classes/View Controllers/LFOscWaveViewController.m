//
//  LFOscWaveViewController.m
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

#import "LFOscWaveViewController.h"
#import "LFOscWaveSliderViewController.h"

#import <Classy/Classy.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "LFOscWaveViewModel.h"
#import "LFButton.h"

@interface LFOscWaveViewController ()

@property (strong, nonatomic, readwrite) LFOscWaveViewModel *viewModel;
@property (strong, nonatomic, readwrite) LFOscWaveSliderViewController *waveSliderViewController;

@property (strong, nonatomic) UIView *waveformButtonsContainerView;
//@property (strong, nonatomic) LFButton *sineWaveButton;
@property (strong, nonatomic) LFButton *sawWaveButton;
@property (strong, nonatomic) LFButton *squareWaveButton;
@property (strong, nonatomic) LFButton *triangleWaveButton;

@end

@implementation LFOscWaveViewController

+ (LFOscWaveViewController *)osc1WaveViewController
{
    LFOscWaveViewController *vc = [[self alloc] initWithViewModel:[LFOscWaveViewModel osc1WaveViewModel]];
    [vc setWaveSliderViewController:[LFOscWaveSliderViewController osc1WaveSliderViewController]];
    return vc;
}

+ (LFOscWaveViewController *)osc2WaveViewController
{
    LFOscWaveViewController *vc = [[self alloc] initWithViewModel:[LFOscWaveViewModel osc2WaveViewModel]];
    [vc setWaveSliderViewController:[LFOscWaveSliderViewController osc2WaveSliderViewController]];
    return vc;
}

- (instancetype)initWithViewModel:(LFOscWaveViewModel *)viewModel
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
    
//    RAC(self.sineWaveButton, selected) = [self.viewModel sineSelected];
//    [self.sineWaveButton setRac_command:[self.viewModel sineWasSelectedCommand]];
    
    RAC(self.sawWaveButton, selected) = [self.viewModel sawSelected];
    [self.sawWaveButton setRac_command:[self.viewModel sawWasSelectedCommand]];
    
    RAC(self.squareWaveButton, selected) = [self.viewModel squareSelected];
    [self.squareWaveButton setRac_command:[self.viewModel squareWasSelectedCommand]];
    
    RAC(self.triangleWaveButton, selected) = [self.viewModel triangleSelected];
    [self.triangleWaveButton setRac_command:[self.viewModel triangleWasSelectedCommand]];
}

- (void)setupUI
{
    // Waveform Buttons
    {
        self.waveformButtonsContainerView = ({
            UIView *view = [UIView new];
            [view setCas_styleClass:@"controlsContainer"];
            view;
        });
        [self.view addSubview:[self waveformButtonsContainerView]];
        
//        [self setSineWaveButton:[LFButton sineButton]];
        [self setSawWaveButton:[LFButton sawButton]];
        [self setSquareWaveButton:[LFButton squareButton]];
        [self setTriangleWaveButton:[LFButton triangleButton]];
        
//        [self.waveformButtonsContainerView addSubview:[self sineWaveButton]];
        [self.waveformButtonsContainerView addSubview:[self sawWaveButton]];
        [self.waveformButtonsContainerView addSubview:[self squareWaveButton]];
        [self.waveformButtonsContainerView addSubview:[self triangleWaveButton]];
    }
    
    [self addChildViewController:[self waveSliderViewController]];
    [self.view addSubview:[self.waveSliderViewController view]];
    [self.waveSliderViewController didMoveToParentViewController:self];
}

- (void)defineLayout
{
    // Waveform Buttons
    {
        [self.waveformButtonsContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view).multipliedBy(0.24f);
        }];
        
        UIView *superview = [self waveformButtonsContainerView];
        
        [self.sawWaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superview).with.offset(10.0f);
            make.centerX.equalTo(superview).with.offset(5.0f);
            make.width.equalTo(superview).with.offset(-10.0f);
            make.bottom.equalTo(superview).multipliedBy(0.333f).with.offset(-2.5f);
        }];
        
        superview = [self sawWaveButton];
        
        [self.squareWaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superview.mas_bottom).with.offset(10.0f);
            make.left.and.width.and.height.equalTo(superview);
        }];
        
        superview = [self squareWaveButton];
        
        [self.triangleWaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superview.mas_bottom).with.offset(10.0f);
            make.left.equalTo(superview);
            make.width.equalTo(superview);
            make.height.equalTo(superview);
        }];
    }
    
    [self.waveSliderViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.waveformButtonsContainerView.mas_right);
    }];
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

@end

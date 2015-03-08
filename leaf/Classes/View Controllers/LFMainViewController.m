//
//  LFMainViewController.m
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

#import "LFMainViewController.h"
#import "LFADSRViewController.h"
#import "LFDelayViewController.h"
#import "LFFilterViewController.h"
#import "LFGlideViewController.h"
#import "LFKeyboardViewController.h"
#import "LFLoggerView.h"
#import "LFMasterViewController.h"
#import "LFOscBasicViewController.h"
#import "LFOscRangeViewController.h"
#import "LFOscWaveViewController.h"
#import "LFPatternViewController.h"
#import "LFSynthController.h"
#import <Masonry/Masonry.h>
#import <Classy/Classy.h>

@interface LFMainViewController ()

@property (strong, nonatomic) LFADSRViewController *adsrViewController;
@property (strong, nonatomic) LFDelayViewController *delayViewController;
@property (strong, nonatomic) LFFilterViewController *filterViewController;
@property (strong, nonatomic) LFGlideViewController *glideViewController;
@property (strong, nonatomic) LFKeyboardViewController *keyboardViewController;
@property (strong, nonatomic) LFMasterViewController *masterViewController;
@property (strong, nonatomic) UIView *osc1View;
@property (strong, nonatomic) LFOscBasicViewController *osc1BasicViewController;
@property (strong, nonatomic) LFOscBasicViewController *osc2BasicViewController;
@property (strong, nonatomic) LFOscRangeViewController *osc1RangeViewController;
@property (strong, nonatomic) UIView *osc2View;
@property (strong, nonatomic) LFOscRangeViewController *osc2RangeViewController;
@property (strong, nonatomic) LFOscWaveViewController *osc1WaveViewController;
@property (strong, nonatomic) LFOscWaveViewController *osc2WaveViewController;
@property (strong, nonatomic) LFPatternViewController *patternViewController;
@property (assign, nonatomic) BOOL playing;
@property (strong, nonatomic) LFSynthController *synthController;

@property (strong, nonatomic) UIView *loggerContainerView;
@property (strong, nonatomic) LFLoggerView *loggerView;

@end

@implementation LFMainViewController

- (id)init
{
    self = [super init];
    if (!self) return nil;

    LFLoggerView *loggerView = [LFLoggerView sharedInstance];
    [DDLog addLogger:loggerView];
    _loggerView = loggerView;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"leaf"];
    [self.view setCas_styleClass:@"mainView"];
    
    [self addSubviews];
    [self defineLayout];

    [self.loggerView showLogInView:[self loggerContainerView]];
}

- (void)addSubviews
{
    // ADSR Controls
    [self setAdsrViewController:[LFADSRViewController new]];
    [self addChildViewController:[self adsrViewController]];
    [self.view addSubview:[self.adsrViewController view]];
    [self.adsrViewController didMoveToParentViewController:self];
    
    // Delay Controls
    [self setDelayViewController:[LFDelayViewController new]];
    [self addChildViewController:[self delayViewController]];
    [self.view addSubview:[self.delayViewController view]];
    [self.delayViewController didMoveToParentViewController:self];
    
    // Master
    [self setMasterViewController:[LFMasterViewController new]];
    [self addChildViewController:[self masterViewController]];
    [self.view addSubview:[self.masterViewController view]];
    [self.masterViewController didMoveToParentViewController:self];
    
    // Osc 1
    {
        // Osc 1 View
        [self setOsc1View:[UIView new]];
        [self.view addSubview:[self osc1View]];
        
        // Osc 1 Controls
        [self setOsc1BasicViewController:[LFOscBasicViewController osc1BasicViewController]];
        [self addChildViewController:[self osc1BasicViewController]];
        [self.osc1View addSubview:[self.osc1BasicViewController view]];
        [self.osc1BasicViewController didMoveToParentViewController:self];
        
        // Osc 1 Range Controller
        [self setOsc1RangeViewController:[LFOscRangeViewController osc1RangeViewController]];
        [self addChildViewController:[self osc1RangeViewController]];
        [self.osc1View addSubview:[self.osc1RangeViewController view]];
        [self.osc1RangeViewController didMoveToParentViewController:self];
        
        // Osc 1 Wave
        [self setOsc1WaveViewController:[LFOscWaveViewController osc1WaveViewController]];
        [self addChildViewController:[self osc1WaveViewController]];
        [self.osc1View addSubview:[self.osc1WaveViewController view]];
        [self.osc1WaveViewController didMoveToParentViewController:self];
    }
    
    // Osc 2
    {
        // Osc 2 View
        [self setOsc2View:[UIView new]];
        [self.view addSubview:[self osc2View]];
        
        // Osc 2 Controls
        [self setOsc2BasicViewController:[LFOscBasicViewController osc2BasicViewController]];
        [self addChildViewController:[self osc2BasicViewController]];
        [self.osc2View addSubview:[self.osc2BasicViewController view]];
        [self.osc2BasicViewController didMoveToParentViewController:self];
        
        // Osc 2 Range Controller
        [self setOsc2RangeViewController:[LFOscRangeViewController osc2RangeViewController]];
        [self addChildViewController:[self osc2RangeViewController]];
        [self.osc2View addSubview:[self.osc2RangeViewController view]];
        [self.osc2RangeViewController didMoveToParentViewController:self];
        
        // Osc 2 Wave
        [self setOsc2WaveViewController:[LFOscWaveViewController osc2WaveViewController]];
        [self addChildViewController:[self osc2WaveViewController]];
        [self.osc2View addSubview:[self.osc2WaveViewController view]];
        [self.osc2WaveViewController didMoveToParentViewController:self];
    }
    
    // Filter Controls
    [self setFilterViewController:[LFFilterViewController new]];
    [self addChildViewController:[self filterViewController]];
    [self.view addSubview:[self.filterViewController view]];
    [self.filterViewController didMoveToParentViewController:self];
    
    // Keyboard
    [self setKeyboardViewController:[LFKeyboardViewController new]];
    [self addChildViewController:[self keyboardViewController]];
    [self.view addSubview:[self.keyboardViewController view]];
    [self.keyboardViewController didMoveToParentViewController:self];
    
    // Pattern
    [self setPatternViewController:[LFPatternViewController new]];
    [self addChildViewController:[self patternViewController]];
    [self.view addSubview:[self.patternViewController view]];
    [self.patternViewController didMoveToParentViewController:self];
    
    // Glide
    [self setGlideViewController:[LFGlideViewController new]];
    [self addChildViewController:[self glideViewController]];
    [self.view addSubview:[self.glideViewController view]];
    [self.glideViewController didMoveToParentViewController:self];
    
    [self setLoggerContainerView:[UIView new]];
    [self.view addSubview:[self loggerContainerView]];
}

- (void)defineLayout
{
    CGFloat oscViewHeightMultiplier = 0.71f;
    // Oscillators
    {
        CGFloat oscViewWidth = 204.0f;
        // Osc 1
        {
            // Osc 1 View
            [self.osc1View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.left.equalTo(self.view).with.offset(10.0f);
                make.width.equalTo(@(oscViewWidth));
                make.height.equalTo(self.view).multipliedBy(oscViewHeightMultiplier).with.offset(-20.0f);
            }];
            
            UIView *superview = [self osc1View];
            
            // Osc 1 Controls
            [self.osc1BasicViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.left.and.right.equalTo(superview);
                make.height.equalTo(superview).multipliedBy(0.43f);
            }];
            
            // Osc 1 Wave
            [self.osc1WaveViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.osc1BasicViewController.view.mas_bottom);
                make.left.and.right.equalTo(superview);
                make.height.equalTo(superview).multipliedBy(0.39f);
            }];
            
            // Osc 1 Range
            [self.osc1RangeViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.osc1WaveViewController.view.mas_bottom);
                make.left.and.right.and.bottom.equalTo(superview);
            }];
        }
        
        // Osc 2
        {
            // Osc 2 View
            [self.osc2View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(10.0f);
                make.left.equalTo(self.osc1View.mas_right).with.offset(10.0f);
                make.width.equalTo(@(oscViewWidth));
                make.height.equalTo(self.view).multipliedBy(oscViewHeightMultiplier).with.offset(-20.0f);
            }];
            
            UIView *superview = [self osc2View];
            
            // Osc 2 Controls
            [self.osc2BasicViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.left.and.right.equalTo(superview);
                make.height.equalTo(superview).multipliedBy(0.43f);
            }];
            
            // Osc 2 Wave
            [self.osc2WaveViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.osc2BasicViewController.view.mas_bottom);
                make.left.and.right.equalTo(superview);
                make.height.equalTo(superview).multipliedBy(0.39f);
            }];
            
            // Osc 1 Range
            [self.osc2RangeViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.osc2WaveViewController.view.mas_bottom);
                make.left.and.right.and.bottom.equalTo(superview);
            }];
        }
    }
    
    UIView *superview = [self view];
    
    // Master
    [self.masterViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).with.offset(10.0f);
        make.right.equalTo(superview).with.offset(-10.0f);
        make.width.equalTo(@100.0f);
        make.height.equalTo(@250.0f);
    }];
    
    // Filter Controls
    [self.filterViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.masterViewController.view);
        make.right.equalTo(self.masterViewController.view.mas_left).with.offset(-10.0f);
        make.width.equalTo(@100.0f);
        make.height.equalTo(self.masterViewController.view);
    }];
    
    // ADSR Controls
    [self.adsrViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.masterViewController.view);
        make.right.equalTo(self.filterViewController.view.mas_left).with.offset(-10.0f);
        make.width.equalTo(@200.0f);
        make.height.equalTo(self.masterViewController.view);
    }];
    
    // Keyboard
    [self.keyboardViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview).with.offset(10.0f);
        make.right.equalTo(superview).with.offset(-70.0f);
        make.bottom.equalTo(superview).with.offset(-10.0f);
        make.height.equalTo(superview).multipliedBy(1.0f - oscViewHeightMultiplier).with.offset(-10.0f);
    }];
    
    // Delay
    [self.delayViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.masterViewController.view.mas_bottom);
        make.right.equalTo(superview).with.offset(-10.0f);
        make.bottom.equalTo(self.keyboardViewController.view.mas_top).with.offset(-10.0f);
        make.width.equalTo(@150.0f);
    }];
    
    // Logger Container View
    [self.loggerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.masterViewController.view.mas_bottom).with.offset(10.0f);
        make.left.equalTo(self.osc2View.mas_right).with.offset(10.0f);
        make.right.equalTo(self.patternViewController.view.mas_left).with.offset(-10.0f);
        make.bottom.equalTo(self.keyboardViewController.view.mas_top).with.offset(-10.0f);
    }];
    
    // Pattern
    [self.patternViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.masterViewController.view.mas_bottom).with.offset(10.0f);
        make.right.equalTo(self.delayViewController.view.mas_left).with.offset(-10.0f);
        make.bottom.equalTo(self.keyboardViewController.view.mas_top).with.offset(-10.0f);
        make.width.equalTo(@130.0f);
    }];
    
    // Glide
    [self.glideViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.keyboardViewController.view);
        make.left.equalTo(self.keyboardViewController.view.mas_right).with.offset(10.0f);
        make.right.equalTo(superview).with.offset(-10.0f);
        make.bottom.equalTo(self.keyboardViewController.view);
    }];
}

- (void)triggerTestNote
{
    [self setPlaying:!_playing];
    [self playing] ? [[LFSynthController sharedController] sendNoteOn:@(40)] : [[LFSynthController sharedController] sendNoteOff:@(40)];
}

@end

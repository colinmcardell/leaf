//
//  LFKeyboardViewController.m
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

#import "LFKeyboardViewController.h"
#import "LFKeyboardView.h"
#import "LFKeyboardViewModel.h"
#import "LFButton.h"
#import "LFStepper.h"
#import "LFSynthController.h"
#import <Classy/Classy.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LFKeyboardViewController () <LFKeyboardDelegate>

@property (strong, nonatomic) LFButton *holdToggleButton;
@property (strong, nonatomic) LFKeyboardView *keyboardView;
@property (strong, nonatomic) UIView *keyboardControlsView;
@property (strong, nonatomic) UILabel *octaveLabel;
@property (strong, nonatomic) LFStepper *octaveStepper;
@property (strong, nonatomic) LFKeyboardViewModel *viewModel;

@end

@implementation LFKeyboardViewController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _viewModel = [LFKeyboardViewModel new];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
    [self defineLayout];
    
    // Hold Toggle Bindings
    RAC(self.holdToggleButton, selected) = [self.viewModel holdToggleSignal];
    [self.holdToggleButton rac_liftSelector:@selector(setTitle:forState:)
                                withSignals:[self.viewModel holdTitleSignal], [RACSignal return:@(UIControlStateNormal)], nil];
    [self.holdToggleButton setRac_command:[self.viewModel holdToggleWasSelectedCommand]];
    
    [self.octaveLabel setText:@"Octave"];
    RACChannelTo(self.octaveStepper, value) = RACChannelTo(self.keyboardView, currentOctave);
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
    [self setKeyboardView:[[LFKeyboardView alloc] initWithDelegate:self]];
    [self.view addSubview:[self keyboardView]];
    
    [self setKeyboardControlsView:[UIView new]];
    [self.keyboardControlsView setCas_styleClass:@"controlsContainer"];
    [self.view addSubview:[self keyboardControlsView]];
    
    [self setHoldToggleButton:[LFButton new]];
    [self.keyboardControlsView addSubview:[self holdToggleButton]];
    
    [self setOctaveLabel:[UILabel new]];
    [self.keyboardControlsView addSubview:[self octaveLabel]];
    
    [self setOctaveStepper:[LFStepper new]];
    [self.keyboardControlsView addSubview:[self octaveStepper]];
}

- (void)defineLayout
{
    // Keyboard Controls
    {
        UIView *superview = [self keyboardControlsView];
        [self.keyboardControlsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.bottom.equalTo(self.view);
            make.width.equalTo(self.view).multipliedBy(0.08f);
        }];
        
        [self.holdToggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.right.and.left.equalTo(superview).with.insets(UIEdgeInsetsMake(5.0f, 5.0f, 0.0f, 5.0f));
            make.height.equalTo(superview).multipliedBy(0.15f);
        }];
        
        [self.octaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.holdToggleButton.mas_bottom).with.offset(10.0f);
            make.right.and.left.equalTo(superview);
            make.height.equalTo(@20.0f);
        }];
        
        [self.octaveStepper mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(superview);
            make.top.equalTo(self.octaveLabel.mas_bottom).with.offset(10.0f);
        }];
    }
    
    UIView *superview = [self view];
    
    [self.keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.bottom.equalTo(superview);
        make.left.equalTo(self.keyboardControlsView.mas_right).with.offset(10.0f);
    }];
}

- (void)noteOn:(NSUInteger)note
{
    [[LFSynthController sharedController] sendNoteOn:@(note)];
}

- (void)noteOff:(NSUInteger)note
{
    if (![self.viewModel hold]) [[LFSynthController sharedController] sendNoteOff:@(note)];
}

@end

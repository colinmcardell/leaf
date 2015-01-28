//
//  LFOscWaveSliderPackViewModel.m
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

#import "LFOscWaveSliderPackViewModel.h"
#import "LFSynthController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation LFOscWaveSliderPackViewModel

+ (LFOscWaveSliderPackViewModel *)osc1WaveSliderPackViewModel
{
    LFOscWaveSliderPackViewModel *viewModel = [[self alloc] init];
    
    LFSynthController *synthController = [LFSynthController sharedController];
    
    RACChannelTo(viewModel, pwmFreq) = RACChannelTo(synthController, osc1PWMFreq);
    RACChannelTo(viewModel, pwmDepth) = RACChannelTo(synthController, osc1PWMDepth);
    RACChannelTo(viewModel, triSlope) = RACChannelTo(synthController, osc1TriSlope);
    
    return viewModel;
}

+ (LFOscWaveSliderPackViewModel *)osc2WaveSliderPackViewModel
{
    LFOscWaveSliderPackViewModel *viewModel = [[self alloc] init];
    
    LFSynthController *synthController = [LFSynthController sharedController];
    
    RACChannelTo(viewModel, pwmFreq) = RACChannelTo(synthController, osc2PWMFreq);
    RACChannelTo(viewModel, pwmDepth) = RACChannelTo(synthController, osc2PWMDepth);
    RACChannelTo(viewModel, triSlope) = RACChannelTo(synthController, osc2TriSlope);
    
    return viewModel;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    [self setSliderLabelsTitles:@[@"PWM Freq", @"PWM Depth", @"Tri Slope"]];
    
    return self;
}

@end

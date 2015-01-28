//
//  LFOscBasicViewModel.m
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

#import "LFOscBasicViewModel.h"
#import "LFSynthController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation LFOscBasicViewModel

+ (LFOscBasicViewModel *)osc1BasicViewModel
{
    LFOscBasicViewModel *viewModel = [[self alloc] init];

    LFSynthController *synthController = [LFSynthController sharedController];

    RACChannelTo(viewModel, clipDrive) = RACChannelTo(synthController, osc1SoftClipDrive);
    RACChannelTo(viewModel, clipMix) = RACChannelTo(synthController, osc1SoftClipMix);
    RACChannelTo(viewModel, frequency) = RACChannelTo(synthController, osc1Freq);
    RACChannelTo(viewModel, volume) = RACChannelTo(synthController, osc1Volume);
    
    [viewModel setTitle:@"Oscillator 1"];

    return viewModel;
}

+ (LFOscBasicViewModel *)osc2BasicViewModel
{
    LFOscBasicViewModel *viewModel = [[self alloc] init];
    
    LFSynthController *synthController = [LFSynthController sharedController];
    
    RACChannelTo(viewModel, clipDrive) = RACChannelTo(synthController, osc2SoftClipDrive);
    RACChannelTo(viewModel, clipMix) = RACChannelTo(synthController, osc2SoftClipMix);
    RACChannelTo(viewModel, frequency) = RACChannelTo(synthController, osc2Freq);
    RACChannelTo(viewModel, volume) = RACChannelTo(synthController, osc2Volume);
    
    [viewModel setTitle:@"Oscillator 2"];
    
    return viewModel;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self setSliderLabelsTitles:@[@"Clip Drive", @"Clip Mix", @"Fine Tune", @"Volume"]];

    return self;
}

@end

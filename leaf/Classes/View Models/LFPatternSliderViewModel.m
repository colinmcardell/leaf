//
//  LFPatternSliderViewModel.m
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

#import "LFPatternSliderViewModel.h"
#import "LFSynthController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation LFPatternSliderViewModel

+ (LFPatternSliderViewModel *)viewModel
{
    LFPatternSliderViewModel *viewModel = [[self alloc] init];
    
    LFSynthController *synthController = [LFSynthController sharedController];
    
    RACChannelTo(viewModel, patternNoteGate) = RACChannelTo(synthController, arpGate);
    
    return viewModel;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    [self setSliderLabelsTitles:@[@"Gate"]];
    
    return self;
}

@end

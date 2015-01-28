//
//  LFSliderPackView+CASAdditions.m
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

#import "LFSliderPackView+CASAdditions.h"
#import <Classy/Classy.h>

@implementation LFSliderPackView (CASAdditions)

+ (void)load
{
    CASObjectClassDescriptor *classDescription = [[CASStyler defaultStyler] objectClassDescriptorForClass:[LFSliderPackView class]];

    CASArgumentDescriptor *colorArg = [CASArgumentDescriptor argWithClass:[UIColor class]];
    NSDictionary *controlStateMap = @{
        @"normal" : @(UIControlStateNormal),
        @"highlighted" : @(UIControlStateHighlighted),
        @"disabled" : @(UIControlStateDisabled),
        @"selected" : @(UIControlStateSelected),
    };
    CASArgumentDescriptor *stateArg = [CASArgumentDescriptor argWithName:@"state" valuesByName:controlStateMap];
    
    [classDescription setArgumentDescriptors:@[colorArg, stateArg]
                                      setter:@selector(setMaximumTrackColor:forState:)
                              forPropertyKey:@"maxTrackColor"];
    
    [classDescription setArgumentDescriptors:@[colorArg, stateArg]
                                      setter:@selector(setMinimumTrackColor:forState:)
                              forPropertyKey:@"minTrackColor"];
}

@end

//
//  LFKeyboardViewModel.m
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

#import "LFKeyboardViewModel.h"

#import "LFSynthController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LFKeyboardViewModel ()

@property (assign, nonatomic, readwrite) BOOL hold;

@end

@implementation LFKeyboardViewModel

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _holdToggleSignal = RACObserve(self, hold);
    _holdTitleSignal = [_holdToggleSignal map:^NSString *(NSNumber* value) {
        return [value boolValue] ? @"HOLD'N" : @"HOLD";
    }];
    
    @weakify(self);
    _holdToggleWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self setHold:![self hold]];
        if (!self.hold) [[LFSynthController sharedController] holdOff];
        return [RACSignal empty];
    }];
    
    return self;
}

@end

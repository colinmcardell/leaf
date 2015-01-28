//
//  LFDelayViewModel.m
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

#import "LFDelayViewModel.h"

#import <libextobjc/EXTKeyPathCoding.h>
#import "LFSynthController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation LFDelayViewModel

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _title = @"Delay";
    
    LFSynthController *synthController = [LFSynthController sharedController];
    
    // Delay Toggle
    _delayToggleSignal = RACObserve(synthController, delayEnabled);
    _delayToggleTitleSignal = [_delayToggleSignal map:^NSString *(NSNumber *value) {
        return [value boolValue] ? @"ON" : @"OFF";
    }];
    
    _delayToggleWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [synthController setDelayEnabled:@(![[synthController delayEnabled] boolValue])];
        return [RACSignal return:[synthController delayEnabled]];
    }];
    
    // Delay Sync Toggle
    _syncToggleSignal = RACObserve(synthController, delaySync);
    _syncToggleTitleSignal = [_syncToggleSignal map:^NSString *(NSNumber *value) {
        return [value boolValue] ? @"SYNC'D" : @"SYNC";
    }];
    
    _syncToggleWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [synthController setDelaySync:@(![[synthController delaySync] boolValue])];
        return [RACSignal return:[synthController delaySync]];
    }];
    
    return self;
}

@end

//
//  LFOscRangeViewModel.m
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

#import "LFOscRangeViewModel.h"

#import <libextobjc/EXTKeyPathCoding.h>
#import "LFSynthController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation LFOscRangeViewModel

+ (LFOscRangeViewModel *)osc1RangeViewModel
{
    return [[self alloc] initWithRangeKeyPath:@keypath([LFSynthController sharedController].osc1Range)];
}

+ (LFOscRangeViewModel *)osc2RangeViewModel
{
    return [[self alloc] initWithRangeKeyPath:@keypath([LFSynthController sharedController].osc2Range)];
}

- (instancetype)initWithRangeKeyPath:(NSString *)keyPath
{
    self = [self init];
    if (!self) return nil;
    
    _title = @"Range";
    
    LFSynthController *synthController = [LFSynthController sharedController];
    
    RACKVOChannel *synthRangeChannel = [[RACKVOChannel alloc] initWithTarget:synthController keyPath:keyPath nilValue:nil];
    
    RACChannelTo(self, range) = [synthRangeChannel followingTerminal];
    
    _rangeSignal = [synthController rac_valuesForKeyPath:keyPath observer:self];
    
    _rangeValueChangedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [synthController setValue:value forKey:keyPath];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    return self;
}

@end

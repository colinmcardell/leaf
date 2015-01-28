//
//  LFPatternViewModel.m
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

#import "LFPatternViewModel.h"

#import "LFSynthController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LFPatternViewModel ()

@property (strong, nonatomic) RACSignal *patternClockDivisionSignal;

@end

@implementation LFPatternViewModel

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _title = @"Pattern";
    
    LFSynthController *synthController = [LFSynthController sharedController];
    
    _patternToggleSignal = RACObserve(synthController, arpEnabled);
    _patternTitleSignal = [_patternToggleSignal map:^NSString *(NSNumber* value) {
        return [value boolValue] ? @"ON" : @"OFF";
    }];
    
    _patternToggleWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [synthController holdOff];
        [synthController setArpEnabled:@(![[synthController arpEnabled] boolValue])];
        return [RACSignal return:[synthController arpEnabled]];
    }];
    
    _patternClockDivisionSignal = RACObserve(synthController, arpClockDivision);
    
    _halfSelected = [_patternClockDivisionSignal map:^id(NSNumber *clockDivision) {
        return [clockDivision floatValue] == kNoteHalf ? @YES : @NO;
    }];
    _halfWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [synthController setArpClockDivision:@(kNoteHalf)];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    _quarterSelected = [_patternClockDivisionSignal map:^id(NSNumber *clockDivision) {
        return [clockDivision floatValue] == kNoteQuarter ? @YES : @NO;
    }];
    _quarterWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [synthController setArpClockDivision:@(kNoteQuarter)];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    _eighthSelected = [_patternClockDivisionSignal map:^id(NSNumber *clockDivision) {
        return [clockDivision floatValue] == kNoteEighth ? @YES : @NO;
    }];
    _eighthWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [synthController setArpClockDivision:@(kNoteEighth)];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    _sixteenthSelected = [_patternClockDivisionSignal map:^id(NSNumber *clockDivision) {
        return [clockDivision floatValue] == kNoteSixteenth ? @YES : @NO;
    }];
    _sixteenthWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [synthController setArpClockDivision:@(kNoteSixteenth)];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    return self;
}

@end

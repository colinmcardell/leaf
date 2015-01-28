//
//  LFOscWaveViewModel.m
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

#import "LFOscWaveViewModel.h"

#import <libextobjc/EXTKeyPathCoding.h>
#import "LFSynthController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LFOscWaveViewModel ()

@property (strong, nonatomic) RACSignal *waveformSignal;

@end

@implementation LFOscWaveViewModel

+ (LFOscWaveViewModel *)osc1WaveViewModel
{
    LFSynthController *synthController = [LFSynthController sharedController];
    LFOscWaveViewModel *viewModel = [[self alloc] initWithWaveformKeyPath:@keypath(synthController.osc1Waveform)];
    
    return viewModel;
}

+ (LFOscWaveViewModel *)osc2WaveViewModel
{
    LFSynthController *synthController = [LFSynthController sharedController];
    LFOscWaveViewModel *viewModel = [[self alloc] initWithWaveformKeyPath:@keypath(synthController.osc2Waveform)];
    
    return viewModel;
}

- (instancetype)initWithWaveformKeyPath:(NSString *)keyPath
{
    self = [self init];
    if (!self) return nil;
    
    LFSynthController *synthController = [LFSynthController sharedController];
    
    _waveformSignal = [synthController rac_valuesForKeyPath:keyPath observer:self];
    
    _sineSelected = [_waveformSignal map:^id(NSNumber *waveform) {
        return [waveform integerValue] == LFSynthWaveformSine ? @YES : @NO;
    }];
    
    _sineWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [synthController setValue:@(LFSynthWaveformSine) forKey:keyPath];
            [subscriber sendCompleted];
            return nil;
        }];
    }];

    _sawSelected = [_waveformSignal map:^id(NSNumber *waveform) {
        return [waveform integerValue] == LFSynthWaveformSaw ? @YES : @NO;
    }];
    
    _sawWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [synthController setValue:@(LFSynthWaveformSaw) forKey:keyPath];
            [subscriber sendCompleted];
            return nil;
        }];
    }];

    _squareSelected = [_waveformSignal map:^id(NSNumber *waveform) {
        return [waveform integerValue] == LFSynthWaveformSquare ? @YES : @NO;
    }];
    
    _squareWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [synthController setValue:@(LFSynthWaveformSquare) forKey:keyPath];
            [subscriber sendCompleted];
            return nil;
        }];
    }];

    _triangleSelected = [_waveformSignal map:^id(NSNumber *waveform) {
        return [waveform integerValue] == LFSynthWaveformTriangle ? @YES : @NO;
    }];
    
    _triangleWasSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [synthController setValue:@(LFSynthWaveformTriangle) forKey:keyPath];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    return self;
}

@end

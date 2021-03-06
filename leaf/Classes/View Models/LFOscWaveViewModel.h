//
//  LFOscWaveViewModel.h
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

#import "RVMViewModel.h"

@class RACCommand;

@interface LFOscWaveViewModel : RVMViewModel

+ (LFOscWaveViewModel *)osc1WaveViewModel;
+ (LFOscWaveViewModel *)osc2WaveViewModel;

@property (strong, nonatomic, readonly) RACSignal *sineSelected;
@property (strong, nonatomic, readonly) RACCommand *sineWasSelectedCommand;

@property (strong, nonatomic, readonly) RACSignal *sawSelected;
@property (strong, nonatomic, readonly) RACCommand *sawWasSelectedCommand;

@property (strong, nonatomic, readonly) RACSignal *squareSelected;
@property (strong, nonatomic, readonly) RACCommand *squareWasSelectedCommand;

@property (strong, nonatomic, readonly) RACSignal *triangleSelected;
@property (strong, nonatomic, readonly) RACCommand *triangleWasSelectedCommand;

@end

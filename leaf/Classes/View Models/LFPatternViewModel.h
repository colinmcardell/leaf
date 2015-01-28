//
//  LFPatternViewModel.h
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

@interface LFPatternViewModel : RVMViewModel

@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) RACSignal *patternToggleSignal;
@property (strong, nonatomic, readonly) RACSignal *patternTitleSignal;
@property (strong, nonatomic, readonly) RACCommand *patternToggleWasSelectedCommand;

@property (strong, nonatomic, readonly) RACSignal *halfSelected;
@property (strong, nonatomic, readonly) RACCommand *halfWasSelectedCommand;

@property (strong, nonatomic, readonly) RACSignal *quarterSelected;
@property (strong, nonatomic, readonly) RACCommand *quarterWasSelectedCommand;

@property (strong, nonatomic, readonly) RACSignal *eighthSelected;
@property (strong, nonatomic, readonly) RACCommand *eighthWasSelectedCommand;

@property (strong, nonatomic, readonly) RACSignal *sixteenthSelected;
@property (strong, nonatomic, readonly) RACCommand *sixteenthWasSelectedCommand;

@end

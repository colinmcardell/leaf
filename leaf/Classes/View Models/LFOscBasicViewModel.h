//
//  LFOscBasicViewModel.h
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

#import "LFSliderPackViewModel.h"

@interface LFOscBasicViewModel : LFSliderPackViewModel

+ (LFOscBasicViewModel *)osc1BasicViewModel;
+ (LFOscBasicViewModel *)osc2BasicViewModel;

@property (strong, nonatomic) NSNumber *clipMix;
@property (strong, nonatomic) NSNumber *clipDrive;
@property (strong, nonatomic) NSNumber *frequency;
@property (strong, nonatomic) NSNumber *volume;

@end

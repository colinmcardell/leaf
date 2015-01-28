//
//  LFStepper.h
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

#import <UIKit/UIKit.h>

@interface LFStepper : UIControl

@property (strong, nonatomic) UIColor *normalBackgroundColor;
@property (strong, nonatomic) UIColor *highlightedBackgroundColor;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;
@property (assign, nonatomic) CGFloat maximumValue;                 // default 100. must be greater than minimumValue
@property (assign, nonatomic) CGFloat minimumValue;                 // default 0. must be less than maximumValue
@property (assign, nonatomic) CGFloat stepValue;                    // default 1. must be greater than 0
@property (assign, nonatomic) CGFloat value;                        // default is 0. sends UIControlEventValueChanged. clamped to min/max
@property (assign, nonatomic) BOOL vertical;                        // default YES. defines button orientation, either horizontal (left/right), or vertical (top/bottom)

@end

@class RACChannelTerminal;

@interface LFStepper (RACCommandSupport)

/// Creates a new RACChannel-based binding to the receiver.
///
/// nilValue - The value to set when the terminal receives `nil`.
///
/// Returns a RACChannelTerminal that sends the receiver's value whenever the
/// UIControlEventValueChanged control event is fired, and sets the value to the
/// values it receives.
- (RACChannelTerminal *)rac_newValueChannelWithNilValue:(NSNumber *)nilValue;

@end

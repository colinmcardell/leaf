//
//  LFStepper.m
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

#import "LFStepper.h"
#import <QuartzCore/QuartzCore.h>
#import <UIImage+Additions/UIImage+Additions.h>

@interface LFStepper ()

@property (strong, nonatomic) UIButton *decrementButton;
@property (strong, nonatomic) UIButton *incrementButton;
@property (strong, nonatomic) UILabel *indicatorLabel;

@end

@implementation LFStepper

#define GENERATE_SETTER(PROPERTY, TYPE, SETTER, UPDATER) \
- (void)SETTER:(TYPE)PROPERTY \
{ \
    if (_##PROPERTY != PROPERTY) { \
        _##PROPERTY = PROPERTY; \
        UPDATER; \
    } \
}

#define CLAMP(x, low, high) ({ \
    __typeof__(x) __x = (x); \
    __typeof__(low) __low = (low); \
    __typeof__(high) __high = (high); \
    __x > __high ? __high : (__x < __low ? __low : __x); \
})

GENERATE_SETTER(normalBackgroundColor, UIColor*, setNormalBackgroundColor, [self redrawElements])
GENERATE_SETTER(highlightedBackgroundColor, UIColor*, setHighlightedBackgroundColor, [self redrawElements])
GENERATE_SETTER(selectedBackgroundColor, UIColor*, setSelectedBackgroundColor, [self redrawElements])
GENERATE_SETTER(maximumValue, CGFloat, setMaximumValue, [self updateValues])
GENERATE_SETTER(minimumValue, CGFloat, setMinimumValue, [self updateValues])
GENERATE_SETTER(value, CGFloat, setValue, [self updateValues])

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    [self setup];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setup];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = [self bounds];
    CGFloat elementWidth;
    CGFloat elementHeight;

    // Define Element width/height
    {
        CGFloat width = CGRectGetWidth(bounds);
        CGFloat height = CGRectGetHeight(bounds);
        elementWidth = self.vertical ? width : width / 3;
        elementHeight = self.vertical ? height / 3 : height;
    }
    
    // Define Element base rect (centered within bounds)
    CGRect elementRect = ({
        CGFloat insetX = self.vertical ? 0 : elementWidth;
        CGFloat insetY = self.vertical ? elementHeight : 0;
        CGRect rect = CGRectInset(bounds, insetX, insetY);
        CGRectIntegral(rect);
    });
    
    [self.decrementButton setFrame:({
        CGRect frame = elementRect;
        CGFloat offsetX = self.vertical ? 0 : -elementWidth;
        CGFloat offsetY = self.vertical ? elementHeight : 0;
        frame = CGRectOffset(frame, offsetX, offsetY);
        CGRectIntegral(frame);
    })];
    
    [self.indicatorLabel setFrame:elementRect];
    
    [self.incrementButton setFrame:({
        CGRect frame = elementRect;
        CGFloat offsetX = self.vertical ? 0 : elementWidth;
        CGFloat offsetY = self.vertical ? -elementHeight : 0;
        frame = CGRectOffset(frame, offsetX, offsetY);
        CGRectIntegral(frame);
    })];
}

#pragma mark - Private Methods

- (void)setup
{
    [self setClipsToBounds:YES];
    _normalBackgroundColor = [UIColor orangeColor];
    _highlightedBackgroundColor = [UIColor yellowColor];
    _selectedBackgroundColor = [UIColor whiteColor];
    _maximumValue = 100.0f;
    _minimumValue = 0.0f;
    _stepValue = 1.0f;
    _value = 0.0f;
    _vertical = YES;
    
    // Decrement
    {
        _decrementButton = [UIButton new];
        [_decrementButton setTitle:@"-" forState:UIControlStateNormal];
        [_decrementButton addTarget:self action:@selector(decrementValue) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_decrementButton];
    }
    
    // Indicator Label
    {
        _indicatorLabel = [UILabel new];
        [_indicatorLabel setText:@""];
        [self addSubview:_indicatorLabel];
    }
    
    // Increment
    {
        _incrementButton = [UIButton new];
        [_incrementButton setTitle:@"+" forState:UIControlStateNormal];
        [_incrementButton addTarget:self action:@selector(incrementValue) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_incrementButton];
    }
    
    [self updateValues];
    [self redrawElements];
}

- (void)incrementValue
{
    [self setValue:[self value] + [self stepValue]];
}

- (void)decrementValue
{
    [self setValue:[self value] - [self stepValue]];
}

// Call when value properties change
- (void)updateValues
{
    CGFloat currentValue = _value;
    _value = CLAMP(currentValue, _minimumValue, _maximumValue);
    
    [_indicatorLabel setText:[NSString stringWithFormat:@"%.f", _value]];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

// Call when update to control's layout is needed
- (void)setLayerFrames
{

}

// Call when update to control's visuals is needed
- (void)redrawElements
{
    // Normal State Background Image
    {
        UIImage *backgroundImage = [UIImage imageWithColor:[self normalBackgroundColor]];
        [self.decrementButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self.incrementButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    
    // Highlighted State Background Image
    {
        UIImage *backgroundImage = [UIImage imageWithColor:[self highlightedBackgroundColor]];
        [self.decrementButton setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
        [self.incrementButton setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
    }
    
    // Selected State Background Image
    {
        UIImage *backgroundImage = [UIImage imageWithColor:[self selectedBackgroundColor]];
        [self.decrementButton setBackgroundImage:backgroundImage forState:UIControlStateSelected];
        [self.incrementButton setBackgroundImage:backgroundImage forState:UIControlStateSelected];
    }
}

@end

#import "RACEXTKeyPathCoding.h"
#import "UIControl+RACSignalSupportPrivate.h"

@implementation LFStepper (RACCommandSupport)

- (RACChannelTerminal *)rac_newValueChannelWithNilValue:(NSNumber *)nilValue
{
    return [self rac_channelForControlEvents:UIControlEventValueChanged key:@keypath(self.value) nilValue:nilValue];;
}

@end

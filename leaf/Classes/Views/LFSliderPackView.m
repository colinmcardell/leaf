//
//  LFSliderPackView.m
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

#import "LFSliderPackView.h"
#import "LFSliderPackView+CASAdditions.h"

#import <UIImage+Additions/UIImage+Additions.h>

#import <objc/runtime.h>

#define kPadding 10.0f

@interface LFSliderPackView ()

@property (strong, nonatomic, readwrite) NSMutableArray *sliders;
@property (strong, nonatomic, readwrite) NSMutableArray *labels;

@end

@implementation LFSliderPackView

#pragma mark - Lifecycle

- (instancetype)initWithNumberOfSliders:(NSUInteger)numberOfSliders
{
    self = [self init];
    if (!self) return nil;
    
    [self setTitleLabel:[UILabel new]];
    [self addSubview:[self titleLabel]];
    
    _sliders = [NSMutableArray arrayWithCapacity:numberOfSliders];
    _labels = [NSMutableArray arrayWithCapacity:numberOfSliders];
    
    for (int i = 0; i < numberOfSliders; i++) {
        UISlider *slider = [UISlider new];
        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
        slider.transform = trans;
        
        UILabel *label = [UILabel new];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByCharWrapping];
        
        [_sliders addObject:slider];
        [self addSubview:slider];
        
        [_labels addObject:label];
        [self addSubview:label];
    }
    
    [self setMinimumTrackColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self setMaximumTrackColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self setSliderThumbColor:[UIColor blackColor]];
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat totalWidth = self.bounds.size.width;
    CGFloat titleLabelHeight = 0.0f;
    if ([self.titleLabel.text length]) {
        titleLabelHeight = 20.0f;
        CGRect titleLabelFrame = CGRectMake(kPadding, kPadding, (totalWidth - (kPadding * 2.0f)), titleLabelHeight);
        titleLabelFrame = CGRectIntegral(titleLabelFrame);
        [self.titleLabel setFrame:titleLabelFrame];
    }
    
    CGFloat elementHeight = self.bounds.size.height;
    NSUInteger paddingMultiplier = titleLabelHeight ? 3 : 2;
    elementHeight -= (kPadding * paddingMultiplier + titleLabelHeight);
    
    NSUInteger number = [self.sliders count];
    CGFloat totalPaddingWidth = kPadding * ((number - 1.0f) + 2.0f);
    CGFloat totalElementWidth = totalWidth - totalPaddingWidth;
    CGFloat elementWidth = totalElementWidth / number;
    
    CGFloat xOffset = kPadding;
    
    CGFloat yOffset = (titleLabelHeight ? kPadding * 2.0f : kPadding) + titleLabelHeight;
    for (int j = 0; j < number; j++) {
        CGRect frame = CGRectMake(xOffset, yOffset, elementWidth, elementHeight);
        frame = CGRectIntegral(frame);
        xOffset = CGRectGetMaxX(frame) + kPadding;
        
        UISlider *slider = [self.sliders objectAtIndex:j];
        [slider setFrame:frame];
        UILabel *label = [self.labels objectAtIndex:j];
        [label setFrame:frame];
    }
}

#pragma mark - Setters

- (void)setSliderThumbColor:(UIColor *)sliderThumbColor
{
    _sliderThumbColor = sliderThumbColor;
    UIImage *sliderThumbImage = [UIImage imageWithColor:sliderThumbColor size:CGSizeMake(26, 26)];
    for (UISlider *slider in [self sliders]) {
        [slider setThumbImage:sliderThumbImage forState:UIControlStateNormal];
        [slider setThumbImage:sliderThumbImage forState:UIControlStateHighlighted];
    }
}

- (void)setMinimumTrackColor:(UIColor *)color forState:(UIControlState)state
{
    UIImage *sliderMinTrackImage = [UIImage imageWithColor:color size:CGSizeMake(14, 14)];
    for (UISlider *slider in [self sliders]) {
        [slider setMinimumTrackImage:sliderMinTrackImage forState:state];
    }
}

- (void)setMaximumTrackColor:(UIColor *)color forState:(UIControlState)state
{
    UIImage *sliderMaxTrackImage = [UIImage imageWithColor:color size:CGSizeMake(14, 14)];
    for (UISlider *slider in [self sliders]) {
        [slider setMaximumTrackImage:sliderMaxTrackImage forState:state];
    }
}

#pragma mark -

- (void)setSliderLabelsTitles:(NSArray *)titles
{
    for (UILabel *label in [self labels]) {
        NSInteger index = [self.labels indexOfObject:label];
        NSString *text = [titles objectAtIndex:index];
        
        // Creating vertical text label
        // Split string into characters and concat with new line between each character
        NSMutableArray *characters = [NSMutableArray arrayWithCapacity:[text length]];
        for (int i = 0; i < [text length]; i++) {
            NSString *character = [NSString stringWithFormat:@"%c", [text characterAtIndex:i]];
            [characters addObject:character];
        }
        NSString *labelText = [[characters componentsJoinedByString:@"\n"] uppercaseString];
        [label setText:labelText];
    }
}

@end

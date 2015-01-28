//
//  LFButton.m
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

#import "LFButton.h"
#import "UIImage+Leaf.h"

#import <UIImage+Additions/UIImage+Additions.h>

@implementation LFButton

+ (LFButton *)sineButton
{
    LFButton *button = [LFButton new];
    UIImage *sine = [UIImage sineImageWithColor:[UIColor whiteColor]];
    [button setImage:sine forState:UIControlStateNormal];
    [button setImage:sine forState:UIControlStateHighlighted];
    return button;
}

+ (LFButton *)sawButton
{
    LFButton *button = [LFButton new];
    UIImage *saw = [UIImage sawImageWithColor:[UIColor whiteColor]];
    [button setImage:saw forState:UIControlStateNormal];
    [button setImage:saw forState:UIControlStateHighlighted];
    return button;
}

+ (LFButton *)squareButton
{
    LFButton *button = [LFButton new];
    UIImage *square = [UIImage squareImageWithColor:[UIColor whiteColor]];
    [button setImage:square forState:UIControlStateNormal];
    [button setImage:square forState:UIControlStateHighlighted];
    return button;
}

+ (LFButton *)triangleButton
{
    LFButton *button = [LFButton new];
    UIImage *triangle = [UIImage triangleImageWithColor:[UIColor whiteColor]];
    [button setImage:triangle forState:UIControlStateNormal];
    [button setImage:triangle forState:UIControlStateHighlighted];
    return button;
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor
{
    _normalBackgroundColor = normalBackgroundColor;
    [self setBackgroundImage:[UIImage imageWithColor:_normalBackgroundColor size:CGSizeMake(10.0f, 10.0f)]
                    forState:UIControlStateNormal];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    _highlightedBackgroundColor = highlightedBackgroundColor;
    [self setBackgroundImage:[UIImage imageWithColor:_highlightedBackgroundColor size:CGSizeMake(10.0f, 10.0f)]
                    forState:UIControlStateHighlighted];
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    _selectedBackgroundColor = selectedBackgroundColor;
    [self setBackgroundImage:[UIImage imageWithColor:_selectedBackgroundColor size:CGSizeMake(10.0f, 10.0f)]
                    forState:UIControlStateSelected];
}

@end

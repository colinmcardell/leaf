//
//  LFKeyView.m
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

#import "LFKeyView.h"

@interface LFKeyView ()

@property (assign, nonatomic) NSUInteger keyNumber;
@property (assign, nonatomic, readwrite) BOOL keyPressed;

@end

@implementation LFKeyView

+ (LFKeyView *)keyViewWithKeyNumber:(NSUInteger)keyNumber
{
    return [[self alloc] initWithKeyNumber:keyNumber];
}

- (instancetype)initWithKeyNumber:(NSUInteger)keyNumber
{
    self = [super init];
    if (!self) return nil;
    
    [self setMultipleTouchEnabled:YES];
    
    _keyNumber = keyNumber;
    _keyPressed = NO;
    _octave = 1;
    
    return self;
}

- (NSUInteger)keyNumberValue
{
    NSUInteger value = ((([self keyNumber] + 1) + ([self octave] * 12)) - 1);
    return value;
}

- (void)keyDown
{
    if (![self keyPressed]) {
        [self setKeyPressed:YES];
        [self setNeedsDisplay];
    }
}

- (void)keyUp
{
    if ([self keyPressed]) {
        [self setKeyPressed:NO];
        [self setNeedsDisplay];
    }
}

@end

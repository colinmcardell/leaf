//
//  LFKeyboardOctaveView.m
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

#import "LFKeyboardOctaveView.h"
#import "LFKeyView.h"

#define kBlackKeyOffset 0.5

static const int kKeysPerOctave = 12;

static const int kWhiteKeyNumbers[] = { 0, 2, 4, 5, 7, 9, 11 };
static const int kWhiteKeyCount = sizeof(kWhiteKeyNumbers) / sizeof(int);
static const int kBlackKey1Numbers[] = { 1, 3 };
static const int kBlackKey1Count = sizeof(kBlackKey1Numbers) / sizeof(int);
static const int kBlackKey2Numbers[] = { 6, 8, 10 };
static const int kBlackKey2Count = sizeof(kBlackKey2Numbers) / sizeof(int);

@interface LFKeyboardOctaveView ()

@property (strong, nonatomic) NSMutableArray *whiteKeys;
@property (strong, nonatomic) NSMutableArray *blackKeys;

@end

@implementation LFKeyboardOctaveView

- (instancetype)initWithCNoteValue:(NSUInteger)cNote
{
    self = [super init];
    if (!self) return nil;
    
    // White Keys
    {
        _whiteKeys = [NSMutableArray arrayWithCapacity:kWhiteKeyCount];
        
        UIColor *whiteColor = [UIColor colorWithRed:236.0f/255.0f green:240.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
        for (int i = 0; i < kWhiteKeyCount; i++) {
            LFKeyView *key = [LFKeyView keyViewWithKeyNumber:cNote + kWhiteKeyNumbers[i]];
            [key setBackgroundColor:whiteColor];
            [self addSubview:key];
            [_whiteKeys addObject:key];
        }
    }
    
    // Black Keys
    {
        _blackKeys = [NSMutableArray arrayWithCapacity:(kBlackKey1Count + kBlackKey2Count)];
        
        for (int i = 0; i < kBlackKey1Count; i++) {
            LFKeyView *key = [LFKeyView keyViewWithKeyNumber:cNote + kBlackKey1Numbers[i]];
            [key setBackgroundColor:[UIColor blackColor]];
            [self addSubview:key];
            [_blackKeys addObject:key];
        }
        
        for (int i = 0; i < kBlackKey2Count; i++) {
            LFKeyView *key = [LFKeyView keyViewWithKeyNumber:cNote + kBlackKey2Numbers[i]];
            [key setBackgroundColor:[UIColor blackColor]];
            [self addSubview:key];
            [_blackKeys addObject:key];
        }
    }
    
    return self;
}

- (BOOL)isOpaque
{
    return YES;
}

- (NSUInteger)keyCount
{
    return kKeysPerOctave;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = [self bounds];
    
    CGRect keyFrame;
    keyFrame.origin.y = 0;
    keyFrame.size.width = bounds.size.width / kWhiteKeyCount;
    keyFrame.size.height = bounds.size.height;
    
    for (int i = 0; i < [self.whiteKeys count]; i++) {
        keyFrame.origin.x = i * keyFrame.size.width;
        LFKeyView *view = [self.whiteKeys objectAtIndex:i];
        [view setFrame:keyFrame];
    }
    
    keyFrame.origin.x = kBlackKeyOffset * keyFrame.size.width;
    keyFrame.size.height = 0.62 * bounds.size.height;
    for (int i = 0; i < [self.blackKeys count]; i++) {
        if (i == 2) keyFrame.origin.x += keyFrame.size.width;
        LFKeyView *view = [self.blackKeys objectAtIndex:i];
        [view setFrame:keyFrame];
        keyFrame.origin.x += keyFrame.size.width;
    }
}

@end

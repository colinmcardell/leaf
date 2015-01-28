//
//  LFKeyboardView.m
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
//  A tip of the hat to KeyboardView from mobilesynth
//  by Allen Porter which LFKeyboardView is roughly based on.
//

#import "LFKeyboardView.h"
#import "LFKeyView.h"
#import "LFKeyboardOctaveView.h"

@interface LFKeyDownInfo : NSObject

@property (strong, nonatomic) UITouch *touch;
@property (strong, nonatomic) LFKeyView *key;

@end

@interface LFKeyboardView ()

@property (weak, nonatomic) id <LFKeyboardDelegate> delegate;
@property (strong, nonatomic) NSMutableSet *keyDownSet;
@property (strong, nonatomic) NSMutableArray *octaveViews;

@end

static const int kLowC = 12;

@implementation LFKeyboardView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self setAutoresizesSubviews:YES];
    _currentOctave = 2;
    _currentTranspose = 0;
    
    _keyDownSet = [NSMutableSet new];
    
    return self;
}

- (instancetype)initWithOctaveCount:(NSUInteger)octaveCount
{
    self = [self init];
    if (!self) return nil;
    
    _octaveViews = [NSMutableArray arrayWithCapacity:octaveCount];
    
    int key = kLowC;
    for (int i = 0; i < octaveCount; i++) {
        LFKeyboardOctaveView *octaveView = [[LFKeyboardOctaveView alloc] initWithCNoteValue:key];
        [_octaveViews addObject:octaveView];
        [self addSubview:octaveView];
        key += [octaveView keyCount];
    }
    
    return self;
}

- (instancetype)initWithDelegate:(id <LFKeyboardDelegate>)delegate
{
    self = [self initWithOctaveCount:2];
    if (!self) return nil;
    _delegate = delegate;
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = [self bounds];
    
    NSUInteger count = [self.octaveViews count];
    CGRect octaveFrame;
    octaveFrame.origin.y = 0;
    octaveFrame.size.width = bounds.size.width / count;
    octaveFrame.size.height = bounds.size.height;
    
    for (int i = 0; i < count; i++) {
        LFKeyboardOctaveView *view = [self.octaveViews objectAtIndex:i];
        octaveFrame.origin.x = i * octaveFrame.size.width;
        [view setFrame:octaveFrame];
    }
}

- (LFKeyDownInfo *)findKeyDownInfoFromTouch:(UITouch *)touch
{
    LFKeyDownInfo *downInfo = nil;
    for (LFKeyDownInfo *keyDownInfo in [self.keyDownSet allObjects]) {
        if ([keyDownInfo touch] == touch) {
            downInfo = keyDownInfo;
            break;
        }
    }
    return downInfo;
}

- (LFKeyView *)keyViewForTouch:(UITouch*)touch withEvent:(UIEvent *)event
{
    CGPoint point = [touch locationInView:self];
    LFKeyView *keyView = (LFKeyView *)[self hitTest:point withEvent:event];
    [keyView setOctave:[self currentOctave]];
    return keyView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        LFKeyDownInfo *keyDownInfo = [self findKeyDownInfoFromTouch:touch];
        if (keyDownInfo) continue;
        
        LFKeyView *keyView = [self keyViewForTouch:touch withEvent:event];
        if (!keyView) continue;
        
        [keyView keyDown];
        if ([self.delegate respondsToSelector:@selector(noteOn:)]) {
            [self.delegate noteOn:([keyView keyNumberValue] + [self currentTranspose])];
        }
        
        keyDownInfo = [[LFKeyDownInfo alloc] init];
        [keyDownInfo setTouch:touch];
        [keyDownInfo setKey:keyView];
        [self.keyDownSet addObject:keyDownInfo];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        LFKeyDownInfo *keyDownInfo = [self findKeyDownInfoFromTouch:touch];
        if (!keyDownInfo) continue;
        
        LFKeyView *keyView = [self keyViewForTouch:touch withEvent:event];
        if ([keyDownInfo key] == keyView || !keyView) continue;
        
        [keyView keyDown];
        if ([self.delegate respondsToSelector:@selector(noteOn:)]) {
            [self.delegate noteOn:([keyView keyNumberValue] + [self currentTranspose])];
        }
        
        LFKeyView *previousKeyView = [keyDownInfo key];
        [previousKeyView keyUp];
        if ([self.delegate respondsToSelector:@selector(noteOff:)]) {
            [self.delegate noteOff:([previousKeyView keyNumberValue] + [self currentTranspose])];
        }
        
        [keyDownInfo setKey:keyView];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        LFKeyDownInfo *keyDownInfo = [self findKeyDownInfoFromTouch:touch];
        if (!keyDownInfo) continue;
        
        [self.keyDownSet removeObject:keyDownInfo];
        
        LFKeyView *previousKeyView = [keyDownInfo key];
        [previousKeyView keyUp];
        
        if ([self.keyDownSet count] > 0) {
            NSArray *array = [self.keyDownSet allObjects];
            LFKeyView *lastNote = (LFKeyView *)[array.lastObject key];
            if (([keyDownInfo.key keyNumberValue] + [self currentTranspose]) != ([lastNote keyNumberValue] + [self currentTranspose])) {
                if ([self.delegate respondsToSelector:@selector(noteOn:)]) {
                    [self.delegate noteOn:([lastNote keyNumberValue] + [self currentTranspose])];
                }
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(noteOff:)]) {
            [self.delegate noteOff:([previousKeyView keyNumberValue] + [self currentTranspose])];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

@end

@implementation LFKeyDownInfo

@end

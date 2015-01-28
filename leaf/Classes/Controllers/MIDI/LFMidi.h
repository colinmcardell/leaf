//
//  LFMidi.h
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
//  Taking some implementation style and cues from Midi.m/h from PdParty
//  https://github.com/danomatika/PdParty
//

#import <Foundation/Foundation.h>

@protocol LFMidiDelegate <NSObject>
@optional
- (void)midiInputConnectionEvent;
- (void)midiOutputConnectionEvent;

- (void)midiNote:(int)pitch velocity:(int)velocity channel:(int)channel;
- (void)midiControlChange:(int)controller value:(int)value channel:(int)channel;
- (void)midiProgramChange:(int)value channel:(int)channel;
- (void)midiPitchBend:(int)value channel:(int)channel;
- (void)midiAftertouch:(int)value channel:(int)channel;
- (void)midiPolyAftertouch:(int)value pitch:(int)pitch channel:(int)channel;
- (void)midiSysexData:(int)byte channel:(int)channel;

@end

@interface LFMidi : NSObject

@property (assign, nonatomic) id<LFMidiDelegate> delegate;

@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (assign, nonatomic, getter=isNetworkEnabled) BOOL networkEnabled;

@property (assign, nonatomic, getter=isVirtualInputEnabled) BOOL virtualInputEnabled;
@property (assign, nonatomic, getter=isVirtualOutputEnabled) BOOL virtualOutputEnabled;

@property (weak, nonatomic, readonly) NSArray *inputs;
@property (weak, nonatomic, readonly) NSArray *outputs;

@property (assign, nonatomic, getter=shouldIgnoreSysex) BOOL ignoreSysex;
@property (assign, nonatomic, getter=shouldIgnoreTiming) BOOL ignoreTiming;
@property (assign, nonatomic, getter=shouldIgnoreSense) BOOL ignoreSense;

@end

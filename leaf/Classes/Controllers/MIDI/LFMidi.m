//
//  LFMidi.m
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

#import "LFMidi.h"
#import "LFLogger.h"
#import <mach/mach_time.h>
#import <PGMidi/PGMidi.h>

typedef NS_ENUM(NSInteger, LFMidiStatus) {
    LFMidiStatusNoteOff             = 0x80,
    LFMidiStatusNoteOn              = 0x90,
    LFMidiStatusControlChange       = 0xB0,
    LFMidiStatusProgramChange       = 0xC0,
    LFMidiStatusPitchBend           = 0xE0,
    LFMidiStatusAftertouch          = 0xD0,
    LFMidiStatusPolyAftertouch      = 0xA0,
    LFMidiStatusSysex               = 0xF0,
    LFMidiStatusTimeCode            = 0xF1,
    LFMidiStatusSongPositionPointer = 0xF2,
    LFMidiStatusSongSelect          = 0xF3,
    LFMidiStatusTuneRequest         = 0xF6,
    LFMidiStatusSysexEnd            = 0xF7,
    LFMidiStatusTimeClock           = 0xF8,
    LFMidiStatusStart               = 0xFA,
    LFMidiStatusContinue            = 0xFB,
    LFMidiStatusStop                = 0xFC,
    LFMidiStatusActiveSensing       = 0xFE,
    LFMidiStatusSystemReset         = 0xFF
};

uint64_t absoluteToNanos(uint64_t time)
{
    const int64_t kOneThousand = 1000;
    static mach_timebase_info_data_t s_timebase_info;
    // Only init s_timebase_info once
    if (s_timebase_info.denom == 0) {
        (void)mach_timebase_info(&s_timebase_info);
    }
    
    return (uint64_t)((time * s_timebase_info.numer) / (kOneThousand * s_timebase_info.denom));
}

@interface LFMidi () <PGMidiDelegate, PGMidiSourceDelegate> {
    BOOL _continueSysex;
    BOOL _firstPacket;
    MIDITimeStamp _lastTime;
    MIDITimeStamp _currentTime;
    NSMutableData *_messageIn;
    NSMutableData *_messageOut;
}

+ (NSDictionary *)_statusMessageSizeMap;
- (NSInteger)_sizeOfStatus:(LFMidiStatus)status;

@property (strong, nonatomic) PGMidi *midi;

@end

@implementation LFMidi

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    // Defaults
    {
        _continueSysex = NO;
        _firstPacket = YES;
        _lastTime = 0;
        
        _ignoreSysex = NO;
        _ignoreSense = YES;
        _ignoreTiming = YES;
        
        _messageIn = [[NSMutableData alloc] init];
        _messageOut = [[NSMutableData alloc] init];
        
        _enabled = YES;
        _networkEnabled = YES;
        _virtualInputEnabled = YES;
        _virtualOutputEnabled = YES;
        _midi = ({
            PGMidi *midi = [[PGMidi alloc] init];
            [midi setDelegate:self];
            [midi setNetworkEnabled:[self isNetworkEnabled]];
            [midi setVirtualEndpointName:@"LF Virtual Port"];
            [midi setVirtualSourceEnabled:[self isVirtualInputEnabled]];
            [midi setVirtualDestinationEnabled:[self isVirtualOutputEnabled]];
            for (PGMidiSource *source in [midi sources]) {
                [source addDelegate:self];
            }
            midi;
        });
    }
    
    return self;
}

#pragma mark - Getters / Setters

- (PGMidi *)midi
{
    if (!_midi) {
        if ([self isEnabled]) {
            _midi = ({
                PGMidi *midi = [[PGMidi alloc] init];
                [midi setDelegate:self];
                [midi setNetworkEnabled:[self isNetworkEnabled]];
                [midi setVirtualEndpointName:@"LF Virtual Port"];
                [midi setVirtualSourceEnabled:[self isVirtualInputEnabled]];
                [midi setVirtualDestinationEnabled:[self isVirtualOutputEnabled]];
                for (PGMidiSource *source in [midi sources]) {
                    [source addDelegate:self];
                }
                midi;
            });
            DDLogDebug(@"MIDI: Interface Instantiated, %@", [_midi description]);
        }
    }
    else {
        if (![self isEnabled]) {
            [_midi setDelegate:nil];
            [_midi setNetworkEnabled:NO];
            [_midi setVirtualSourceEnabled:NO];
            [_midi setVirtualDestinationEnabled:NO];
            _midi = nil;
            DDLogDebug(@"MIDI: Interface Disabled");
        }
    }

    return _midi;
}

- (void)setNetworkEnabled:(BOOL)networkEnabled
{
    if (_networkEnabled != networkEnabled) {
        _networkEnabled = networkEnabled;
        [self.midi setNetworkEnabled:networkEnabled];
    }
}

- (void)setVirtualInputEnabled:(BOOL)virtualInputEnabled
{
    if (_virtualInputEnabled != virtualInputEnabled) {
        _virtualInputEnabled = virtualInputEnabled;
        [self.midi setVirtualSourceEnabled:virtualInputEnabled];
    }
}

- (void)setVirtualOutputEnabled:(BOOL)virtualOutputEnabled
{
    if (_virtualOutputEnabled != virtualOutputEnabled) {
        _virtualOutputEnabled = virtualOutputEnabled;
        [self.midi setVirtualDestinationEnabled:virtualOutputEnabled];
    }
}

- (NSArray *)inputs
{
    return [self.midi sources];
}

- (NSArray *)outputs
{
    return [self.midi destinations];
}

#pragma mark - Private

+ (NSDictionary *)_statusMessageSizeMap
{
    static NSDictionary *msgSizeMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        msgSizeMap = @{
            @(LFMidiStatusNoteOn): @(2),
            @(LFMidiStatusNoteOff): @(2)
        };
    });
    return msgSizeMap;
}

- (NSInteger)_sizeOfStatus:(LFMidiStatus)status
{
    return [[[self.class _statusMessageSizeMap] objectForKey:@(status)] integerValue];
}

- (void)handleMessage:(NSData *)message withDelta:(double)deltaTime
{
    const unsigned char *bytes = (const unsigned char*)[message bytes];
    int statusByte = bytes[0];
    int channel = 1;
    
    if (statusByte >= LFMidiStatusSysex) {
        statusByte = statusByte & LFMidiStatusSystemReset;
    }
    else {
        statusByte = statusByte & LFMidiStatusSysex;
        channel = (int)(statusByte & 0x0F);
    }
    
    switch (statusByte) {
        case LFMidiStatusNoteOn:
            if ([self delegate] && [self.delegate respondsToSelector:@selector(midiNoteOn:velocity:channel:)]) {
                [self.delegate midiNoteOn:bytes[1] velocity:bytes[2] channel:channel];
            }
            break;
        case LFMidiStatusNoteOff:
            if ([self delegate] && [self.delegate respondsToSelector:@selector(midiNoteOff:velocity:channel:)]) {
                [self.delegate midiNoteOff:bytes[1] velocity:bytes[2] channel:channel];
            }
            break;
        case LFMidiStatusControlChange:
            if ([self delegate] && [self.delegate respondsToSelector:@selector(midiControlChange:value:channel:)]) {
                [self.delegate midiControlChange:bytes[1] value:bytes[2] channel:channel];
            }
            break;
        case LFMidiStatusProgramChange:
            if ([self delegate] && [self.delegate respondsToSelector:@selector(midiProgramChange:channel:)]) {
                [self.delegate midiProgramChange:bytes[1] channel:channel];
            }
            break;
        case LFMidiStatusPitchBend: {
            int value = (bytes[2] << 7) + bytes[1]; // msb + lsb
            if ([self delegate] && [self.delegate respondsToSelector:@selector(midiPitchBend:channel:)]) {
                [self.delegate midiPitchBend:value channel:channel];
            }
        }
            break;
        case LFMidiStatusAftertouch:
            if ([self delegate] && [self.delegate respondsToSelector:@selector(midiAftertouch:channel:)]) {
                [self.delegate midiAftertouch:bytes[1] channel:channel];
            }
            break;
            
        case LFMidiStatusPolyAftertouch:
            if ([self delegate] && [self.delegate respondsToSelector:@selector(midiPolyAftertouch:pitch:channel:)]) {
                [self.delegate midiPolyAftertouch:bytes[2] pitch:bytes[1] channel:channel];
            }
            break;
            
        case LFMidiStatusSysex:
            if ([self delegate] && [self.delegate respondsToSelector:@selector(midiSysexData:channel:)]) {
                for (int i = 0; i < message.length; ++i) {
                    [self.delegate midiSysexData:bytes[i] channel:channel];
                }
            }
            break;
            
        default:
            DDLogDebug(@"MIDI: Not handling this sort of MIDI input/n*** Length: %lu *** /n*** Description: %@ ***", (unsigned long)[message length], [message debugDescription]);
            break;
    }
}

#pragma mark - PGMidiDelegate

- (void)midi:(PGMidi *)midi sourceAdded:(PGMidiSource *)source
{
    [source addDelegate:self];
    if ([self delegate] && [self.delegate respondsToSelector:@selector(midiInputConnectionEvent)]) {
        [self.delegate midiInputConnectionEvent];
    }
    DDLogDebug(@"MIDI: Input Added: \"%@\"", [source name]);
}

- (void)midi:(PGMidi *)midi sourceRemoved:(PGMidiSource *)source
{
    [source removeDelegate:self];
    if ([self delegate] && [self.delegate respondsToSelector:@selector(midiInputConnectionEvent)]) {
        [self.delegate midiInputConnectionEvent];
    }
    DDLogDebug(@"MIDI: Input Removed: \"%@\"", [source name]);
}

- (void)midi:(PGMidi *)midi destinationAdded:(PGMidiDestination *)destination
{
    if ([self delegate] && [self.delegate respondsToSelector:@selector(midiOutputConnectionEvent)]) {
        [self.delegate midiOutputConnectionEvent];
    }
    DDLogDebug(@"MIDI: Output Added: \"%@\"", [destination name]);
}

- (void)midi:(PGMidi *)midi destinationRemoved:(PGMidiDestination *)destination
{
    if ([self delegate] && [self.delegate respondsToSelector:@selector(midiOutputConnectionEvent)]) {
        [self.delegate midiOutputConnectionEvent];
    }
    DDLogDebug(@"MIDI: Output Removed: \"%@\"", [destination name]);
}

#pragma mark - PGMidiSourceDelegate

- (void)midiSource:(PGMidiSource *)input midiReceived:(const MIDIPacketList *)packetList
{
    const MIDIPacket *packet = &packetList->packet[0];
    unsigned char statusByte;
    unsigned short nBytes, curByte, msgSize;
    MIDITimeStamp time;
    double delta = 0.0;
    
    for (int i = 0; i < packetList->numPackets; ++i) {
        nBytes = packet->length;
        if (nBytes == 0) continue;
        
        // Calculate Time Stamp
        time = 0;
        if (_firstPacket) {
            _firstPacket = NO;
        }
        else {
            time = ({
                MIDITimeStamp timeStamp = packet->timeStamp;
                timeStamp == 0 ? mach_absolute_time() : timeStamp;
                timeStamp -= _lastTime;
                timeStamp; // Returns Time Stamp
            });
            
            if (!_continueSysex) delta = absoluteToNanos(time);
        }
        
        _lastTime = ({
            MIDITimeStamp timeStamp = packet->timeStamp;
            timeStamp = timeStamp == 0 ? mach_absolute_time() : timeStamp;
            timeStamp; // Returns Time Stamp
        });
        
        // Handle Segmented Sysex Messages
        curByte = 0;
        if (_continueSysex) {
            // Copy the packet data if not ignoring Sysex
            if (![self shouldIgnoreSysex]) {
                for (int i = 0; i < nBytes; ++i) {
                    [_messageIn appendBytes:&packet->data[i] length:1];
                }
            }
            
            // Look for Sysex End
            _continueSysex = packet->data[nBytes-1] != LFMidiStatusSysexEnd;
            
            if (!_continueSysex) {
                // Send message if Sysex message is complete
                if ([_messageIn length] > 0) [self handleMessage:_messageIn withDelta:delta];
                [_messageIn setLength:0];
            }
        }
        else { // Not Sysex, Parse Bytes
            while (curByte < nBytes) {
                msgSize = 0;
                
                // Next byte in the packet should be a status byte
                statusByte = packet->data[curByte];
                if (!statusByte & LFMidiStatusNoteOn) break;
                
                // Determine the number of bytes in the message
                if (statusByte < LFMidiStatusProgramChange) {
                    msgSize = 3;
                }
                else if (statusByte < LFMidiStatusPitchBend) {
                    msgSize = 2;
                }
                else if (statusByte < LFMidiStatusSysex) {
                    msgSize = 3;
                }
                else if (statusByte == LFMidiStatusSysex) {
                    if ([self shouldIgnoreSysex]) {
                        msgSize = 0;
                        curByte = nBytes;
                    }
                    else {
                        msgSize = nBytes - curByte;
                    }
                    _continueSysex = packet->data[nBytes-1] != LFMidiStatusSysexEnd;
                }
                else if (statusByte == LFMidiStatusTimeCode) {
                    if ([self shouldIgnoreTiming]) {
                        msgSize = 0;
                        curByte += 2;
                    }
                    else {
                        msgSize = 2;
                    }
                }
                else if (statusByte == LFMidiStatusSongPositionPointer) {
                    msgSize = 3;
                }
                else if (statusByte == LFMidiStatusSongSelect) {
                    msgSize = 2;
                }
                else if (statusByte == LFMidiStatusTimeClock && [self shouldIgnoreTiming]) {
                    // Ignoring
                    msgSize = 0;
                    curByte += 1;
                }
                else if (statusByte == LFMidiStatusActiveSensing && [self shouldIgnoreSense]) {
                    // Ignoring
                    msgSize = 0;
                    curByte += 1;
                }
                else {
                    msgSize = 1;
                }
                
                if (msgSize) {
                    [_messageIn appendBytes:&packet->data[curByte] length:curByte+msgSize];
                    
                    if (!_continueSysex) {
                        // Send message if Sysex message is complete
                        if ([_messageIn length] > 0) [self handleMessage:_messageIn withDelta:delta];
                        [_messageIn setLength:0];
                    }
                    curByte += msgSize;
                }
            }
        }
        packet = MIDIPacketNext(packet);
    }
}

@end

@implementation LFMidiNote

- (instancetype)initWithNote:(NSInteger)note withVelocity:(NSInteger)velocity withChannel:(NSInteger)channel
{
    self = [super init];
    if (!self) return nil;
    
    _channel = channel;
    _note = note;
    _velocity = velocity;
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[self class]]) return NO;
    return [self isEqualToNote:(LFMidiNote *)object];
}

- (BOOL)isEqualToNote:(LFMidiNote *)note
{
    if (note == self) return YES;
    if ([note note] != [self note]) return NO;
    if ([note channel] != [self channel]) return NO;
    return YES;
}

@end

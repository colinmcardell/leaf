//
//  LFSynthController.m
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

#import "LFSynthController.h"

#import "LFLogger.h"
#import "LFMidi.h"

#import <libpd/PdBase.h>
#import <libpd/PdAudioController.h>
#import <libpd/PdDispatcher.h>

// LibPd patch file name
#define kLeafPdPatchName @"leaf.pd"

// MIDI Defaults
#define kDefaultMidiChannel 0 // 0 = MIDI Channel 1
#define kDefaultVelocity 127

#define kDebug NO

// ***** Setter Macros *****
// NSNumber * as floatValue
#define NSNUMBER_AS_FLOAT(NSNUMBER) [_##NSNUMBER floatValue]

#define PD_SEND_MESSAGE_FOR_PROPERTY_TO_RECEIVER(MESSAGE, PROPERTY, RECEIVER) [PdBase sendMessage:MESSAGE withArguments:@[_##PROPERTY] toReceiver:RECEIVER]

// Sends a float value to a receiver through PdBase
#define PD_SEND_FLOAT_TO_RECEIVER(FLOAT, RECEIVER) [PdBase sendFloat:FLOAT toReceiver:RECEIVER]

// Sends an NSNumber * as a float to a receiver through PdBase
#define PD_SEND_NSNUMBER_AS_FLOAT_TO_RECEIVER(NSNUMBER, RECEIVER) PD_SEND_FLOAT_TO_RECEIVER(NSNUMBER_AS_FLOAT(NSNUMBER), RECEIVER)

// Generates a setter with an updater that will be executed upon update
#define GENERATE_SETTER(PROPERTY, TYPE, SETTER, UPDATER) \
- (void)SETTER:(TYPE)PROPERTY \
{ \
    if (_##PROPERTY != PROPERTY) { \
        _##PROPERTY = PROPERTY; \
        if (kDebug) { \
            DDLogDebug(@"%s: %@", __PRETTY_FUNCTION__, _##PROPERTY);\
        } \
        UPDATER; \
    } \
}

// Combines the setter generator macro & Pd send float macro
#define GENERATE_PD_FLOAT_SETTER(PROPERTY, SETTER, RECEIVER) \
GENERATE_SETTER(PROPERTY, \
                NSNumber *, \
                SETTER, \
                PD_SEND_NSNUMBER_AS_FLOAT_TO_RECEIVER(PROPERTY, RECEIVER) \
)

// Combines the setter generator macro & Pd send message macro
#define GENERATE_PD_MESSAGE_SETTER(PROPERTY, SETTER, MESSAGE, RECEIVER) \
GENERATE_SETTER(PROPERTY, \
                NSNumber *, \
                SETTER, \
                PD_SEND_MESSAGE_FOR_PROPERTY_TO_RECEIVER(MESSAGE, PROPERTY, RECEIVER) \
)
// ***** End Setter Macros *****

@interface LFSynthController () <LFMidiDelegate>

@property (strong, nonatomic) PdAudioController *audioController;
@property (strong, nonatomic) PdDispatcher *dispatcher;
@property (strong, nonatomic) LFMidi *midi;
@property (strong, nonatomic) NSMutableArray *midiNoteOnArray;

@end

@implementation LFSynthController

+ (LFSynthController *)sharedController
{
    static LFSynthController *sharedController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });

    return sharedController;
}

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (!self) return nil;

    _dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:_dispatcher];

    _audioController = ({
        PdAudioController *audioController = [[PdAudioController alloc] init];
        [audioController configureAmbientWithSampleRate:44100 numberChannels:2 mixingEnabled:YES];
#ifdef DEBUG
        [audioController print];
#endif
        [audioController setActive:YES];

        audioController;
    });
    
    _midiNoteOnArray = [[NSMutableArray alloc] init];
    
    _midi = ({
        LFMidi *midi = [[LFMidi alloc] init];
        [midi setDelegate:self];
        midi;
    });
    
    [PdBase openFile:kLeafPdPatchName path:[[NSBundle mainBundle] bundlePath]];
    [self defaultState];

    return self;
}

#pragma mark - State

- (void)defaultState
{
    [self updateState:@{
        kMasterTempo : @120.0f,
        kMasterTempoDivision : @(kNoteQuarter),
        kMasterVolume: @0.9f,
        kAmpAttack : @0.0f,
        kAmpDecay : @0.6f,
        kAmpSustain : @0.85f,
        kAmpRelease : @0.5f,
        kFilterFreq : @(kFilterFreq_max),
        kFilterReso : @(kResonance_min),
        kGlideToggle : @NO,
        kGlide : @0.25f,
        kOsc1Volume : @0.9f,
        kOsc1Waveform : @(LFSynthWaveformSaw),
        kOsc1Range : @3.0f,
        kOsc1Freq : @0.5f,
        kOsc1PWMFreq : @0.0f,
        kOsc1PWMDepth : @0.0f,
        kOsc1TriSlope : @0.7f,
        kOsc1SoftClipMix : @0.5f,
        kOsc1SoftClipDrive : @0.6f,
        kOsc1Phase : @0.0f,
        kOsc2Volume : @0.9f,
        kOsc2Waveform : @(LFSynthWaveformSaw),
        kOsc2Range : @2.0f,
        kOsc2Freq : @0.5f,
        kOsc2PWMFreq : @0.0f,
        kOsc2PWMDepth : @0.0f,
        kOsc2TriSlope : @0.3f,
        kOsc2SoftClipMix : @0.5f,
        kOsc2SoftClipDrive : @0.6f,
        kOsc2Phase : @0.0f,
        kDelayEnabled : @NO,
        kDelaySync : @NO,
        kDelayFeedback : @0.6f,
        kDelayTime : @0.2f,
        kDelayLPFreq : @(kDelayLPFreq_max),
        kArpEnabled : @NO,
        kArpClockDivision : @(kNoteQuarter),
        kArpGate : @0.5f
    }];
}

- (void)updateState:(NSDictionary *)updatedValues
{
    for (NSString *key in updatedValues) {
//        DDLogDebug(@"%@ - %@", key, [updatedValues valueForKey:key]);
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
            [self setValue:[updatedValues objectForKey:key] forKey:key];
        }
    }
}

#pragma mark - Send Note On

- (void)sendNoteOn:(NSNumber *)note
{
    [self sendNoteOn:@(kDefaultMidiChannel) note:note velocity:@(kDefaultVelocity)];
}

- (void)sendNoteOn:(NSNumber *)note velocity:(NSNumber *)velocity
{
    [self sendNoteOn:@(kDefaultMidiChannel) note:note velocity:velocity];
}

- (void)sendNoteOn:(NSNumber *)channel note:(NSNumber *)note velocity:(NSNumber *)velocity
{
    [PdBase sendNoteOn:[channel intValue] pitch:[note intValue] velocity:[velocity intValue]];
}

#pragma mark - Send Note Off

- (void)sendNoteOff:(NSNumber *)note
{
    [self sendNoteOff:[self midiChannel] note:note velocity:0];
}

- (void)sendNoteOff:(NSNumber *)channel note:(NSNumber *)note velocity:(NSNumber *)velocity
{
    [PdBase sendNoteOn:[channel intValue] pitch:[note intValue] velocity:[velocity intValue]];
}

#pragma mark - Tempo Nudge

- (void)nudge:(int)value
{
    switch (value) {
        case 0:
            [PdBase sendBangToReceiver:KReceiver_masterTempoNudgeBack];
            break;
            
        case 1:
            [PdBase sendBangToReceiver:kReceiver_masterTempoNudgeForward];
            break;
            
        default:
            break;
    }
}

#pragma mark - Hold Off

- (void)holdOff
{
    [PdBase sendBangToReceiver:kReceiver_holdOff];
}

#pragma mark - Master Tempo Setter

#pragma mark - Master

GENERATE_PD_FLOAT_SETTER(masterVolume, setMasterVolume, kReceiver_masterVolume)
GENERATE_SETTER(masterTempoDivision, NSNumber *, setMasterTempoDivision, [self refreshMasterTempoDivision])
GENERATE_SETTER(masterTempo,
                NSNumber *,
                setMasterTempo,
                PD_SEND_FLOAT_TO_RECEIVER(BPM_TO_MS(NSNUMBER_AS_FLOAT(masterTempo)),
                                          kReceiver_masterTempo)
)

- (void)refreshMasterTempoDivision
{
    if (![self masterTempoDivision]) return;
    
    if ([self.masterTempoDivision floatValue] == kNoteHalf) {
        [PdBase sendBangToReceiver:kReceiver_masterTempoDivideHalf];
    }
    else if ([self.masterTempoDivision floatValue] == kNoteQuarter) {
        [PdBase sendBangToReceiver:kReceiver_masterTempoDivideQuarter];
    }
    else if ([self.masterTempoDivision floatValue] == kNoteEighth) {
        [PdBase sendBangToReceiver:kReceiver_masterTempoDivideEighth];
    }
    else if ([self.masterTempoDivision floatValue] == kNoteSixteenth) {
        [PdBase sendBangToReceiver:kReceiver_masterTempoDivideSixteenth];
    }
    else {
        DDLogDebug(@"Received master tempo note subdivision that is not supported: %@, defaulting to quarter note", [self masterTempoDivision]);
        [self setMasterTempoDivision:@(kNoteQuarter)];
    }
}

#pragma mark - ADSR Envelope Setters

GENERATE_PD_MESSAGE_SETTER(ampAttack, setAmpAttack, kMessage_ampAttack, kReceiver_ampADSR)
GENERATE_PD_MESSAGE_SETTER(ampDecay, setAmpDecay, kMessage_ampDecay, kReceiver_ampADSR)
GENERATE_PD_MESSAGE_SETTER(ampSustain, setAmpSustain, kMessage_ampSustain, kReceiver_ampADSR)
GENERATE_PD_MESSAGE_SETTER(ampRelease, setAmpRelease, kMessage_ampRelease, kReceiver_ampADSR)

#pragma mark - Filter

GENERATE_PD_MESSAGE_SETTER(filterFreq, setFilterFreq, kMessage_filterFreq, kReceiver_filter)
GENERATE_PD_MESSAGE_SETTER(filterReso, setFilterReso, kMessage_filterResonance, kReceiver_filter)

#pragma mark - Glide Setters

GENERATE_PD_FLOAT_SETTER(glideToggle, setGlideToggle, kReceiver_glideToggle)
GENERATE_PD_FLOAT_SETTER(glide, setGlide, kReceiver_glide)

#pragma mark - OSC 1 Setters

GENERATE_PD_FLOAT_SETTER(osc1Volume, setOsc1Volume, kReceiver_osc1Volume)
GENERATE_PD_FLOAT_SETTER(osc1Waveform, setOsc1Waveform, kReceiver_osc1Waveform)
GENERATE_PD_FLOAT_SETTER(osc1Range, setOsc1Range, kReceiver_osc1Range)
GENERATE_PD_FLOAT_SETTER(osc1Freq, setOsc1Freq, kReceiver_osc1Freq)
GENERATE_PD_FLOAT_SETTER(osc1PWMFreq, setOsc1PWMFreq, kReceiver_osc1PWMFreq)
GENERATE_PD_FLOAT_SETTER(osc1PWMDepth, setOsc1PWMDepth, kReceiver_osc1PWMDepth)
GENERATE_PD_FLOAT_SETTER(osc1TriSlope, setOsc1TriSlope, kReceiver_osc1TriSlope)
GENERATE_PD_FLOAT_SETTER(osc1SoftClipMix, setOsc1SoftClipMix, kReceiver_osc1SoftClipMix)
GENERATE_PD_FLOAT_SETTER(osc1SoftClipDrive, setOsc1SoftClipDrive, kReceiver_osc1SoftClipDrive)
GENERATE_PD_FLOAT_SETTER(osc1Phase, setOsc1Phase, kReceiver_osc1Phase)

#pragma mark - OSC 2 Setters

GENERATE_PD_FLOAT_SETTER(osc2Volume, setOsc2Volume, kReceiver_osc2Volume)
GENERATE_PD_FLOAT_SETTER(osc2Waveform, setOsc2Waveform, kReceiver_osc2Waveform)
GENERATE_PD_FLOAT_SETTER(osc2Range, setOsc2Range, kReceiver_osc2Range)
GENERATE_PD_FLOAT_SETTER(osc2Freq, setOsc2Freq, kReceiver_osc2Freq)
GENERATE_PD_FLOAT_SETTER(osc2PWMFreq, setOsc2PWMFreq, kReceiver_osc2PWMFreq)
GENERATE_PD_FLOAT_SETTER(osc2PWMDepth, setOsc2PWMDepth, kReceiver_osc2PWMDepth)
GENERATE_PD_FLOAT_SETTER(osc2TriSlope, setOsc2TriSlope, kReceiver_osc2TriSlope)
GENERATE_PD_FLOAT_SETTER(osc2SoftClipMix, setOsc2SoftClipMix, kReceiver_osc2SoftClipMix)
GENERATE_PD_FLOAT_SETTER(osc2SoftClipDrive, setOsc2SoftClipDrive, kReceiver_osc2SoftClipDrive)
GENERATE_PD_FLOAT_SETTER(osc2Phase, setOsc2Phase, kReceiver_osc2Phase)

#pragma mark - Delay Setters

GENERATE_PD_FLOAT_SETTER(delayEnabled, setDelayEnabled, kReceiver_delayBypass)
GENERATE_PD_FLOAT_SETTER(delaySync, setDelaySync, kReceiver_delaySync)
GENERATE_PD_FLOAT_SETTER(delayFeedback, setDelayFeedback, kReceiver_delayFeedback)
GENERATE_PD_FLOAT_SETTER(delayTime, setDelayTime, kReceiver_delayTime)
GENERATE_PD_FLOAT_SETTER(delayLPFreq, setDelayLPFreq, kReceiver_delayLPFreq)

#pragma mark - Arp Setters

GENERATE_PD_FLOAT_SETTER(arpEnabled, setArpEnabled, kReceiver_arpEnabled)
GENERATE_SETTER(arpClockDivision, NSNumber *, setArpClockDivision, [self refreshArpClockDivision])
GENERATE_PD_FLOAT_SETTER(arpGate, setArpGate, kReceiver_arpGate)

- (void)refreshArpClockDivision
{
    if ([self.arpClockDivision floatValue] == kNoteHalf) {
        [PdBase sendBangToReceiver:kReceiver_arpClockDivideHalf];
    }
    else if ([self.arpClockDivision floatValue] == kNoteQuarter) {
        [PdBase sendBangToReceiver:kReceiver_arpClockDivideQuarter];
    }
    else if ([self.arpClockDivision floatValue] == kNoteEighth) {
        [PdBase sendBangToReceiver:kReceiver_arpClockDivideEighth];
    }
    else if ([self.arpClockDivision floatValue] == kNoteSixteenth) {
        [PdBase sendBangToReceiver:kReceiver_arpClockDivideSixteenth];
    }
    else {
        DDLogDebug(@"Received Arp Clock subdivision that is not supported: %@, defaulting to quarter note", [self arpClockDivision]);
        [self setArpClockDivision:@(kNoteQuarter)];
    }
}

#pragma mark - LFMidiDelegate

- (void)midiNoteOn:(int)pitch velocity:(int)velocity channel:(int)channel
{
    LFMidiNote *note = [[LFMidiNote alloc] initWithNote:pitch withVelocity:velocity withChannel:channel];
    if ([self.midiNoteOnArray containsObject:note]) return;
    
    LFMidiNote *firstNote = [self.midiNoteOnArray firstObject];
    if (firstNote) {
        [self sendNoteOn:@([note channel]) note:@([note note]) velocity:@([firstNote velocity])];
    }
    else {
        [self sendNoteOn:@([note channel]) note:@([note note]) velocity:@([note velocity])];
    }

    [self.midiNoteOnArray addObject:note];
}

- (void)midiNoteOff:(int)pitch velocity:(int)velocity channel:(int)channel
{
    LFMidiNote *note = [[LFMidiNote alloc] initWithNote:pitch withVelocity:velocity withChannel:channel];

    if (![self.midiNoteOnArray containsObject:note]) return;
    
    if ([[self.midiNoteOnArray lastObject] isEqual:note]) {
        [self sendNoteOff:@([note channel]) note:@([note note]) velocity:@(0)];
        [self.midiNoteOnArray removeObject:note];
        note = [self.midiNoteOnArray lastObject];
        if (note) [self sendNoteOn:@([note channel]) note:@([note note]) velocity:@([note velocity])];
    }
    else {
        [self.midiNoteOnArray removeObject:note];
    }
}

@end

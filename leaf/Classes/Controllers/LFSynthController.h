//
//  LFSynthController.h
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

#import <Foundation/Foundation.h>
#import "LFSynthControllerConstants.h"

typedef NS_ENUM(NSUInteger, LFSynthWaveform) {
    LFSynthWaveformSine = 0,
    LFSynthWaveformSaw,
    LFSynthWaveformSquare,
    LFSynthWaveformTriangle
};

@interface LFSynthController : NSObject

+ (LFSynthController *)sharedController;

@property (strong, nonatomic) NSNumber *ampAttack;
@property (strong, nonatomic) NSNumber *ampDecay;
@property (strong, nonatomic) NSNumber *ampSustain;
@property (strong, nonatomic) NSNumber *ampRelease;

@property (strong, nonatomic) NSNumber *arpClockDivision;
@property (strong, nonatomic) NSNumber *arpEnabled;
@property (strong, nonatomic) NSNumber *arpGate;

@property (strong, nonatomic) NSNumber *delayEnabled;
@property (strong, nonatomic) NSNumber *delayFeedback;
@property (strong, nonatomic) NSNumber *delayLPFreq;
@property (strong, nonatomic) NSNumber *delaySync;
@property (strong, nonatomic) NSNumber *delayTime;

@property (strong, nonatomic) NSNumber *filterFreq;
@property (strong, nonatomic) NSNumber *filterReso;

@property (strong, nonatomic) NSNumber *glide;
@property (strong, nonatomic) NSNumber *glideToggle;

@property (strong, nonatomic) NSNumber *masterTempo;
@property (strong, nonatomic) NSNumber *masterTempoDivision;
@property (strong, nonatomic) NSNumber *masterVolume;

@property (strong, nonatomic) NSNumber *midiChannel;

@property (strong, nonatomic) NSNumber *osc1Freq;
@property (strong, nonatomic) NSNumber *osc1Phase;
@property (strong, nonatomic) NSNumber *osc1PWMDepth;
@property (strong, nonatomic) NSNumber *osc1PWMFreq;
@property (strong, nonatomic) NSNumber *osc1Range;
@property (strong, nonatomic) NSNumber *osc1SoftClipDrive;
@property (strong, nonatomic) NSNumber *osc1SoftClipMix;
@property (strong, nonatomic) NSNumber *osc1TriSlope;
@property (strong, nonatomic) NSNumber *osc1Volume;
@property (strong, nonatomic) NSNumber *osc1Waveform;

@property (strong, nonatomic) NSNumber *osc2Freq;
@property (strong, nonatomic) NSNumber *osc2Phase;
@property (strong, nonatomic) NSNumber *osc2PWMDepth;
@property (strong, nonatomic) NSNumber *osc2PWMFreq;
@property (strong, nonatomic) NSNumber *osc2Range;
@property (strong, nonatomic) NSNumber *osc2SoftClipDrive;
@property (strong, nonatomic) NSNumber *osc2SoftClipMix;
@property (strong, nonatomic) NSNumber *osc2TriSlope;
@property (strong, nonatomic) NSNumber *osc2Volume;
@property (strong, nonatomic) NSNumber *osc2Waveform;

@property (strong, nonatomic) NSNumber *velocity;

- (void)holdOff;

- (void)sendNoteOn:(NSNumber *)note;
- (void)sendNoteOff:(NSNumber *)note;

@end

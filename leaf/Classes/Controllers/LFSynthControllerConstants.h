//
//  LFSynthControllerConstants.h
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

#define BPM_TO_MS(bpm) ((60 / bpm) * 1000)
#define MS_TO_BPM(ms) ((1000 / ms) * 60)

#pragma mark - LibPd Message / Receiver Constants

#define kReceiver_masterTempo @"masterTempo"
#define KReceiver_masterTempoNudgeBack @"tempoNudgeBack"
#define kReceiver_masterTempoNudgeForward @"tempoNudgeForward"
#define kReceiver_masterTempoDivideHalf @"metroHalf"
#define kReceiver_masterTempoDivideQuarter @"metroQuarter"
#define kReceiver_masterTempoDivideEighth @"metroEighth"
#define kReceiver_masterTempoDivideSixteenth @"metroSixteenth"
#define kReceiver_holdOff @"holdOff"

#define kReceiver_masterVolume @"masterVolume"
// Amp ASDR Envelope Constants
#define kReceiver_ampADSR @"adsr"
#define kMessage_ampAttack @"attack"
#define kMessage_ampDecay @"decay"
#define kMessage_ampSustain @"sustain"
#define kMessage_ampRelease @"release"
// Filter Constants
#define kReceiver_filter @"filter"
#define kMessage_filterFreq @"freq"
#define kFilterFreq_min 800
#define kFilterFreq_max 12000
#define kMessage_filterResonance @"q"
#define kResonance_min 0
#define kResonance_max 4
// Glide Constants
#define kReceiver_glideToggle @"glideToggle"
#define kReceiver_glide @"glide"
#define kGlide_min 0.04f
#define kGlide_max 0.5f
// OSC 1 Constants
#define kReceiver_osc1Volume @"leafOsc1Volume"
#define kReceiver_osc1Phase @"leafOsc1Phase"
#define kReceiver_osc1Waveform @"leafOsc1Waveform"
#define kReceiver_osc1Range @"leafOsc1Range"
#define kReceiver_osc1Freq @"leafOsc1Freq"
#define kReceiver_osc1PWMFreq @"leafOsc1PWMFreq"
#define kReceiver_osc1PWMDepth @"leafOsc1PWMDepth"
#define kReceiver_osc1TriSlope @"leafOsc1TriSlope"
#define kReceiver_osc1SoftClipMix @"leafOsc1SoftClipMix"
#define kReceiver_osc1SoftClipDrive @"leafOsc1SoftClipDrive"
// OSC 2 Constants
#define kReceiver_osc2Volume @"leafOsc2Volume"
#define kReceiver_osc2Phase @"leafOsc2Phase"
#define kReceiver_osc2Waveform @"leafOsc2Waveform"
#define kReceiver_osc2Range @"leafOsc2Range"
#define kReceiver_osc2Freq @"leafOsc2Freq"
#define kReceiver_osc2PWMFreq @"leafOsc2PWMFreq"
#define kReceiver_osc2PWMDepth @"leafOsc2PWMDepth"
#define kReceiver_osc2TriSlope @"leafOsc2TriSlope"
#define kReceiver_osc2SoftClipMix @"leafOsc2SoftClipMix"
#define kReceiver_osc2SoftClipDrive @"leafOsc2SoftClipDrive"
// Delay Constants
#define kReceiver_delayBypass @"leafDelayBypass"
#define kReceiver_delaySync @"delaySyncToggle"
#define kReceiver_delayFeedback @"leafDelayFeedback"
#define kReceiver_delayTime @"leafDelayTime"
#define kDelayTime_min 0.1f
#define kDelayTime_max 1.0f
#define kReceiver_delayLPFreq @"leafDelayLPFreq"
#define kDelayLPFreq_min 0.03125
#define kDelayLPFreq_max 0.5
// Arp Constants
#define kReceiver_arpEnabled @"arpEnabled"
#define kReceiver_arpClockDivideHalf @"arpHalf"
#define kReceiver_arpClockDivideQuarter @"arpQuarter"
#define kReceiver_arpClockDivideEighth @"arpEighth"
#define kReceiver_arpClockDivideSixteenth @"arpSixteenth"
#define kReceiver_arpGate @"arpGate"
#define kArpGate_min 0.0f
#define kArpGate_max 1.0f

#pragma mark - SynthController Properties

#define kMasterTempo @"masterTempo"
#define kMasterTempoDivision @"masterTempoDivision"
#define kNoteHalf 0.5
#define kNoteQuarter 0.25
#define kNoteEighth 0.125
#define kNoteSixteenth 0.0625

#define kMasterVolume @"masterVolume"
#define kAmpAttack @"ampAttack"
#define kAmpDecay @"ampDecay"
#define kAmpSustain @"ampSustain"
#define kAmpRelease @"ampRelease"

#define kFilterFreq @"filterFreq"
#define kFilterReso @"filterReso"

#define kGlideToggle @"glideToggle"
#define kGlide @"glide"

#define kOsc1Volume @"osc1Volume"
#define kOsc1Waveform @"osc1Waveform"
#define kOsc1Range @"osc1Range"
#define kOsc2Volume @"osc2Volume"
#define kOsc2Waveform @"osc2Waveform"
#define kOsc2Range @"osc2Range"

#define kOsc1Freq @"osc1Freq"
#define kOsc1PWMFreq @"osc1PWMFreq"
#define kOsc1PWMDepth @"osc1PWMDepth"
#define kOsc1TriSlope @"osc1TriSlope"
#define kOsc1SoftClipMix @"osc1SoftClipMix"
#define kOsc1SoftClipDrive @"osc1SoftClipDrive"
#define kOsc1Phase @"osc1Phase"

#define kOsc2Freq @"osc2Freq"
#define kOsc2PWMFreq @"osc2PWMFreq"
#define kOsc2PWMDepth @"osc2PWMDepth"
#define kOsc2TriSlope @"osc2TriSlope"
#define kOsc2SoftClipMix @"osc2SoftClipMix"
#define kOsc2SoftClipDrive @"osc2SoftClipDrive"
#define kOsc2Phase @"osc2Phase"

#define kDelayEnabled @"delayEnabled"
#define kDelaySync @"delaySync"
#define kDelayFeedback @"delayFeedback"
#define kDelayTime @"delayTime"
#define kDelayLPFreq @"delayLPFreq"

#define kArpEnabled @"arpEnabled"
#define kArpClockDivision @"arpClockDivision"
#define kArpGate @"arpGate"

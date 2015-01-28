//
//  LFDelaySliderViewController.m
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

#import "LFDelaySliderViewController.h"
#import "LFDelaySliderPackViewModel.h"
#import "LFSynthControllerConstants.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LFDelaySliderViewController ()

@end

@implementation LFDelaySliderViewController

+ (LFDelaySliderViewController *)delaySliderViewController
{
    return [[self alloc] initWithViewModel:[LFDelaySliderPackViewModel viewModel]];
}

- (instancetype)initWithViewModel:(LFDelaySliderPackViewModel *)viewModel
{
    self = [super initWithNumberOfSliders:[viewModel.sliderLabelsTitles count] withViewModel:viewModel];
    if (!self) return nil;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LFDelaySliderPackViewModel *viewModel = (LFDelaySliderPackViewModel *)[self viewModel];
    
    for (int i = 0; i < [self.sliderPackView.sliders count]; i++) {
        UISlider *slider = self.sliderPackView.sliders[i];
        
        switch (i) {
            case 0: {
                [slider setMinimumValue:kDelayTime_min];
                [slider setMaximumValue:kDelayTime_max];

                // Binding delay time slider to viewModel delayTime value
                // This requires manipulating the values going back and forth between the
                // Slider and the viewModel depending on if the delay sync is toggled on
                // or off. If sync is on then the delay value is converted to a range of
                // 0 - 1 and quantized to values from 0 - 0.33 - 0.66 - 1, otherwise the
                // standard delay time min and max values are used.
                {
                    RACSignal *sliderSignal = ({
                        RACSignal *signal = [slider rac_signalForControlEvents:UIControlEventValueChanged];
                        signal = [signal map:^NSNumber *(UISlider *sender) {
                            return @(sender.value);
                        }];
                        RACSignal *quantizedSignal = [signal map:^NSNumber *(NSNumber *value) {
                            CGFloat newValue = (((value.floatValue - kDelayTime_min) * (1.0f - 0.0f) / (kDelayTime_max - kDelayTime_min) + 0.0f));
                            if (newValue < 0.33 ) {
                                newValue = 0;
                            }
                            else if (newValue >= 0.33 && newValue < 0.66) {
                                newValue = 0.33;
                            }
                            else if (newValue >= 0.66 && newValue < 1.0) {
                                newValue = 0.66;
                            }
                            else if (newValue == 1.0) {
                                newValue = 1.0;
                            }
                            return @(newValue);
                        }];
                        [RACSignal if:[viewModel delaySyncSignal]
                                 then:quantizedSignal
                                 else:signal];
                    });
                    
                    RACSignal *delayTimeSignal = ({
                        RACSignal *signal = RACObserve(viewModel, delayTime);
                        RACSignal *mappedSignal = [signal map:^NSNumber *(NSNumber *value) {
                            CGFloat newValue = (((value.floatValue - 0.0f) * (kDelayTime_max - kDelayTime_min) / (1.0f - 0.0f) + kDelayTime_min));
                            return @(newValue);
                        }];
                        [RACSignal if:[viewModel delaySyncSignal]
                                 then:mappedSignal
                                 else:signal];
                    });
                    
                    [delayTimeSignal subscribeNext:^(NSNumber *value) {
                        if ([@([slider value]) isEqual:value]) return;
                        [slider setValue:[value floatValue]];
                    }];
                    
                    [sliderSignal subscribeNext:^(NSNumber *value) {
                        viewModel.delayTime = value;
                    }];
                }
            }
                break;

            case 1: {
                [slider setMinimumValue:0.0f];
                [slider setMaximumValue:1.0f];
                
                // Binding delay feedback slider to viewModel delayFeedback value
                RACChannelTerminal *modelTerminal = RACChannelTo(viewModel, delayFeedback);
                RACChannelTerminal *sliderTerminal = [slider rac_newValueChannelWithNilValue:@0];
                [modelTerminal subscribe:sliderTerminal];
                [sliderTerminal subscribe:modelTerminal];
            }
                break;
                
            case 2: {
                [slider setMinimumValue:kDelayLPFreq_min];
                [slider setMaximumValue:kDelayLPFreq_max];
                
                // Binding delay LP frequency slider to viewModel delayLPFreq value
                RACChannelTerminal *modelTerminal = RACChannelTo(viewModel, delayLPFreq);
                RACChannelTerminal *sliderTerminal = [slider rac_newValueChannelWithNilValue:@0];
                [modelTerminal subscribe:sliderTerminal];
                [sliderTerminal subscribe:modelTerminal];
            }
                break;
                
            default:
                break;
        }
    }
}

@end

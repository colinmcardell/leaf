//
//  LFGlideSliderViewController.m
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

#import "LFGlideSliderViewController.h"
#import "LFGlideSliderPackViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LFSynthControllerConstants.h"

@implementation LFGlideSliderViewController

+ (LFGlideSliderViewController *)glideSliderViewController
{
    return [[self alloc] initGlideSliderViewController:[LFGlideSliderPackViewModel viewModel]];
}

- (instancetype)initGlideSliderViewController:(LFGlideSliderPackViewModel *)viewModel
{
    self = [super initWithNumberOfSliders:[viewModel.sliderLabelsTitles count] withViewModel:viewModel];
    if (!self) return nil;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LFGlideSliderPackViewModel *viewModel = (LFGlideSliderPackViewModel *)[self viewModel];
    
    for (int i = 0; i < [self.sliderPackView.sliders count]; i++) {
        UISlider *slider = self.sliderPackView.sliders[i];
        RACChannelTerminal *sliderTerminal = [slider rac_newValueChannelWithNilValue:@0];
        RACChannelTerminal *modelTerminal;
        switch (i) {
            case 0:
                modelTerminal = RACChannelTo(viewModel, glide);
                [slider setMinimumValue:kGlide_min];
                [slider setMaximumValue:kGlide_max];
                break;
                
            default:
                break;
        }
        
        [modelTerminal subscribe:sliderTerminal];
        [sliderTerminal subscribe:modelTerminal];
    }
}

@end

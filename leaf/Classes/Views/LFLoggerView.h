//
//  LFLoggerView.h
//  leaf
//
//  Created by Colin McArdell on 3/6/15.
//  Copyright (c) 2015 Colin McArdell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFLogger.h"

@interface LFLoggerView : NSObject <DDLogger>

+ (LFLoggerView *)sharedInstance;

@property (assign, nonatomic) BOOL shouldDisplayHideButton; // defaults to NO
@property (strong, nonatomic) NSString *title; // defaults to @"Logs"

- (void)showLogInView:(UIView *)view;
- (void)hideLog;

@end

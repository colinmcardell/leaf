//
//  LFLoggerView.m
//  leaf
//
//  Created by Colin McArdell on 3/6/15.
//  Copyright (c) 2015 Colin McArdell. All rights reserved.
//

#import "LFLoggerView.h"

@interface LFLoggerView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableSet *messagesExpanded;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *loggerView;

@end

NSString * const kLFLoggerViewCellIdentifier = @"LFLoggerCellIdentifier";
const NSInteger kLFLoggerViewCellHeightMargin = 10;

@implementation LFLoggerView

@synthesize logFormatter;

+ (LFLoggerView *)sharedInstance
{
    static LFLoggerView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _messages = [[NSMutableArray alloc] init];
    _messagesExpanded = [[NSMutableSet alloc] init];
    
    _shouldDisplayHideButton = NO;
    
    _title = @"Logs";
    
    _loggerView = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:_title];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _titleLabel = titleLabel;
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLFLoggerViewCellIdentifier];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    _tableView = tableView;
    
    [_loggerView addSubview:_tableView];
    [_loggerView addSubview:_titleLabel];
    
    // Vertical Constraints
    {
        NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-[tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel, tableView)];
        [_loggerView addConstraints:vConstraints];
    }
    
    // Horizontal Constraints
    {
        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)];
        [_loggerView addConstraints:hConstraints];
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)];
        [_loggerView addConstraints:hConstraints];
    }
    
    return self;
}

#pragma mark - DDLogger

- (void)logMessage:(DDLogMessage *)logMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messages addObject:logMessage];
        [self.tableView reloadData];
        [self scrollToNewMessage];
    });
}

#pragma mark -

- (void)scrollToNewMessage
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.messages count] - 1) inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss:SSS"];
    });
    return dateFormatter;
}

- (UIFont *)loggerMessageFont
{
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont fontWithName:@"Menlo-Bold" size:9.0f];
    });
    return font;
}

- (NSString *)messageStringForIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *dateFormatter = [self dateFormatter];
    NSString *string = @"";
    NSInteger row = indexPath.row;
    DDLogMessage *message = self.messages[row];

    if ([self.messagesExpanded containsObject:@(row)]) {
        string = [NSString stringWithFormat:@"[%@]\n%@:%lu\n\n[%@]\n\n%@", [dateFormatter stringFromDate:message.timestamp], message.file, (unsigned long)message.line, message.function, message.message];
    } else {
        string = [NSString stringWithFormat:@"@[%@]\n%@", [dateFormatter stringFromDate:message.timestamp], message.message];
    }
    return string;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogMessage *message = self.messages[indexPath.row];

    static NSDictionary *messageTextColorMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageTextColorMap = @{
            @(DDLogFlagError): [UIColor colorWithRed:0.7529411764705882f green:0.2235294117647059f blue:0.16862745098039217f alpha:1.0f],
            @(DDLogFlagWarning): [UIColor colorWithRed:0.9529411764705882f green:0.611764705882353f blue:0.07058823529411765f alpha:1.0f],
            @(DDLogFlagInfo): [UIColor colorWithRed:0.15294117647058825f green:0.6823529411764706f blue:0.3764705882352941f alpha:1.0f],
            @(DDLogFlagDebug): [UIColor colorWithRed:0.1607843137254902f green:0.5019607843137255f blue:0.7254901960784313f alpha:1.0f],
            @(DDLogFlagVerbose): [UIColor colorWithRed:0.9254901960784314f green:0.9411764705882353f blue:0.9450980392156862f alpha:1.0f],
        };
    });
    
    UIColor *textColor = messageTextColorMap[@(message.flag)];
    
    [cell.textLabel setTextColor:textColor ? textColor : [UIColor whiteColor]];
    [cell.textLabel setText:[self messageStringForIndexPath:indexPath]];
    [cell.textLabel setFont:[self loggerMessageFont]];
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    [cell.textLabel setNumberOfLines:0];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        [_titleLabel setText:_title];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLFLoggerViewCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *messageString = [self messageStringForIndexPath:indexPath];
    CGFloat height = 44.0f;
    CGSize constraintSize = CGSizeMake(CGRectGetWidth(self.tableView.bounds) - 30.0f, FLT_MAX);
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    height = [messageString sizeWithFont:[self loggerMessageFont] constrainedToSize:constraintSize].height + kLFLoggerViewCellHeightMargin;
#else
    height = ceilf([messageString boundingRectWithSize:constraintSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{
                                                   NSFontAttributeName: [self loggerMessageFont]
                                               }
                                               context:nil].size.height + kLFLoggerViewCellHeightMargin);
#endif
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self shouldDisplayHideButton] ? 44.0f : 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (![self shouldDisplayHideButton]) return nil;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"Hide Log" forState:UIControlStateNormal];
    [closeButton setBackgroundColor:[UIColor grayColor]];
    [closeButton addTarget:self action:@selector(hideLog) forControlEvents:UIControlEventTouchUpInside];
    return closeButton;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *index = @([indexPath row]);
    if ([self.messagesExpanded containsObject:index]) {
        [self.messagesExpanded removeObject:index];
    }
    else {
        [self.messagesExpanded addObject:index];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)showLogInView:(UIView *)view
{
    UIView *loggerView = [self loggerView];
    [view addSubview:loggerView];

    // Layout
    {
        [loggerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSString *verticalConstraints;
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_8_0
        [view setLayoutMargins:UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f)];
        verticalConstraints = @"V:|-[loggerView]-|";
#else
        verticalConstraints = @"V:|-(10.0)-[loggerView]-(10.0)-|";
#endif
        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loggerView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loggerView)];
        NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraints options:0 metrics:nil views:NSDictionaryOfVariableBindings(loggerView)];
        [view addConstraints:hConstraints];
        [view addConstraints:vConstraints];
    }
}

- (void)hideLog
{
    [self.loggerView removeFromSuperview];
}

@end

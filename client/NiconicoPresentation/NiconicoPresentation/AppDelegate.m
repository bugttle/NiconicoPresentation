//
//  AppDelegate.m
//  NiconicoPresentation
//
//  Created by UQ Times on 3/7/15.
//  Copyright (c) 2015 UQ Times. All rights reserved.
//

#import "AppDelegate.h"

#import <Quartz/Quartz.h>
#import "NS(Attributed)String+Geometrics.h"
#import "SocketIO.h"

#define HOSTNAME @"localhost"
#define PORTNUM 80
#define MAX_MESSAGE_LINE 10
#define MESSAGE_ANIMATION_DURATION 6.0f

//#include <Carbon/Carbon.h>
//kVK_LeftArrow                 = 0x7B,
//kVK_RightArrow                = 0x7C,
//kVK_DownArrow                 = 0x7D,
//kVK_UpArrow                   = 0x7E
typedef NS_ENUM (NSUInteger, NPKeyCode) {
    NPKeyCodeLeftArrow = 0x7B,
    NPKeyCodeRightArrow = 0x7C,
    NPKeyCodeDownArrow = 0x7D,
    NPKeyCodeUpArrow = 0x7E,
};

@interface AppDelegate () <SocketIODelegate>
{
    int _messageCounts[MAX_MESSAGE_LINE];
}
@property (weak) IBOutlet NSWindow *window;
@property (assign) float messageHeight;
@property (strong) NSTextField *likeCountTextField;
@property (strong) SocketIO *socketIO;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self initWindow];
    [self initMessages];
    [self initSocketIO];
}

- (void)initWindow {
    NSRect frame = _window.screen.frame;
    
    [_window setFrame:frame display:YES animate:NO];
    [_window makeKeyAndOrderFront:nil];
    _window.opaque = NO;
    _window.backgroundColor = [NSColor colorWithDeviceRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    _window.level = NSScreenSaverWindowLevel;//NSStatusWindowLevel;
    _window.ignoresMouseEvents = YES;
    _window.hasShadow = NO;
    _window.styleMask = NSBorderlessWindowMask;
    //[NSMenu setMenuBarVisible:NO];
}

- (void)initMessages {
    // 1メッセージあたりの高さ
    _messageHeight = _window.screen.frame.size.height / MAX_MESSAGE_LINE;
    // メッセージのバッファ
    for (int i = 0; i < MAX_MESSAGE_LINE; ++i) {
        _messageCounts[i] = 0;
    }
    // Like
    _likeCountTextField = [self createLikeCountTextField:0];
    _likeCountTextField.alphaValue = 0.0f;
    [_window.contentView addSubview:_likeCountTextField];
}

- (void)initSocketIO {
    if (!_socketIO) {
        _socketIO = [[SocketIO alloc] initWithDelegate:self];
    }
    [_socketIO connectToHost:HOSTNAME onPort:PORTNUM];
}

- (NSTextField *) createLikeCountTextField:(NSInteger)count {
    NSTextField *text = [[NSTextField alloc] initWithFrame:NSMakeRect(70, 80, 200, 40)];
    text.font = [NSFont systemFontOfSize:40.0f];
    text.bezeled = NO;
    text.drawsBackground = NO;
    text.editable = NO;
    text.selectable = NO;
    text.usesSingleLineMode = YES;
    
    NSDictionary *textAttributes = @{NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-3.0],
                                     NSStrokeColorAttributeName:[NSColor whiteColor],
                                     NSForegroundColorAttributeName:[NSColor blackColor]};
    text.attributedStringValue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", count] attributes:textAttributes];
    return text;
}

- (NSTextField *)createMessageLabel:(NSString *)message atIndex:(int)index {
    NSRect frame = _window.screen.visibleFrame;
    NSTextField *text = [[NSTextField alloc] initWithFrame:NSMakeRect(0, frame.size.height-((_messageHeight-6)*index)-20, frame.size.width, _messageHeight)];
    text.font = [NSFont systemFontOfSize:68.0f];
    text.stringValue = message;
    text.bezeled = NO;
    text.drawsBackground = NO;
    text.editable = NO;
    text.selectable = NO;
    text.usesSingleLineMode = YES;
    text.wantsLayer = YES;
    NSDictionary *textAttributes = @{NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-3.0f],
                                     NSStrokeColorAttributeName:[NSColor whiteColor],
                                     NSForegroundColorAttributeName:[NSColor blackColor]};
    text.attributedStringValue = [[NSAttributedString alloc] initWithString:message attributes:textAttributes];
    return text;
}

- (void)showLike:(NSInteger)count {
    NSImageView *view = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 90, 200, 171)];
    view.image = [NSImage imageNamed:@"FacebookLike.png"];
    [_window.contentView addSubview:view positioned:NSWindowBelow relativeTo:_likeCountTextField];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 2.0f;
        view.animator.frame = NSOffsetRect(view.frame, 0, 100);
        view.animator.alphaValue = 0.0;
    } completionHandler:^{
        [view removeFromSuperview];
    }];
    
    NSDictionary *textAttributes = @{NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-3.0],
                                     NSStrokeColorAttributeName:[NSColor whiteColor],
                                     NSForegroundColorAttributeName:[NSColor blackColor]};
    _likeCountTextField.attributedStringValue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", count] attributes:textAttributes];
    _likeCountTextField.alphaValue = 1.0f;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 2.0f;
        _likeCountTextField.animator.alphaValue = 0.0;
    } completionHandler:nil];
}

- (void)postKeyboardEvent:(NPKeyCode)keyCode {
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
    
    CGEventRef keyDownEvent = CGEventCreateKeyboardEvent(source, (CGKeyCode)keyCode, true);
    CGEventRef keyUpEvent = CGEventCreateKeyboardEvent(source, (CGKeyCode)keyCode, false);
    
    //CGEventSetFlags(keyDownEvent, kCGEventFlagMaskControl);  // Ctrlが必要な場合
    CGEventPost(kCGHIDEventTap, keyDownEvent);
    CGEventPost(kCGHIDEventTap, keyUpEvent);
    
    CFRelease(keyUpEvent);
    CFRelease(keyDownEvent);
    CFRelease(source);
}

- (void)doScreenTest {
    [self addMessage:@"111111111111111111111111111111111111111111111111111111111111111111111111111111"];
    [self addMessage:@"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"];
    [self addMessage:@"ABCDEFGHIJKLMNOPQRSQUVWXYZABCDEFGHIJKLMNOPQRSQUVWXYZABCDEFGHIJKLMNOPQRSQUVWXYZ"];
    [self addMessage:@"44444444444444444444444444444444444444444444444444444444444444444444444444444444"];
    [self addMessage:@"55555555555555555555555555555555555555555555555555555555555555555555555555555555"];
    [self addMessage:@"66666666666666666666666666666666666666666666666666666666666666666666666666666666"];
    [self addMessage:@"77777777777777777777777777777777777777777777777777777777777777777777777777777777"];
    [self addMessage:@"88888888888888888888888888888888888888888888888888888888888888888888888888888888"];
    [self addMessage:@"99999999999999999999999999999999999999999999999999999999999999999999999999999999"];
    [self addMessage:@"10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10"];
//    [self addMessage:@"11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11"];
//    [self addMessage:@"12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12"];
//    [self addMessage:@"13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13"];
//    [self addMessage:@"14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14"];

    [self showLike: 999];
}

- (int)modIndex {
    int index = 0;
    int min = _messageCounts[0];
    for (int i = 1; i < MAX_MESSAGE_LINE; ++i) {
        if (_messageCounts[i] < min) {
            min = _messageCounts[i];
            index = i;
        }
    }
    ++(_messageCounts[index]);
    return index;
}

- (void)addMessage:(NSString *)message {
    int index = [self modIndex];

    NSTextField *text = [self createMessageLabel:message atIndex:index];
    [_window.contentView addSubview:text];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:text.font, NSFontAttributeName, nil];
    float width = [text.stringValue widthForHeight:_messageHeight attributes:attributes];
    if (text.frame.size.width < width) {
        [text setFrameSize:CGSizeMake(width, text.frame.size.height)];
    }
   
    [self animateMessageLabel:text withWidth:width withDuration:MESSAGE_ANIMATION_DURATION atIndex:index];
}

- (void)animateMessageLabel:(NSView *)view withWidth:(float)width withDuration:(float)duration atIndex:(int)index
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [view removeFromSuperview];
        --(_messageCounts[index]);

        NSMutableString *str = [NSMutableString string];
        for (int i = 1; i < MAX_MESSAGE_LINE; ++i) {
            [str appendFormat:@"%d,", _messageCounts[i]];
        }
    }];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.duration = duration;
    animation.fromValue = [NSNumber numberWithFloat:view.frame.size.width];
    animation.toValue = [NSNumber numberWithFloat:-(width)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:@"moveByAnimation"];
    [CATransaction commit];
}

- (void) socketIODidConnect:(SocketIO *)socket {
    NSLog(@"%s", __func__);
    [socket sendEvent:@"connected" withData:nil];
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"%s: error=%@", __func__, error.localizedDescription);
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error {
    NSLog(@"%s: error=%@", __func__, error.localizedDescription);
    [socket disconnectForced];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initSocketIO];
    });
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"%s", __func__);
    if ([packet.name isEqualToString:@"init"]) {
        // 初期化
    } else if ([packet.name isEqualToString:@"publish"]) {
        // コメントの表示
        NSString *message = packet.args[0][@"value"];
        [self addMessage:message];
    } else if ([packet.name isEqualToString:@"like"]) {
        // いいねの表示
        NSString *countString = (NSString *)(packet.args[0][@"value"]);
        [self showLike:countString.integerValue];
    } else if ([packet.name isEqualToString:@"keyEvent"]) {
        // キーイベント
        NSString *key = (NSString *)(packet.args[0][@"keyCode"]);
        if ([key isEqualToString:@"leftArrow"]) {
            [self postKeyboardEvent:NPKeyCodeLeftArrow];
        } else if ([key isEqualToString:@"rightArrow"]) {
            [self postKeyboardEvent:NPKeyCodeRightArrow];
        }
        // それ以外は無視
    } else if ([packet.name isEqualToString:@"doTest"]) {
        // テスト
        [self doScreenTest];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end

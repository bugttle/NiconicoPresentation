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

#define MAX_MESSAGE_LINE 11

@interface AppDelegate () <SocketIODelegate>
{
    int _messageCounts[MAX_MESSAGE_LINE];
}
@property (weak) IBOutlet NSWindow *window;
@property (strong) SocketIO *socketIO;
@property (strong) NSTextField *likeCountTextField;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
//    NSRect frame = [NSScreen mainScreen].frame;
    NSRect frame = _window.screen.frame;
    
    NSColor *color = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [_window setFrame:frame display:YES animate:NO];
    //    _window resizeIncrements
    //    _window.frame.size = [NSScreen mainScreen].visibleFrame.size;

    _window.opaque = NO;
    _window.backgroundColor = color;
    [_window makeKeyAndOrderFront:nil];
    _window.level = NSScreenSaverWindowLevel;//NSStatusWindowLevel;
    _window.ignoresMouseEvents = YES;
    _window.hasShadow = NO;
    _window.styleMask = NSBorderlessWindowMask;
    
//    [_window setOpaque:NO];
//    [_window setBackgroundColor:color];
//    [_window makeKeyAndOrderFront:nil];
//    [_window setLevel:NSStatusWindowLevel];
//    [_window setIgnoresMouseEvents:YES];
//    [_window setHasShadow:NO];
//    [_window setStyleMask:NSBorderlessWindowMask];
//    [NSMenu setMenuBarVisible:NO];
    
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addMessage) userInfo:nil repeats:YES];
    
    for (int i = 0; i < MAX_MESSAGE_LINE; ++i) {
        _messageCounts[i] = 0;
    }
    
    _likeCountTextField = [self createLikeCountTextField:0];
    [_window.contentView addSubview:_likeCountTextField];
    
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    [_socketIO connectToHost:@"localhost" onPort:8080];
}

- (NSTextField *) createLikeCountTextField:(NSInteger)count {
    NSTextField *text = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 30)];
//    text.stringValue = [NSString stringWithFormat:@"%ld", count];
    text.font = [NSFont systemFontOfSize:20.0f];
    text.bezeled = NO;
    text.drawsBackground = NO;
    text.editable = NO;
    text.selectable = NO;
    text.usesSingleLineMode = YES;
    text.wantsLayer = YES;
//    text.alphaValue = 0.0f;
    
    NSDictionary *textAttributes = @{//NSFontAttributeName: text.font,
                                     NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-2.0],
                                     NSStrokeColorAttributeName:[NSColor whiteColor],
                                     NSForegroundColorAttributeName:[NSColor blackColor]};
    text.attributedStringValue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", count] attributes:textAttributes];
    return text;
}

- (void)showLikeImage:(NSInteger)count {
    NSImageView *view = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 200, 171)];
    view.image = [NSImage imageNamed:@"FacebookLike.png"];
    [_window.contentView addSubview:view];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 2.0f;
        view.animator.frame = NSOffsetRect(view.frame, 0, 100);
        view.animator.alphaValue = 0.0;
    } completionHandler:^{
        [view removeFromSuperview];
    }];
    
    NSDictionary *textAttributes = @{//NSFontAttributeName: text.font,
                                     NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-2.0],
                                     NSStrokeColorAttributeName:[NSColor whiteColor],
                                     NSForegroundColorAttributeName:[NSColor blackColor]};
    _likeCountTextField.attributedStringValue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", count] attributes:textAttributes];
    _likeCountTextField.alphaValue = 1.0f;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 2.0f;
        _likeCountTextField.animator.alphaValue = 0.0;
    } completionHandler:nil];
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

//    NSRect frame = [NSScreen mainScreen].visibleFrame;  // {{0, 65}, {1680, 962}}
//    NSRect frame = [NSScreen mainScreen].frame;  // {{0, 0}, {1680, 1050}}

    NSRect frame = _window.screen.visibleFrame;
    NSLog(@"frame=%@", NSStringFromRect(frame));

    //    NSTextField *text = [[NSTextField alloc] initWithFrame:NSMakeRect(30, 30, 300, 300)];
    float height = 88.0f;
    NSTextField *text = [[NSTextField alloc] initWithFrame:NSMakeRect(0, frame.size.height-(height*index), frame.size.width, height)];
    text.font = [NSFont systemFontOfSize:72.0f];
    text.stringValue = message;
    text.bezeled = NO;
    text.drawsBackground = NO;
    text.editable = NO;
    text.selectable = NO;
    text.usesSingleLineMode = YES;
    text.wantsLayer = YES;
    NSDictionary *textAttributes = @{//NSFontAttributeName: text.font,
                                     NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-2.0f],
                                     NSStrokeColorAttributeName:[NSColor whiteColor],
                                     NSForegroundColorAttributeName:[NSColor blackColor]};
    text.attributedStringValue = [[NSAttributedString alloc] initWithString:message attributes:textAttributes];

    [_window.contentView addSubview:text];
    
    NSLog(@"%@", NSStringFromRect(text.frame));
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:text.font, NSFontAttributeName, nil];
    //    float width = [text.stringValue widthForHeight:text.frame.size.height attributes:attributes];
    float width = [text.stringValue widthForHeight:600 attributes:attributes];
    NSLog(@"width = %f", width);
    if (text.frame.size.width < width) {
        [text setFrameSize:CGSizeMake(width, text.frame.size.height)];
    }
    // this is what widthForHeight internally does:
    //    NSSize size = [text.stringValue sizeForWidth:FLT_MAX height:text.frame.size.height attributes:attributes];
    //    NSLog(@"size = %@", NSStringFromSize(size));
    
    
    
    //    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[text font],NSFontAttributeName,nil];
    //    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[text stringValue] attributes:attributes];
    //    attributedString
    //    CGFloat height = [attributedString heightForWidth:[text frame].size.width];
    
    
    [self bounceTimeLabel:text withWidth:width withDuration:5 atIndex:index];
}

- (void)bounceTimeLabel:(NSView *)view withWidth:(float)width withDuration:(float)duration atIndex:(int)index
{
   
//        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//            context.duration = 20.f;
//            view.animator.frame = CGRectOffset(view.frame, 400, 0);
//        } completionHandler:nil];
    
    
//    NSRect newFrame = CGRectMake(-view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
//    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//    [dict setObject:view forKey:NSViewAnimationTargetKey];
//    //    [dict setObject:NSViewAnimationFadeInEffect forKey:NSViewAnimationEffectKey];
//    [dict setObject:[NSValue valueWithRect:view.frame] forKey:NSViewAnimationStartFrameKey];
//    [dict setObject:[NSValue valueWithRect:newFrame] forKey:NSViewAnimationEndFrameKey];
//    
//    NSViewAnimation *anim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:dict]];
//    [anim setDuration:duration];
//    [anim setAnimationCurve:NSAnimationLinear];
//    [anim startAnimation];

    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [view removeFromSuperview];
        --(_messageCounts[index]);

        NSMutableString *str = [NSMutableString string];
        for (int i = 1; i < MAX_MESSAGE_LINE; ++i) {
            [str appendFormat:@"%d,", _messageCounts[i]];
        }
        NSLog(@"%@", str);
    }];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.duration = duration;
    NSLog(@"duration:%lf, %lf",animation.duration, log(width));
    animation.fromValue = [NSNumber numberWithFloat:view.frame.size.width];
    animation.toValue = [NSNumber numberWithFloat:-(width)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:@"moveby"];
    [CATransaction commit];
    
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//    [pathAnimation setDuration:1];
//    [pathAnimation setFromValue:[NSValue valueWithPoint:view.frame.origin]];
//    [pathAnimation setToValue:[NSValue valueWithPoint:NSPointFromCGPoint(CGPointMake(view.frame.origin.x-100, 0))]];
//    [CATransaction setCompletionBlock:^{
////        _lastPoint = _currentPoint; _currentPoint = CGPointMake(_lastPoint.x + _wormStepHorizontalValue, _wormStepVerticalValue);
//        NSLog(@"finished!!!!!!!!");
//    }];
//    [view.layer addAnimation:pathAnimation forKey:@"strokeEnd"];
//    [CATransaction commit];
    
    
    
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.fromValue = [NSValue valueWithPoint:view.frame.origin];
//    animation.toValue = [NSValue valueWithPoint:CGPointMake(0, view.frame.origin.y)];
//    [view.layer addAnimation:animation forKey:nil];

//    CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    move.values = [NSArray arrayWithObjects:
//                   [NSValue valueWithPoint:view.frame.origin],
//                   [NSValue valueWithPoint:CGPointMake(view.frame.origin.x-100, view.frame.origin.y-100)],
//                   nil];
//    move.calculationMode = kCAAnimationLinear;
//    [move setDuration:3];
//    [view.layer addAnimation:move forKey:@"position"];
//    move.removedOnCompletion = YES;
    
    
//         // Create a key frame animation
//        CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    
//        // Create the values it will pass through
//        CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
//        CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
//        CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
//        CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
//        [bounce setValues:[NSArray arrayWithObjects:
//                           [NSValue valueWithCATransform3D:CATransform3DIdentity],
//                           [NSValue valueWithCATransform3D:forward],
//                           [NSValue valueWithCATransform3D:back],
//                           [NSValue valueWithCATransform3D:forward2],
//                           [NSValue valueWithCATransform3D:back2],
//                           [NSValue valueWithCATransform3D:CATransform3DIdentity],
//                           nil]];
//        // Set the duration
//        [bounce setDuration:0.6];
//    
//        // Animate the layer
//    
//        NSLog(@"The layer is %@", [view layer]);
//    
//        if (!view) {
//            NSLog(@"Textfeild is nil");
//        } else {
//            NSLog(@"Testfield exists and is of type: %@", [view class]);
//        }
//    
//    
//        [[view layer] addAnimation:bounce forKey:@"bounceAnimation"];
    
    
    
}

- (void) socketIODidConnect:(SocketIO *)socket {
    NSLog(@"%s", __func__);
    [socket sendEvent:@"connected" withData:@"11111"];
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error {
    
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet
{
    NSLog(@"%s", __func__);
    NSLog(@"packet:%@", packet);
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    NSLog(@"%s", __func__);
    NSLog(@"packet:%@", packet);
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"%s", __func__);
    if ([packet.name isEqualToString:@"init"]) {
        
    } else if ([packet.name isEqualToString:@"publish"]) {
        NSString *message = packet.args[0][@"value"];
        [self addMessage:message];
    } else if ([packet.name isEqualToString:@"like"]) {
        NSString *countString = (NSString *)(packet.args[0][@"value"]);
        [self showLikeImage:countString.integerValue];
    }
    //        if ([packet.name isEqualToString:@"message:receive"]) {
    //                // メッセージが空でなければ追加
    //                if (packet.args[0][@"message"]) {
    //                        [self.datas insertObject:packet.args[0][@"message"] atIndex:0];
    //                        [self.tableView reloadData];
    //                    }
    //            }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end

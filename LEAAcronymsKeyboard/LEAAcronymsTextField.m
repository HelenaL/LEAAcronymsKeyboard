//
//  LEAAcronymsTextField.m
//  AcronymsKeyboard
//
//  Created by Леночка on 02.02.14.
//  Copyright (c) 2014 LEA. All rights reserved.
//

#import "LEAAcronymsTextField.h"

#define PORTRAIT_SIZE 216
#define LANDSCAPE_SIZE 160
#define ANIMATION_SHIFT 400

@interface LEAAcronymsTextField()
{
    LEAAcronymsKeyboardView *acronymView;
    SystemSoundID soundID;
    BOOL isAcronymViewShowed;
}
@end

@implementation LEAAcronymsTextField

#pragma mark Initialization

-(id) init
{
    self = [super init];
    if (self)
    {
        [self initer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initer];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initer];
    }
    return self;
}

-(void) initer
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"LEAAcronym.bundle/click1" ofType:@"mp3"];
    CFURLRef soundURL = (__bridge CFURLRef)[NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(soundURL, &soundID);
 
    self.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *openAcronymsButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[openAcronymsButton setTitle:@"@" forState:UIControlStateNormal];
    openAcronymsButton.frame = CGRectMake(0, 0, 30, 30);
    [openAcronymsButton setImage: [UIImage imageNamed:@"LEAAcronym.bundle/asap.png"] forState: UIControlStateNormal];
    self.rightView = openAcronymsButton;
    
    [openAcronymsButton  addTarget:self action: @selector(openAcronymsKeyboard:) forControlEvents: UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(closeAcronymsKeyboard:) forControlEvents:UIControlEventAllTouchEvents];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark -
#pragma mark Acronym Delegate

-(void) acronymsDidSelect: (NSString *) acronym
{
    AudioServicesPlaySystemSound(soundID);
    NSString *string = [NSString stringWithFormat:@"%@ %@", self.text, acronym];
    self.text = string;
}

-(void) removeLastChar
{
    AudioServicesPlaySystemSound(soundID);
    
    NSString *string = self.text;
    if (string.length > 0) {
        self.text = [string substringToIndex: string.length - 1];
    }
}

#pragma mark -
#pragma mark Open/Close View

- (void) openAcronymsKeyboard: (id) sender
{
    if (isAcronymViewShowed == NO) {
        
        [self resignFirstResponder];

        if (!acronymView) {
            acronymView = [[LEAAcronymsKeyboardView alloc] initWithFrame:[self rectForCurrentOrientation]
                                                               backColor:self.keyboardBackgroundColor
                                                               textColor:self.keyboardTextColor
                                                               splitLineColor:self.keyboardSplitLineColor];
            acronymView.clipsToBounds = YES;
            acronymView.delegate = self;
            [self.superview addSubview:acronymView];
            //[self addSubview: acronymView];
        }
        
        [acronymView updateLines];
        acronymView.frame = [self rectForCurrentOrientation];
        acronymView.frame = CGRectOffset(acronymView.frame, 0, ANIMATION_SHIFT);
        
        [UIView animateWithDuration:0.3 animations:^{
            acronymView.frame = CGRectOffset(acronymView.frame, 0, -ANIMATION_SHIFT);
        }];
    }
    isAcronymViewShowed = YES;
    
}

- (void) closeAcronymsKeyboard: (id) sender
{
    if (isAcronymViewShowed) {
        [self becomeFirstResponder];
        
        if (acronymView) {
            [UIView animateWithDuration:0.3 animations:^{
                acronymView.frame = CGRectOffset(acronymView.frame, 0, ANIMATION_SHIFT);
            } completion:^(BOOL finished) {
                [acronymView removeFromSuperview];
                acronymView = nil;
            }];
        }
    }
    
    isAcronymViewShowed = NO;
}

#pragma mark -
#pragma mark Orientation

-(CGRect) rectForCurrentOrientation
{
    UIInterfaceOrientation interfaceOrientation = [self currentInterfaceOrientation];
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        return CGRectMake(0, size.height - PORTRAIT_SIZE, size.width, PORTRAIT_SIZE);
    }
    else
    {
        return CGRectMake(0, size.width - LANDSCAPE_SIZE, size.height, LANDSCAPE_SIZE);
    }
}

- (void)orientationDidChange:(NSNotification *)note
{
    NSArray *supportedOrientations = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"];
    if (!supportedOrientations) supportedOrientations = @[];
    
    UIInterfaceOrientation interfaceOrientation = [self currentInterfaceOrientation];
    
    NSString *currentOrientationString = [self NSStringFromUIInterfaceOrientation:interfaceOrientation];
    if ([supportedOrientations containsObject:currentOrientationString] || supportedOrientations.count == 0)
    {
        acronymView.frame = [self rectForCurrentOrientation];
        [acronymView updateLines];
    }
}

-(UIInterfaceOrientation) currentInterfaceOrientation
{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (deviceOrientation == UIDeviceOrientationFaceUp || deviceOrientation == UIDeviceOrientationFaceDown || deviceOrientation == UIDeviceOrientationUnknown) return [[UIApplication sharedApplication] statusBarOrientation];
    return (UIInterfaceOrientation)deviceOrientation;
}

-(NSString *) NSStringFromUIInterfaceOrientation:(UIInterfaceOrientation) orientation
{
	switch (orientation) {
		case UIInterfaceOrientationPortrait:           return @"UIInterfaceOrientationPortrait";
		case UIInterfaceOrientationPortraitUpsideDown: return @"UIInterfaceOrientationPortraitUpsideDown";
		case UIInterfaceOrientationLandscapeLeft:      return @"UIInterfaceOrientationLandscapeLeft";
		case UIInterfaceOrientationLandscapeRight:     return @"UIInterfaceOrientationLandscapeRight";
	}
	return @"UIInterfaceOrientationPortrait";
}

#pragma mark -
#pragma mark Properties

-(UIColor *) keyboardBackgroundColor
{
    if (!_keyboardBackgroundColor)
    {
        _keyboardBackgroundColor = [UIColor whiteColor];
    }
    return _keyboardBackgroundColor;
}

-(UIColor *) keyboardTextColor
{
    if (!_keyboardTextColor)
    {
        _keyboardTextColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1.0];
    }
    return _keyboardTextColor;
}

-(UIColor *) keyboardSplitLineColor
{
    if (!_keyboardSplitLineColor)
    {
        _keyboardSplitLineColor = [UIColor lightGrayColor];
    }
    return _keyboardSplitLineColor;
}

@end

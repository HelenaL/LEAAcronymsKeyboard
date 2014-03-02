//
//  LEAAcronymsTextField.h
//  AcronymsKeyboard
//
//  Created by Леночка on 02.02.14.
//  Copyright (c) 2014 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LEAAcronymsKeyboardView.h"

@interface LEAAcronymsTextField : UITextField<LEACustomKeyboardDelegate>

/**
 Keyboard Text Color. Default is [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1.0].
*/
@property (strong, nonatomic) UIColor *keyboardTextColor;

/**
 Keyboard Background Color. Default is [UIColor whiteColor].
*/
@property (strong, nonatomic) UIColor *keyboardBackgroundColor;

/**
 Keyboard Split Line Color. Default is [UIColor lightGrayColor].
*/
@property (strong, nonatomic) UIColor *keyboardSplitLineColor;

@end

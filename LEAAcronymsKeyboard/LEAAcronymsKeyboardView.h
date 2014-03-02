//
//  LEAAcronymsKeyboardView.h
//  AcronymsKeyboard
//
//  Created by Леночка on 02.02.14.
//  Copyright (c) 2014 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LEACustomKeyboardDelegate <NSObject>

-(void) acronymsDidSelect: (NSString *) acronym;
-(void) removeLastChar;

@end

@interface LEAAcronymsKeyboardView : UIView

- (id)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor textColor:(UIColor *)textColor splitLineColor:(UIColor *)splitColor;
- (void)updateLines;

@property (weak) id<LEACustomKeyboardDelegate> delegate;;

@end

//
//  LEAAcronymsKeyboardView.m
//  AcronymsKeyboard
//
//  Created by Леночка on 02.02.14.
//  Copyright (c) 2014 LEA. All rights reserved.
//
#define BUTTON_COUNT 19
#define ITEMS_IN_ROW 5
#define ITEMS_IN_COL 4

#import "LEAAcronymsKeyboardView.h"

@interface LEAAcronymsKeyboardView()

@property (strong) UIColor *keyboardTextColor;
@property (strong) UIColor *keyboardBackgroundColor;
@property (strong) UIColor *keyboardSplitLineColor;

@end

@implementation LEAAcronymsKeyboardView

#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor textColor:(UIColor *)textColor splitLineColor:(UIColor *)splitColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keyboardBackgroundColor = backColor;
        self.keyboardSplitLineColor = splitColor;
        self.keyboardTextColor = textColor;
        [self initer];
    }
    return self;
}

-(void) initer
{
    self.backgroundColor = self.keyboardBackgroundColor;
    [self createButtons];
    [self updateLines];
}

#pragma mark -

-(NSArray *) titleArray
{
    return @[@"10Q", @"AFK", @"ASAP", @"Aight", @"AITR", @"B4N", @"BI5", @"BZ", @"CT", @"CUL8R", @"CYT", @"G2B", @"LOL", @"PLZ", @"SOS", @"SYS", @"W8AM", @"WU", @"XOXO"];
}

#pragma mark Draw Buttons

-(void) createButtons
{
    NSArray *titles = [self titleArray];
    
    NSInteger buttonWeight = CGRectGetWidth(self.frame) / ITEMS_IN_ROW;
    NSInteger buttonHeight =  CGRectGetHeight(self.frame) / ITEMS_IN_COL;
  
    for (NSInteger i = 0; i < MIN(BUTTON_COUNT, titles.count); i++) {
        NSInteger x = i % 5;
        NSInteger y = i / 5;
        UIButton *button = [self createButton:CGRectMake(x * buttonWeight, y * buttonHeight, buttonWeight, buttonHeight) withTitle:titles[i]];
        [self addSubview:button];
    }
    
    if (titles.count <= BUTTON_COUNT) {
        NSInteger x = titles.count % 5;
        NSInteger y = titles.count / 5;
        UIButton *button = [self createButton:CGRectMake(x * buttonWeight, y * buttonHeight, buttonWeight, buttonHeight) withImage:[UIImage imageNamed:@"LEAAcronym.bundle/backSP.png"]];
        [self addSubview:button];
    }
}

-(UIButton *)createButton:(CGRect)rect withTitle:(NSString *)ttl
{
    UIButton *button = [self createButton:rect];
    [button setTitle:ttl forState:UIControlStateNormal];
    [button addTarget:self action:@selector(keyboardButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(UIButton *)createButton:(CGRect)rect withImage:(UIImage *) img
{
    UIButton *button = [self createButton:rect];
    [button setImage:img forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(UIButton *)createButton:(CGRect)rect
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setTitleColor:self.keyboardTextColor forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    return button;
}

#pragma mark -
#pragma mark Draw Lines

-(void)updateLines
{
    NSMutableArray *toRemove = [NSMutableArray new];
    for (NSInteger i = 0; i < self.layer.sublayers.count; i++) {
        CALayer *layer = self.layer.sublayers[i];
        if ([layer isKindOfClass:[CAShapeLayer class]])
        {
            [toRemove addObject:layer];
        }
    }
    [toRemove makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    NSInteger buttonWeight = CGRectGetWidth(self.frame) / ITEMS_IN_ROW;
    NSInteger buttonHeight =  CGRectGetHeight(self.frame) / ITEMS_IN_COL;
    for (NSInteger i = 0; i < ITEMS_IN_ROW; i++) {
        CAShapeLayer *line = [self lineFrom:CGPointMake(i*buttonWeight, 0) to:CGPointMake(i*buttonWeight, buttonHeight* ITEMS_IN_COL)];
        [self.layer addSublayer:line];
    }
    
    for (NSInteger i = 0; i < ITEMS_IN_COL; i++) {
        CAShapeLayer *line = [self lineFrom:CGPointMake(0, i*buttonHeight) to:CGPointMake(buttonWeight* ITEMS_IN_ROW, i*buttonHeight)];
        [self.layer addSublayer:line];
    }
}

-(CAShapeLayer *)lineFrom:(CGPoint )fromPoint to:(CGPoint)toPoint
{
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:fromPoint];
    [linePath addLineToPoint:toPoint];
    line.path = linePath.CGPath;
    
    line.fillColor = self.keyboardSplitLineColor.CGColor;
    line.strokeColor = self.keyboardSplitLineColor.CGColor;
    return line;
}

#pragma mark -
#pragma mark Button Handlers

- (void) keyboardButtonDidClick: (UIButton *) sender
{
    if ([self.delegate respondsToSelector:@selector(acronymsDidSelect:)]) {
        [self.delegate  acronymsDidSelect: sender.titleLabel.text];
    }
}

- (void) clearButtonDidClick: (UIButton *) sender
{
    if ([self.delegate respondsToSelector:@selector(removeLastChar)]) {
        [self.delegate removeLastChar];
    }
}

#pragma mark -
#pragma mark Colors Property

@end

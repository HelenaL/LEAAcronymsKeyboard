//
//  LEAViewController.m
//  AcronymsKeyboard
//
//  Created by Леночка on 02.02.14.
//  Copyright (c) 2014 LEA. All rights reserved.
//

#import "LEAViewController.h"
#import "LEAAcronymsKeyboardView.h"


@interface LEAViewController ()

@end

@implementation LEAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.acronymsTextField becomeFirstResponder];
//    self.acronymsTextField.keyboardBackgroundColor = [UIColor redColor];
    
}

@end

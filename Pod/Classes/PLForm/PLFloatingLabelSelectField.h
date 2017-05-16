//
//  PLFloatingLabelSelectField.h
//  PLForm
//
//  Created by Ash Thwaites on 11/12/2015.
//  Copyright (c) 2015 Pitch Labs. All rights reserved.
//


#import "PLFormSelectField.h"

@interface PLFloatingLabelSelectField : PLFormSelectField

@property (nonatomic, readonly) UILabel *floatingLabel;

@property (nonatomic, strong) IBInspectable UIFont *floatingFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) IBInspectable UIColor *floatingColor UI_APPEARANCE_SELECTOR;

@end

//
//  PLFormTextField.h
//  PLForm
//
//  Created by Ash Thwaites on 11/12/2015.
//  Copyright (c) 2015 Pitch Labs. All rights reserved.
//


#import "PLStyleView.h"
#import "PLFormElement.h"

typedef enum {
    BBTextInputTypeText,
    BBTextInputTypeNumber,
    BBTextInputTypePassword,
    BBTextInputTypeEmail
} BBTextInputType;


@interface PLFormTextFieldElement : PLFormElement

// Designated initializer
+ (instancetype)textInputElementWithID:(NSInteger)elementID placeholderText:(NSString *)placeholderText value:(NSString *)value delegate:(id<PLFormElementDelegate>)delegate;
+ (instancetype)numberInputElementWithID:(NSInteger)elementID placeholderText:(NSString *)placeholderText value:(NSString *)value delegate:(id<PLFormElementDelegate>)delegate;
+ (instancetype)passwordInputElementWithID:(NSInteger)elementID placeholderText:(NSString *)placeholderText value:(NSString *)value delegate:(id<PLFormElementDelegate>)delegate;
+ (instancetype)emailInputElementWithID:(NSInteger)elementID placeholderText:(NSString *)placeholderText value:(NSString *)value delegate:(id<PLFormElementDelegate>)delegate;

@property (nonatomic, copy) NSString* value;
@property (nonatomic, copy) NSString* placeholderText;
@property (nonatomic, copy) NSString* originalValue;
@property (nonatomic, assign) BBTextInputType inputType;

@end


@interface PLFormTextField : PLStyleView <UITextFieldDelegate>

@property (nonatomic, strong) PLFormTextFieldElement* element;

@property (nonatomic, readonly) UITextField *textfield;
@property (nonatomic) /*IBInspectable*/ NSString *text;
@property (nonatomic) /*IBInspectable*/ NSString *placeholder;
@property (nonatomic) UIEdgeInsets contentInsets;

-(void)textFieldDidChange;
-(void)updateWithElement:(PLFormTextFieldElement*)element;

@end
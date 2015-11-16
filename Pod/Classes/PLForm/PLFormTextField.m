
//
//  PLFormTextField.m
//  PLForm
//
//  Created by Ash Thwaites on 11/12/2015.
//  Copyright (c) 2015 Pitch Labs. All rights reserved.
//


#import "PLFormTextField.h"
#import "PLStyleSettings.h"
#import "PureLayout.h"
#import "PLExtras-UIView.h"



@implementation PLFormTextFieldElement


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (instancetype)textInputElementWithID:(NSInteger)elementID placeholderText:(NSString *)placeholderText value:(NSString *)value delegate:(id<PLFormElementDelegate>)delegate
{
    PLFormTextFieldElement* element = [[self alloc] init];
    element.elementID = elementID;
    element.delegate = delegate;
    element.placeholderText = placeholderText;
    element.value = value;
    element.originalValue = value;
    element.inputType = BBTextInputTypeText;
    return element;
}

+ (instancetype)numberInputElementWithID:(NSInteger)elementID placeholderText:(NSString *)placeholderText value:(NSString *)value delegate:(id<PLFormElementDelegate>)delegate
{
    PLFormTextFieldElement* element = [self textInputElementWithID:elementID placeholderText:placeholderText value:value delegate:delegate];
    element.inputType = BBTextInputTypeNumber;
    return element;
}

+ (instancetype)passwordInputElementWithID:(NSInteger)elementID placeholderText:(NSString *)placeholderText value:(NSString *)value delegate:(id<PLFormElementDelegate>)delegate
{
    PLFormTextFieldElement* element = [self textInputElementWithID:elementID placeholderText:placeholderText value:value delegate:delegate];
    element.inputType = BBTextInputTypePassword;
    return element;
}

+ (instancetype)emailInputElementWithID:(NSInteger)elementID placeholderText:(NSString *)placeholderText value:(NSString *)value delegate:(id<PLFormElementDelegate>)delegate
{
    PLFormTextFieldElement* element = [self textInputElementWithID:elementID placeholderText:placeholderText value:value delegate:delegate];
    element.inputType = BBTextInputTypeEmail;
    return element;
}

-(NSString*)valueAsString
{
    return self.value;
}

@end


@implementation PLFormTextField

@synthesize placeholderColor = _placeholderColor;

-(void)setup
{
    [super setup];
    
    _textfield = [[UITextField alloc] initWithFrame:self.bounds];
    [_textfield addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    _textfield.font = [PLStyleSettings sharedInstance].h1Font;
    _textfield.delegate = self;
    [self addSubview:_textfield];
    
    _contentInsets = UIEdgeInsetsMake(2, 10, 2, 10);
}


-(void)dealloc
{
    [self resignFirstResponder];
}


-(void)setFont:(UIFont *)font
{
    _textfield.font = font;
}

-(UIFont*)font
{
    return _textfield.font;
}

-(void)setTextColor:(UIColor *)color
{
    _textfield.textColor = color;
}

-(UIColor *)textColor
{
    return _textfield.textColor;
}


-(void)setPlaceholderColor:(UIColor *)color
{
    _placeholderColor = color;
    _textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_textfield.placeholder attributes:@{NSForegroundColorAttributeName:_placeholderColor}];
}

-(UIColor*)placeholderColor
{
    return _placeholderColor;
}

-(void)removeInsetContraints
{
    for (NSLayoutConstraint *constraint in self.constraints)
    {
        if ((constraint.firstItem == _textfield) ||
            (constraint.secondItem == _textfield))
        {
            [self removeConstraint:constraint];
        }
    }
    [self setNeedsUpdateConstraints];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    _contentInsets = contentInsets;
    [self removeInsetContraints];
}

- (void)updateConstraints
{
    if (![self hasConstraintsForView:_textfield] && self.superview)
    {
        [_textfield autoPinEdgesToSuperviewEdgesWithInsets:_contentInsets];
    }
    [super updateConstraints];
}


-(void)updateWithElement:(PLFormTextFieldElement*)element
{
    self.element = element;
    self.placeholder = element.placeholderText;
    self.text = element.value;
    if (element.inputType == BBTextInputTypeNumber)
    {
        _textfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (element.inputType == BBTextInputTypeEmail)
    {
        _textfield.keyboardType = UIKeyboardTypeEmailAddress;
        _textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else if (element.inputType == BBTextInputTypePassword)
    {
        _textfield.keyboardType = UIKeyboardTypeDefault;
        _textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textfield.secureTextEntry = YES;
    }
    else
    {
        _textfield.keyboardType = UIKeyboardTypeDefault;
        _textfield.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
}



- (void)setPlaceholder:(NSString *)placeholder
{
    if (_placeholderColor)
    {
        _textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_textfield.placeholder attributes:@{NSForegroundColorAttributeName:_placeholderColor}];
    }
    else
    {
        [_textfield setPlaceholder:placeholder];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (BOOL)canBecomeFirstResponder
{
    return [_textfield canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    return [_textfield becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [_textfield resignFirstResponder];
}

-(void)setText:(NSString *)text
{
    _textfield.text = text;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange {
    // call the delegate to inform of value changed
    self.element.value = _textfield.text;
    if ([self.element.delegate respondsToSelector:@selector(formElementDidChangeValue:)])
    {
        [(id<PLFormElementDelegate>)self.element.delegate formElementDidChangeValue:self.element];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    // call the delegate to inform of value changed
    if ([self.element.delegate respondsToSelector:@selector(formElementDidEndEditing:)])
    {
        [(id<PLFormElementDelegate>)self.element.delegate formElementDidEndEditing:self.element];
    }
}



-(NSString*)text
{
    return _textfield.text;
}


@end

//
//  Formula.m
//  Turnstyle
//
//  Created by Darcy on 2020-05-10.
//  Copyright © 2020 Darcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Formula.h"

@interface Formula (private)

-(void)_setFormula:(NSString *)aFormula adopt:(BOOL)adoptFormula wffCheck:(BOOL)wffFormula
   withConstantSet:(NSCharacterSet *)aConstantSet andVariableSet:(NSCharacterSet *)aVariableSet withFreeVariables:(BOOL)allowsFreeVariables;
-(void)_setConstantSet:(NSCharacterSet *)aConstantSet;
-(void)_setVariableSet:(NSCharacterSet *)aVariableSet;
-(void)_setFreeVariables:(BOOL)allowsFreeVariables;
-(void)_setFormulaDirectly:(NSString *)aFormula;
-(void)_setFormulaLength:(NSUInteger)aFormulaLength;
-(void)_setFormulaKey:(NSString *)aFormulaKey;
-(void)_setUnswappedFormula:(NSString *)anUnswappedFormula;
-(NSString *)_formulaKey;

-(void)_adoptFormula;
-(NSString *)_generateFormulaKey:(NSString *)aFormula;

-(NSString *)_cleanFormula:(NSString *)aFormula withFormulaKey:(NSString *)aFormulaKey;
-(NSString *)_parenthesiseFormula:(NSString *)aFormula withFormulaKey:(NSString *)aFormulaKey;
-(NSString *)_swapIdentity:(NSString *)aFormula;
-(NSString *)_unswapIdentity:(NSString *)aFormula;

-(NSRange)_findScopeOf:(NSUInteger)connectivePosition;
-(void)_findMainConnective;
-(void)_findBranches;
-(NSString *)_findLeftBranch;
-(NSString *)_findCentreBranch;
-(NSString *)_findRightBranch;

-(void)_checkAtomic;
-(BOOL)_checkWff:(Formula *)aFormula;
-(BOOL)_checkQuantifier:(NSArray *)parseTree;

@end

@implementation Formula

#pragma mark Init/Dealloc/Set

-(id)init
{
    return [self initWithFormula:@""];
}


-(id)initWithFormula:(NSString *)aFormula
{
    if (nil != (self = [super init])) {
        [self _setFormula:aFormula adopt:YES wffCheck:YES withConstantSet:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrs"]
           andVariableSet:[NSCharacterSet characterSetWithCharactersInString:@"tuvwxyz"] withFreeVariables:NO];
    }
    return self;
}

-(void)setFormula:(NSString *)aFormula
{
    [self _setFormula:aFormula adopt:YES wffCheck:YES withConstantSet:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrs"]
       andVariableSet:[NSCharacterSet characterSetWithCharactersInString:@"tuvwxyz"] withFreeVariables:NO];
}

-(void)setFormula:(NSString *)aFormula withConstantSet:(NSCharacterSet *)aConstantSet andVariableSet:(NSCharacterSet *)aVariableSet
{
    [self _setFormula:aFormula adopt:YES wffCheck:YES withConstantSet:aConstantSet andVariableSet:aVariableSet withFreeVariables:NO];
}

-(void)setFormula:(NSString *)aFormula withConstantSet:(NSCharacterSet *)aConstantSet andVariableSet:(NSCharacterSet *)aVariableSet withFreeVariables:(BOOL)allowsFreeVariables
{
    [self _setFormula:aFormula adopt:YES wffCheck:YES withConstantSet:aConstantSet andVariableSet:aVariableSet withFreeVariables:allowsFreeVariables];
}

-(void)setFormula:(NSString *)aFormula adopt:(BOOL)adoptFormula wffCheck:(BOOL)wffFormula
  withConstantSet:(NSCharacterSet *)aConstantSet andVariableSet:(NSCharacterSet *)aVariableSet withFreeVariables:(BOOL)allowsFreeVariables;
{
    [self _setFormula:aFormula adopt:adoptFormula wffCheck:wffFormula withConstantSet:aConstantSet andVariableSet:aVariableSet withFreeVariables:allowsFreeVariables];
}

#pragma mark Set/Get

-(NSString *)formula
{
    return formula;
}

-(NSString *)unswappedFormula
{
    return unswappedFormula;
}

-(NSUInteger)formulaLength
{
    return formulaLength;
}

-(NSUInteger)mainConnective
{
    return mainConnective;
}

-(NSString *)leftBranch
{
    return leftBranch;
}

-(NSString *)centreBranch
{
    return centreBranch;
}

-(NSString *)rightBranch
{
    return rightBranch;
}

-(NSString *)unswappedLeftBranch
{
    return [self _unswapIdentity:leftBranch];
}

-(NSString *)unswappedRightBranch
{
    return [self _unswapIdentity:rightBranch];
}

-(BOOL)wff
{
    return wff;
}

-(BOOL)atomic
{
    return atomic;
}

-(BOOL)freeVariables
{
    return freeVariables;
}

-(NSCharacterSet *)constantSet
{
    return constantSet;
}

-(NSCharacterSet *)variableSet
{
    return variableSet;
}

-(NSString *)_formulaKey
{
    return formulaKey;
}

-(void)_setFormula:(NSString *)aFormula adopt:(BOOL)adoptFormula wffCheck:(BOOL)wffFormula
   withConstantSet:(NSCharacterSet *)aConstantSet andVariableSet:(NSCharacterSet *)aVariableSet withFreeVariables:(BOOL)allowsFreeVariables
{
    if (aFormula == nil || [aFormula isEqualTo:@""]) return;
    
    // Set constant range
    [self _setConstantSet:aConstantSet];
    
    // Set variable range
    [self _setVariableSet:aVariableSet];
    
    // Set whether free variables are allowed
    [self _setFreeVariables:allowsFreeVariables];
    
    // Set formula
    [self _setFormulaDirectly:aFormula];
    
    // Set formulaLength
    [self _setFormulaLength:[formula length]];
    
    // Set formulaKey
    [self _setFormulaKey:[self _generateFormulaKey:formula]];
    
    // Adopt (cleanup) the formula
    if (adoptFormula) [self _adoptFormula];
    
    // Find and set mainConnective
    [self _findMainConnective];
    
    // Find and set leftBranch, centreBranch and rightBranch
    [self _findBranches];
    
    // Check whether the formula is atomic, and set atomic
    [self _checkAtomic];
    
    // Check whether the formula is a wff, and set wff
    if (wffFormula) wff = [self _checkWff:self];
}

-(void)_setConstantSet:(NSCharacterSet *)aConstantSet
{
    aConstantSet = [aConstantSet copy];
    constantSet = aConstantSet;
}

-(void)_setVariableSet:(NSCharacterSet *)aVariableSet
{
    aVariableSet = [aVariableSet copy];
    variableSet = aVariableSet;
}

-(void)_setFreeVariables:(BOOL)allowsFreeVariables
{
    freeVariables = allowsFreeVariables;
}

-(void)_setFormulaDirectly:(NSString *)aFormula
{
    // This function sets the formula variable directly, without any processing.
    
    aFormula = [aFormula copy];
    formula = aFormula;
}

-(void)_setFormulaLength:(NSUInteger)aFormulaLength
{
    // this formula sets formulaLength driectly, without any processing.
    
    formulaLength = aFormulaLength;
}

-(void)_setFormulaKey:(NSString *)aFormulaKey
{
    // This function sets the formulaKey directly, without any processing.
    
    aFormulaKey = [aFormulaKey copy];
    formulaKey = aFormulaKey;
}

-(void)_setUnswappedFormula:(NSString *)anUnswappedFormula
{
    // This function sets unswappedFormula directly, without any processing.
    
    anUnswappedFormula = [anUnswappedFormula copy];
    unswappedFormula = anUnswappedFormula;
}

#pragma mark Formula Preparation

-(void)_adoptFormula;
{
    // This function performs three cleanup operations on a formula: (i) delete all characters outside the lexicon, including spaces (via _cleanFormula); (ii) add courtesy outer parentheses if they did not belong to the original formula (via _parenthesiseFormula); and (iii) swap = and ≠ so that they may be treated as two-place predicates (via swapFormula).
    
    NSString *candidateFormula = [NSString stringWithString:[self formula]];
    NSString *candidateFormulaKey = [NSString stringWithString:formulaKey];
    NSString *processedFormula;
    
    // Delete all characters outside the lexicon (including spaces).  Generate a new formulaKey if necessary.
    processedFormula = [self _cleanFormula:candidateFormula withFormulaKey:candidateFormulaKey];
    if (![processedFormula isEqualToString:candidateFormula])
    {
        candidateFormula = processedFormula;
        candidateFormulaKey = [self _generateFormulaKey:candidateFormula];
    }
    
    // Add courtesy parentheses.
    processedFormula = [self _parenthesiseFormula:candidateFormula withFormulaKey:candidateFormulaKey];
    
    // Swap identity symbols.
    processedFormula = [self _swapIdentity:processedFormula];
    
    // Unswap identity symbols.  This means ~a=a will always appear as a≠a in the unswapped version.
    [self _setUnswappedFormula:[self _unswapIdentity:processedFormula]];
    
    if (![processedFormula isEqualToString:candidateFormula])
    {
        candidateFormula = processedFormula;
        candidateFormulaKey = [self _generateFormulaKey:candidateFormula];
    }
    
    // If adopting has changed things, set formula, formulaKey and formulaLength,
    if (![processedFormula isEqualToString:formula])
    {
        [self _setFormulaDirectly:candidateFormula];
        [self _setFormulaKey:candidateFormulaKey];
        [self _setFormulaLength:[candidateFormula length]];
    }
}

-(NSString *)_generateFormulaKey:(NSString *)aFormula
{
    // This function builds keyBuild, by classifying each character in aFormula as one of predicateLetter (L), identity (I), unary (U), binary (B), quantifier (Q), variable (V), constant (C), leftParenthesis ((), rightParenthesis ()), contradiction (O), or unknown (*).  formulaKey can then be used to look up the classification of a particular character without calling a classification function each time.
    
    NSUInteger length = [aFormula length];
    if (aFormula == nil || length == 0) return nil;  // Abort if no object or blank
    
    NSMutableString *newKey = [[NSMutableString alloc] init];
    NSRange scanRange, matchRange;
    
    // Define the constants for use in the regular expressions
    NSCharacterSet *predicateLetter = [NSCharacterSet uppercaseLetterCharacterSet];
    NSCharacterSet *variable = [variableSet copy];
    NSCharacterSet *constant = [constantSet copy];
    NSCharacterSet *quantifier = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%C%C",0x2200,0x2203]]; // ∀, ∃
    NSCharacterSet *identity = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"=%C",0x2260]]; // ≠
    NSCharacterSet *unary = [NSCharacterSet characterSetWithCharactersInString:@"~"];
    NSCharacterSet *binary = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%C%C%C&",0x2192,0x2194,0x2228]]; // →, ↔, ∨
    NSCharacterSet *contradiction = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%C",0x039B]]; // ⋏
    NSCharacterSet *leftParenthesis = [NSCharacterSet characterSetWithCharactersInString:@"("];
    NSCharacterSet *rightParenthesis = [NSCharacterSet characterSetWithCharactersInString:@")"];
    NSCharacterSet *placeHolder = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%C",0xFF1F]]; // ？
    
    scanRange.length = 1; // Always test one character at a time
    
    // Classify characters in formula
    for (NSUInteger i=0; i < length; i++)
    {
        scanRange.location = i; // Step through the formula
        
        matchRange = [aFormula rangeOfCharacterFromSet:predicateLetter options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {[newKey appendString:@"L"]; continue;}
        
        matchRange = [aFormula rangeOfCharacterFromSet:variable options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {[newKey appendString:@"V"]; continue;}
        
        matchRange = [aFormula rangeOfCharacterFromSet:constant options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {[newKey appendString:@"C"]; continue;}
        
        matchRange = [aFormula rangeOfCharacterFromSet:quantifier options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {[newKey appendString:@"Q"]; continue;}
        
        matchRange = [aFormula rangeOfCharacterFromSet:identity options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {[newKey appendString:@"I"]; continue;}
        
        matchRange = [aFormula rangeOfCharacterFromSet:unary options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {[newKey appendString:@"U"]; continue;}
        
        matchRange = [aFormula rangeOfCharacterFromSet:binary options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {[newKey appendString:@"B"]; continue;}
        
        matchRange = [aFormula rangeOfCharacterFromSet:contradiction options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {[newKey appendString:@"O"]; continue;}
        
        matchRange = [aFormula rangeOfCharacterFromSet:leftParenthesis options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {[newKey appendString:@"("]; continue;}
        
        matchRange = [aFormula rangeOfCharacterFromSet:rightParenthesis options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {[newKey appendString:@")"]; continue;}
        
        matchRange = [aFormula rangeOfCharacterFromSet:placeHolder options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {[newKey appendString:@"%"]; continue;}
        
        [newKey appendString:@"*"]; // Unknown character
    }
    
    return newKey;
}

-(NSString *)_cleanFormula:(NSString *)aFormula withFormulaKey:(NSString *)aFormulaKey
{
    // This function cleans up aFormula by removing illegal characters (including spaces).  Also, it assumes aFormula and aFormulaKey correspond.
    
    NSUInteger length = [aFormula length];
    if (aFormula == nil || length == 0 || [aFormula length] != length) return nil;  // Abort if no object or blank, or no correspondence
    
    NSMutableString *newFormula = [aFormula mutableCopy];
    NSString *asterix = @"*";
    NSRange searchRange = NSMakeRange(0,length);
    NSRange asterixRange;
    
    // Do a regex on "*" through formulaKey; it it exists, delete it from formulaKey and the corresponding illegal character in formula
    do {
        asterixRange = [aFormulaKey rangeOfString:asterix options:NSBackwardsSearch range:searchRange];
        if (asterixRange.length != 0) [newFormula deleteCharactersInRange:asterixRange];
        searchRange = NSMakeRange(0,asterixRange.location);
    } while (asterixRange.length != 0); // Go through aFormula ond delete any illegal characters
    
    return newFormula;
}

-(NSString *)_parenthesiseFormula:(NSString *)aFormula withFormulaKey:(NSString *)aFormulaKey
{
    // This function adds parentheses to the outside of a wff, if necessary.  Results of applying this function to a formula that is not a wff are unpredictable.  Also, it assumes that aFormula and aFormulaKey correspond.
    
    NSUInteger length = [aFormula length];
    if (aFormula == nil || length == 0 || [aFormula length] != length) return nil;  // Abort if no object or blank, or no correspondence
    
    NSString *newFormula;
    NSMutableString *newKey = [aFormulaKey mutableCopy];
    
    NSUInteger openParenthesisCount = [newKey replaceOccurrencesOfString:@"(" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0,length)];
    NSUInteger closeParenthesisCount = [newKey replaceOccurrencesOfString:@")" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0,length)];
    NSUInteger binaryCount = [newKey replaceOccurrencesOfString:@"B" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0,length)];
    NSUInteger quantifierCount = [newKey replaceOccurrencesOfString:@"Q" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0,length)];
    
    // If formula is short a pair of parentheses with respect to the number of quantifiers and binaries, add courtesy parentheses.
    if ((openParenthesisCount == closeParenthesisCount) &&
        ((binaryCount + quantifierCount) * 2 == openParenthesisCount + closeParenthesisCount + 2))
    {
        newFormula = [[NSString alloc] initWithString: [NSString stringWithFormat:@"(%@)",aFormula]];
    } else {
        newFormula = [aFormula copy];
    }
    
    return newFormula;
}

-(NSString *)_swapIdentity:(NSString *)aFormula
{
    // This function converts a sequence of characters of the form a=b (or: a≠b) to the form =ab (or: ≠ab), so that = and ≠ may be treated as two-place predicates.  The process is reversed by _unswapIdentity.
    
    NSUInteger length = [aFormula length];
    if (aFormula == nil || length == 0) return nil;  // Abort if no object or blank
    
    NSMutableString *newFormula = [aFormula mutableCopy];
    NSMutableString *swapString;
    
    NSRange scanRange;
    NSRange matchRange;
    NSRange leftTermRange;
    NSRange rightTermRange;
    
    NSCharacterSet *identity = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"=%C",0x2260]]; // ≠
    NSCharacterSet *term = [NSCharacterSet lowercaseLetterCharacterSet];
    int offSet = 0; // Tracks differences in position between aFormula and newFormula
    BOOL nonIdentity;
    
    scanRange.length = 1; // Always test one character at a time
    
    for (NSUInteger i=0; i < length; i++)
    {
        scanRange.location = i; // Step through the formula
        matchRange = [aFormula rangeOfCharacterFromSet:identity options:NSLiteralSearch range:scanRange];
        // Originally: if (matchRange.length == 1) { — See also line 541
        if (matchRange.length == 1 && matchRange.location > 0) {
            
            if (i+1 <= length-1) {
                leftTermRange = [aFormula rangeOfCharacterFromSet:term options:NSLiteralSearch range:NSMakeRange(i-1,1)];
                rightTermRange = [aFormula rangeOfCharacterFromSet:term options:NSLiteralSearch range:NSMakeRange(i+1,1)];
                if (leftTermRange.length == 1 && rightTermRange.length == 1) {
                    if ([[newFormula substringWithRange:NSMakeRange(matchRange.location+offSet,1)] isEqualToString:@"="])
                    {
                        swapString = [NSMutableString stringWithString:@"="];
                        nonIdentity = NO;
                    } else {
                        swapString = [NSMutableString stringWithString:@"~="];
                        nonIdentity = YES;
                    }
                    [swapString appendString:[newFormula substringWithRange:NSMakeRange(matchRange.location-1+offSet,1)]];
                    [swapString appendString:[newFormula substringWithRange:NSMakeRange(matchRange.location+1+offSet,1)]];
                    [newFormula deleteCharactersInRange:NSMakeRange(matchRange.location-1+offSet,3)];
                    [newFormula insertString:swapString atIndex:matchRange.location-1+offSet];
                    if (nonIdentity) offSet++;
                    i+=1;
                }
            }
        }
    }
    return newFormula;
}

-(NSString *)_unswapIdentity:(NSString *)aFormula
{
    // This function reverses _swapIdentity, returning the original, unswapped string.
    
    NSUInteger length = [aFormula length];
    if (aFormula == nil || length == 0) return nil;  // Abort if no object or blank
    
    NSMutableString *newFormula = [aFormula mutableCopy];
    NSMutableString *swapString;
    
    NSRange scanRange;
    NSRange matchRange;
    NSRange leftTermRange;
    NSRange rightTermRange;
    
    NSCharacterSet *identity = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"=%C",0x2260]]; // ≠
    NSCharacterSet *term = [NSCharacterSet lowercaseLetterCharacterSet];
    int offSet = 0; // Tracks differences in position between aFormula and newFormula
    BOOL nonIdentity;
    
    scanRange.length = 1; // Always test one character at a time
    
    for (NSUInteger i=0; i < length; i++)
    {
        scanRange.location = i; // Step through the formula
        matchRange = [aFormula rangeOfCharacterFromSet:identity options:NSLiteralSearch range:scanRange];
        if (matchRange.length == 1) {
            
            if (i+2 <= length-1) {
                leftTermRange = [aFormula rangeOfCharacterFromSet:term options:NSLiteralSearch range:NSMakeRange(i+1,1)];
                rightTermRange = [aFormula rangeOfCharacterFromSet:term options:NSLiteralSearch range:NSMakeRange(i+2,1)];
                if (leftTermRange.length == 1 && rightTermRange.length == 1) {
                    swapString = [NSMutableString stringWithString:[newFormula substringWithRange:NSMakeRange(matchRange.location+1+offSet,1)]];
                    // Originally: if (matchRange.location-1 >= 0 && — see also line 477
                    if (matchRange.location >= 1 &&
                        [[newFormula substringWithRange:NSMakeRange(matchRange.location-1+offSet,2)] isEqualToString:@"~="])
                    {
                        [swapString appendString:@"≠"];
                        nonIdentity = YES;
                    } else {
                        [swapString appendString:@"="];
                        nonIdentity = NO;
                    }
                    [swapString appendString:[newFormula substringWithRange:NSMakeRange(matchRange.location+2+offSet,1)]];
                    if (nonIdentity) {
                        [newFormula deleteCharactersInRange:NSMakeRange(matchRange.location-1+offSet,4)];
                        [newFormula insertString:swapString atIndex:matchRange.location-1+offSet];
                        i+=2;
                        offSet--;
                    } else {
                        [newFormula deleteCharactersInRange:NSMakeRange(matchRange.location+offSet,3)];
                        [newFormula insertString:swapString atIndex:matchRange.location+offSet];
                        i+=2;
                    }
                }
            }
        }
    }
    return newFormula;
}

#pragma mark Analysis

-(NSRange)_findScopeOf:(NSUInteger)connectivePosition
{
    // This function finds the scope of the connective at connectivePosition.  It returns (0,0) if an error is encountered (which probably indicates that formula is not a wff).  It generates leftScope and rightScope, and extrapolates the range that corresponds to the scope of the connective.  It does not follow Forbes' convention on the scope of unaries and quantifiers; the leading unary or quantifier must be stripped in order to be consistent with Forbes.
    
    NSRange connectiveRange;
    long leftPosition;
    long rightPosition;
    
    NSUInteger leftScope = 0;
    NSUInteger rightScope = 0;
    long parenthesisDepth = 0;
    long parenthesisDepthRight = 0;
    
    connectiveRange.location = 0;
    connectiveRange.length = 0;
    
    // Abort if connectivePosition outside range.
    if (connectivePosition > formulaLength - 1) return connectiveRange;
    if ([formulaKey isEqualToString:@""]) return connectiveRange;
    
    // Check to see which connective.  If leftPosition is set to -1, it will skip out of the second for loop.  Quantifiers are taken in a single chunk.
    switch ([formulaKey characterAtIndex:connectivePosition])
    {
        case 'Q':
            leftPosition = - 1; rightPosition = connectivePosition + 3;
            leftScope += 1; rightScope += 2; break;
            
        case 'U':
            leftPosition = - 1; rightPosition = connectivePosition + 1;
            break;
            
        case 'B':
            leftPosition = connectivePosition - 1; rightPosition = connectivePosition + 1;
            leftScope += 1; rightScope += 1; break;
            
        default:
            return connectiveRange; break; // Abort if not a connective
    }
    
    if (leftPosition < -1 || rightPosition > formulaLength - 1) return connectiveRange; // Abort if left/rightPosition outside allowable range
    
    // To the right; applies to every connective.  If binary, check to see if we are in parentheses; if not, the we are at the end of the rightScope.  If open parenthesis, check to see if it is the beginning of a quantifier; if not, increase parenthesisDepth by one.  If close parenthesis, decrease parenthesisDepth and exit loop if parenthesisDepth is not > 0.
    parenthesisDepth = 0;
    for (long i = rightPosition; i < formulaLength; i++)
    {
        switch ([formulaKey characterAtIndex:i])
        {
            case 'U':
                rightScope++; break;
                
            case 'B':
                if (parenthesisDepth == 0)
                {
                    i = formulaLength; continue;
                }
                else rightScope++; break;
                
            case '(':
                if (i+1 <= formulaLength-1 && [formulaKey characterAtIndex:i+1] == 'Q')
                {
                    rightScope += 4; i += 3; break;
                }
                else
                {
                    rightScope++; parenthesisDepth++; break;
                }
                
            case ')':
                parenthesisDepth--;
                if (parenthesisDepth > 0)
                {
                    rightScope++; break;
                }
                else if (parenthesisDepth == 0)
                {
                    rightScope++; i = formulaLength; continue;
                }
                else {i = formulaLength; parenthesisDepth = 0; continue;}
                
            default:
                rightScope++; break;
        }
    }
    
    parenthesisDepthRight = parenthesisDepth;
    parenthesisDepth = 0;
    
    // To the left; applies to binary connectives only.  The same as above, except in reverse, and adding to leftScope.
    for (long i = leftPosition; i > -1; i--)
    {
        switch ([formulaKey characterAtIndex:i])
        {
            case 'U':
                leftScope++; break;
                
            case 'B':
                leftScope++; break;
                
            case ')':
                if (i-2 >= 0 && [formulaKey characterAtIndex:(i-2)] == 'Q')
                {
                    leftScope += 4; i -= 3; break;
                }
                else {leftScope++; parenthesisDepth++; break;}
                
            case '(':
                parenthesisDepth--;
                if (parenthesisDepth >= 0)
                {
                    leftScope++; break;
                }
                else
                {
                    i = -1; parenthesisDepth = 0; continue;
                }
                
            default:
                leftScope++; break;
        }
    }
    
    if (parenthesisDepth-parenthesisDepthRight != 0) return connectiveRange; // Abort if parentheses are mismatched
    if (connectivePosition-leftScope > formulaLength-1 || leftScope+rightScope+1 < 1)
        return connectiveRange; // Abort if range illegal.
    
    connectiveRange.location = connectivePosition-leftScope;
    connectiveRange.length = leftScope+rightScope+1;
    
    return connectiveRange;
}

-(void)_findMainConnective
{
    // This function determines the main connective of formula, and then stores it as mainConnective.  It does this by going through each unary, binary and quantifier, and determining which one has as its scope the entire formula.
    
    NSRange connectiveRange;
    unichar characterToTest;
    
    for (NSUInteger i = 0; i < formulaLength; i++)
    {
        characterToTest = [formulaKey characterAtIndex:i];
        if (characterToTest == 'U' || characterToTest == 'B' || characterToTest == 'Q')
        {
            connectiveRange = [self _findScopeOf:i];
            if (connectiveRange.length == formulaLength)
            {
                mainConnective = i;
                return; // Main connective found, so exit function
            }
        }
    }
    mainConnective = formulaLength + 1; // No main connective found; set to illegal position
}

-(void)_findBranches
{
    // This is a courtesy funciton, packaging up _findLeftBranch, _findCentreBranch, and _findRightBranch, and setting the corresponding properties.
    leftBranch = [[self _findLeftBranch] copy];
    
    centreBranch = [[self _findCentreBranch] copy];
    
    rightBranch = [[self _findRightBranch] copy];
}

-(NSString *)_findLeftBranch
{
    // This function is an embodiment of syntax rules, looking to the left of the main connective.  If new syntax rules need to be defined, this is the place to do it.
    NSString *left;
    
    // Return nil if formula has no length, or main connective not found
    if (formulaLength == 0 || mainConnective > formulaLength - 1) return nil;
    
    // If the connective is binary, extract the left branch by moving one character to the left and then going all the way to the end of the formula (which, in a wff, is the parenthesis).
    if ([formulaKey characterAtIndex:mainConnective] == 'B' && mainConnective - 1 > 0)
    {
        left = [NSString stringWithString:[formula substringWithRange:NSMakeRange(1,mainConnective-1)]];
    }
    else
    {
        left = nil;
    }
    
    return left;
}

- (NSString *)_findCentreBranch
{
    // See _findLeftBranch
    NSString *connective;
    
    // Return nil if formula has no length, or main connective not found
    if (formulaLength == 0 || mainConnective > formulaLength - 1) return nil;
    
    if ([formulaKey characterAtIndex:mainConnective] == 'Q' && mainConnective + 3 < formulaLength)
    {
        connective = [NSString stringWithString:[formula substringWithRange:NSMakeRange(mainConnective - 1, 4)]];
    }
    else
    {
        connective = [NSString stringWithString:[formula substringWithRange:NSMakeRange(mainConnective, 1)]];
    }
    
    return connective;
}

- (NSString *)_findRightBranch
{
    // See _findRightBranch
    NSString *right;
    
    // Return nil if formula has no length, or main connective not found
    if (formulaLength == 0 || mainConnective > formulaLength - 1) return nil;
    
    if ([formulaKey characterAtIndex:mainConnective] == 'Q' && mainConnective + 3 < formulaLength)
    {
        right = [NSString stringWithString:[formula substringWithRange:
                                            NSMakeRange(mainConnective + 3, formulaLength - mainConnective - 3)]];
    }
    else if ([formulaKey characterAtIndex:mainConnective] == 'U' && mainConnective + 1 < formulaLength)
    {
        right = [NSString stringWithString:[formula substringWithRange:
                                            NSMakeRange(mainConnective + 1, formulaLength - mainConnective - 1)]];
    }
    else if ([formulaKey characterAtIndex:mainConnective] == 'B' && mainConnective + 2 < formulaLength)
    {
        right = [NSString stringWithString:[formula substringWithRange:
                                            NSMakeRange(mainConnective + 1, formulaLength - mainConnective - 2)]];
    }
    else
    {
        right = nil;
    }
    
    return right;
}

-(void)_checkAtomic
{
    // This function checks whether the given formula is atomic.
    if (mainConnective <= 0 || mainConnective < formulaLength)
    {
        atomic = NO;
        return;
    }
    
    // Make sure the atomic sentence is well-formed
    NSString *rootFormulaKey = [[self _formulaKey] copy];
    NSUInteger length = [self formulaLength];
    
    // If forrmula is a single sentence letter or contradiction symbol, is a wff atomic
    if (([rootFormulaKey characterAtIndex:0] == 'L' || [rootFormulaKey characterAtIndex:0] == 'O') && length == 1)
    {
        atomic = YES;
        return;
    }
    
    // If formula is a predicate letter or an identity symbol, make sure only terms follow
    if (([rootFormulaKey characterAtIndex:0] == 'L' && length > 1) ||
        ([rootFormulaKey characterAtIndex:0] == 'I' && length == 3)) {
        for (NSUInteger i=1; i < length; i++)
        {
            if ([rootFormulaKey characterAtIndex:i] != 'V' && [rootFormulaKey characterAtIndex:i] != 'C') {
                atomic = NO;
                return;
            }
        }
        atomic = YES;
        return;
    }
    
    atomic = NO;
}

-(BOOL)_checkWff:(Formula *)aFormula
{
    // This function checks wehther the given formula is well-formed.  It does this by generating a parse tree with aFormula ot the top of the tree, and using leftBranch/rightBranch of aFormula (and subsequent formulae) to populate the tree.  If the tree terminates in anything other than atomic formulae, aFormula is not a wff.
    
    NSMutableArray *parseTree = [[NSMutableArray alloc] init];
    NSString *lBranch, *rBranch, *cBranch;
    Formula *tempFormula;
    
    NSCharacterSet *unary = [NSCharacterSet characterSetWithCharactersInString:@"~"];
    NSCharacterSet *binary = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%C%C%C&",0x2192,0x2194,0x2228]]; // →, ↔, ∨
    NSRange matchRange;
    
    // Put aFormula at the top of the tree
    if (aFormula != nil) [parseTree addObject:aFormula];
    
    int i=0;
    while (i<[parseTree count])
    {
        lBranch = [[parseTree objectAtIndex:i] leftBranch];
        rBranch = [[parseTree objectAtIndex:i] rightBranch];
        
        // If nothing turns up the branches, and the formula being examined is not atomic, aFormula is not well formed
        if (lBranch == nil && rBranch == nil && [[parseTree objectAtIndex:i] atomic] == NO) return NO; // Not well-formed
        
        // Look at the centre branch
        cBranch = [[parseTree objectAtIndex:i] centreBranch];
        if ([cBranch length] == 1)
        {
            // If that connective is a unary, make sure lBranch is not full and rBranch is not empty (e.g., 'A~_')
            matchRange = [cBranch rangeOfCharacterFromSet:unary options:NSLiteralSearch range:NSMakeRange(0,1)];
            if (matchRange.length == 1 && (lBranch != nil || rBranch == nil)) return NO; // Not well-formed
            
            // If that connective is a binary, make sure lBranch is not empty and rBranch is not empty (e.g., '_&_')
            matchRange = [cBranch rangeOfCharacterFromSet:binary options:NSLiteralSearch range:NSMakeRange(0,1)];
            if (matchRange.length == 1 && (lBranch == nil || rBranch == nil)) return NO; // Not well-formed
        }
        
        // Open up a new left branch by calling _setFormula on lBranch, and add lBranch to the tree
        tempFormula = [[Formula alloc] init];
        [tempFormula _setFormula:lBranch adopt:NO wffCheck:NO withConstantSet:constantSet andVariableSet:variableSet withFreeVariables:freeVariables];
        if ([tempFormula formula] != nil) [parseTree addObject:tempFormula];
        
        // Do the same on the right
        tempFormula = [[Formula alloc] init];
        [tempFormula _setFormula:rBranch adopt:NO wffCheck:NO withConstantSet:constantSet andVariableSet:variableSet withFreeVariables:freeVariables];
        if ([tempFormula formula] != nil) [parseTree addObject:tempFormula];
        
        i++;
    }
    
    // Check to see if the quantifiers (if any) are behaving themselves
    if (![self _checkQuantifier:parseTree]) return NO;
    
    return YES;
}

-(NSArray *)parseTree
{
    // This function creates a parse tree array, for use with other functions.

    // Returns nil if not a wff.
    if (!wff) return nil;
    
    NSMutableArray *parseTree;
    NSString *lBranch, *rBranch;
    Formula *tempFormula;

    [parseTree addObject:self];
    
    int i=0;
    while (i<[parseTree count])
    {
        lBranch = [[parseTree objectAtIndex:i] leftBranch];
        rBranch = [[parseTree objectAtIndex:i] rightBranch];
        
        if (lBranch != nil)
        {
            // Open up a new left branch by calling _setFormula on lBranch, and add lBranch to the tree
            tempFormula = [[Formula alloc] init];
            [tempFormula _setFormula:lBranch adopt:NO wffCheck:NO withConstantSet:constantSet andVariableSet:variableSet withFreeVariables:freeVariables];
            if ([tempFormula formula] != nil) [parseTree addObject:tempFormula];
        }
        
        if (rBranch != nil)
        {
            // Do the same on the right
            tempFormula = [[Formula alloc] init];
            [tempFormula _setFormula:rBranch adopt:NO wffCheck:NO withConstantSet:constantSet andVariableSet:variableSet withFreeVariables:freeVariables];
            if ([tempFormula formula] != nil) [parseTree addObject:tempFormula];
        }
        
        i++;
    }
    return [parseTree copy];
}

-(BOOL)_checkQuantifier:(NSArray *)parseTree
{
    // This function makes three checks regarding quantifiers (or lack thereof): (i) quantifier is well-formed (∀x); (ii) there is no double-binding; (iii) superfluous quantifiers (that bind nothing); (iv) unbound variables (if free variables are not permitted).
    Formula *tempFormula;
    NSUInteger changeCount;
    
    NSRange matchRange, connectiveRange;
    long matchLocation;
    
    NSMutableString *rootFormula = [[[parseTree objectAtIndex:0] formula] mutableCopy];
    NSString *rootFormulaKey = [[[parseTree objectAtIndex:0] _formulaKey] copy];
    NSString *variableToChange;
    NSCharacterSet *variable =     [variableSet copy];
    NSCharacterSet *quantifierInFormulaKey = [NSCharacterSet characterSetWithCharactersInString:@"Q"];
    NSCharacterSet *variableInFormulaKey = [NSCharacterSet characterSetWithCharactersInString:@"V"];
    
    // Do a quick check to see if there are quantifiers and variables in the formula; if not, simply return YES
    matchRange = [rootFormulaKey rangeOfCharacterFromSet:quantifierInFormulaKey options:NSLiteralSearch];
    if (matchRange.length == 0) {
        // There are no quantifiers; if free variables are permitted, we are done
        if (freeVariables) return YES;
        else
        {
            // Otherwise, check to make sure there are no variables
            matchRange = [rootFormulaKey rangeOfCharacterFromSet:variableInFormulaKey options:NSLiteralSearch];
            if (matchRange.length == 0) return YES;
        }
    }
    
    // Check quantifier formation: make sure any "Q" in formulaKey is preceded by "(" and followed by "V)"
    //matchRange = [rootFormulaKey rangeOfCharacterFromSet:quantifierInFormulaKey options:NSLiteralSearch range:NSMakeRange(0,formulaLength)];
    
    while (matchRange.length == 1)
    {
        matchLocation = matchRange.location;
        if (matchLocation-1 >= 0 && matchLocation+2 <= [[parseTree objectAtIndex:0] formulaLength])
        {
            if ([rootFormulaKey characterAtIndex:matchLocation-1] != '(' ||
                [rootFormulaKey characterAtIndex:matchLocation+1] != 'V' ||
                [rootFormulaKey characterAtIndex:matchLocation+2] != ')') {return NO;}
        } else {return NO;}
        // Look for the next quantifier in the string
        matchRange = [rootFormulaKey rangeOfCharacterFromSet:quantifierInFormulaKey options:NSLiteralSearch
                                                       range:NSMakeRange(matchLocation+3, formulaLength-matchLocation-3)];
        //formulaResult = [formulaResult nextMatch]; // Look for the next quantifier in the string
    }
    
    // Check for doublebinding.  Do this by looking through the parse tree formulae.  If the main connective is a quantifier, see if there is another quantifier that binds the same variable.
    for (int i=0; i<[parseTree count]; i++)
    {
        tempFormula = [parseTree objectAtIndex:i];
        if ([tempFormula mainConnective] == 1)
        {
            // Main connective is a quantifier.  Check for doublebinding.
            matchRange = [[tempFormula formula]
                          rangeOfString:[NSString stringWithFormat:@"%C%@",0x2200,[[tempFormula formula] substringWithRange:NSMakeRange(2,1)]]
                          options:NSLiteralSearch
                          range:NSMakeRange(3,[tempFormula formulaLength]-3)]; // ∀x
            // Check for doublebinding with universal
            if (matchRange.length != 0) {return NO;}
            matchRange = [[tempFormula formula]
                          rangeOfString:[NSString stringWithFormat:@"%C%@",0x2203,[[tempFormula formula] substringWithRange:NSMakeRange(2,1)]]
                          options:NSLiteralSearch
                          range:NSMakeRange(3,[tempFormula formulaLength]-3)]; // ∃x
            // Check for doublebinding with existential
            if (matchRange.length != 0) {return NO;}
        }
    }
    
    // Check for extraneous quantifiers and unbound variables.  Do this by replacing every varible next to a quantifier and every variable it binds with "-".  The scan the entire formula that remains.  If there are any variables that remain, they are unbound.
    matchRange = [rootFormulaKey rangeOfCharacterFromSet:quantifierInFormulaKey options:NSLiteralSearch range:NSMakeRange(0,formulaLength)];
    
    while (matchRange.length == 1)
    {
        connectiveRange = [[parseTree objectAtIndex:0] _findScopeOf:matchRange.location];
        variableToChange = [NSString stringWithFormat:@"%@",[rootFormula substringWithRange:NSMakeRange(matchRange.location+1,1)]];
        changeCount = [rootFormula replaceOccurrencesOfString:variableToChange
                                                   withString:@"-"
                                                      options:NSLiteralSearch
                                                        range:connectiveRange];
        if (changeCount < 2) return NO; // Fewer than two instances of the variable have been found (one in the quantifier, one in the subformula)
        
        matchRange = [rootFormulaKey rangeOfCharacterFromSet:quantifierInFormulaKey options:NSLiteralSearch range:NSMakeRange(matchRange.location+1,formulaLength-matchRange.location-1)];
    }
    
    // If we get to this point and free variables are permitted, there is no need to check for unbound variables.
    if (freeVariables) return YES;
    
    // At this point, all variables bound by quantifiers have been replaced by "-"; so any variables that remain are not within the scope of any quantifier.
    matchRange = [rootFormula rangeOfCharacterFromSet:variable options:NSLiteralSearch range:NSMakeRange(0,formulaLength)];
    if (matchRange.length != 0) {return NO;}
    
    return YES; // Well-formed, insofar as quantifiers are concerned
}

-(NSArray *)subformulaeOf:(NSUInteger)aCharacterPosition
{
    // This function goes through each unary, binary and quantifier, determines scope, and returns an array of Formula objects that have aCharacterPosition as part of the scope.  This function is closely related to the _findMainConnective function.
    
    if (![self wff]) return nil; // Only works with wffs
    
    Formula *subformula;
    NSMutableArray *subformulae;
    NSRange connectiveRange;
    unichar characterToTest;
    
    subformulae = [[NSMutableArray alloc] init];
    
    for (NSUInteger i=0; i < formulaLength; i++)
    {
        characterToTest = [formulaKey characterAtIndex:i];
        if (characterToTest == 'U' || characterToTest == 'B' || characterToTest == 'Q')
        {
            connectiveRange = [self _findScopeOf:i];
            if (aCharacterPosition >= connectiveRange.location && aCharacterPosition <= connectiveRange.location+connectiveRange.length-1)
            {
                subformula = [[Formula alloc] init];
                [subformula _setFormula:[formula substringWithRange:connectiveRange]
                                  adopt:NO wffCheck:NO withConstantSet:constantSet
                         andVariableSet:variableSet withFreeVariables:freeVariables];
                [subformulae addObject:subformula];
            }
        }
    }
    NSArray *theSubformulae = [subformulae copy];
    return theSubformulae;
}

-(BOOL)isCharacterBound:(NSString *)theVariable
{
    // This formula returns true if theVariable is bound nowhere in the formula

    NSMutableString *aFormula = [NSMutableString stringWithString:[self formula]];
    NSUInteger changeCountUniversal = 0, changeCountExistential = 0;
    NSString *universal = [NSString stringWithFormat:@"%C%@",0x2200,theVariable];
    NSString *existential = [NSString stringWithFormat:@"%C%@",0x2203,theVariable];
    
    changeCountUniversal = [aFormula replaceOccurrencesOfString:universal
                                               withString:@"--"
                                                  options:NSLiteralSearch
                                                    range:NSMakeRange(0, [aFormula length])];
    
    changeCountExistential = [aFormula replaceOccurrencesOfString:existential
                                                            withString:@"--"
                                                               options:NSLiteralSearch
                                                                 range:NSMakeRange(0, [aFormula length])];
    
    if ((changeCountUniversal + changeCountExistential) != 0)
    {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark Encode/Decode/Copy

-(void)encodeWithCoder:(NSCoder *)coder
{
    // States which objects to encode when an archive (save) message is issued
    [coder encodeObject:formula forKey:@"formula"];
    [coder encodeObject:formulaKey forKey:@"formulaKey"];
    [coder encodeObject:unswappedFormula forKey:@"unswappedFormula"];
    [coder encodeInteger:formulaLength forKey:@"formulaLength"];
    [coder encodeInteger:mainConnective forKey:@"mainConnective"];
    [coder encodeObject:leftBranch forKey:@"leftBranch"];
    [coder encodeObject:centreBranch forKey:@"centreBranch"];
    [coder encodeObject:rightBranch forKey:@"rightBranch"];
    [coder encodeBool:wff forKey:@"wff"];
    [coder encodeBool:atomic forKey:@"atomic"];
    [coder encodeObject:constantSet forKey:@"constantSet"];
    [coder encodeObject:variableSet forKey:@"variableSet"];
    [coder encodeBool:freeVariables forKey:@"freeVariables"];
}

-(id)initWithCoder:(NSCoder *)coder
{
    // States how to unencode when a load message is issued
    if (!(self = [super init])) return nil;
    formula = [coder decodeObjectForKey:@"formula"];
    formulaKey = [coder decodeObjectForKey:@"formulaKey"];
    unswappedFormula = [coder decodeObjectForKey:@"unswappedFormula"];
    formulaLength = [coder decodeIntegerForKey:@"formulaLength"];
    mainConnective = [coder decodeIntegerForKey:@"mainConnective"];
    leftBranch = [coder decodeObjectForKey:@"leftBranch"];
    centreBranch = [coder decodeObjectForKey:@"centreBranch"];
    rightBranch = [coder decodeObjectForKey:@"rightBranch"];
    wff = [coder decodeBoolForKey:@"wff"];
    atomic = [coder decodeBoolForKey:@"atomic"];
    constantSet = [coder decodeObjectForKey:@"constantSet"];
    variableSet = [coder decodeObjectForKey:@"variableSet"];
    freeVariables = [coder decodeBoolForKey:@"freeVariables"];
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    Formula *copy = [[self class] allocWithZone: zone];
    [copy setFormula:[self formula] withConstantSet:[self constantSet] andVariableSet:[self variableSet] withFreeVariables:[self freeVariables]];
    return copy;
}

@end

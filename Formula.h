//
//  Formula.h
//  Turnstyle
//
//  Created by Darcy on 2020-05-10.
//  Copyright © 2020 Darcy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Formula : NSObject {

    NSString *formula;
    NSString *formulaKey;
    
    NSString *unswappedFormula;
    
    NSUInteger formulaLength;
    NSUInteger mainConnective;
    
    NSString *leftBranch;
    NSString *centreBranch;
    NSString *rightBranch;
    
    BOOL wff;
    BOOL atomic;
    BOOL freeVariables;
    
    NSCharacterSet *variableSet;
    NSCharacterSet *constantSet;
    
}

// Assumes constants of a-s, variables of t-z, and no free variables, unless otherwise specified.
-(id)initWithFormula:(NSString *)aFormula;
-(void)setFormula:(NSString *)aFormula;
-(void)setFormula:(NSString *)aFormula withConstantSet:(NSCharacterSet *)aConstantSet andVariableSet:(NSCharacterSet *)aVariableSet;
-(void)setFormula:(NSString *)aFormula withConstantSet:(NSCharacterSet *)aConstantSet andVariableSet:(NSCharacterSet *)aVariableSet withFreeVariables:(BOOL)allowsFreeVariables;

// formula will have identity predicates in the prefix location; unswappedFormula in the infix location.
-(NSString *)formula;
-(NSString *)unswappedFormula;

// subformulaOf returns the subformula where the charcater at aCharacterPosition first appears in the semantic tree
-(NSArray *)subformulaeOf:(NSUInteger)aCharacterPosition;

// formulaLength is the length in characters of the formula.  mainConnective is the location of the main connective (0 being the first position)
-(NSUInteger)formulaLength;
-(NSUInteger)mainConnective;

// wffs (if formula is a wff) of what is to the left and right of the main connective; centreBranch is the main connective string.  leftBranch is empty with unary connectives.
-(NSString *)leftBranch;
-(NSString *)centreBranch;
-(NSString *)rightBranch;

-(NSString *)unswappedLeftBranch;
-(NSString *)unswappedRightBranch;

// wff is TRUE if formula is a well-formed; atomic is TRUE if formula is atomic
-(BOOL)wff;
-(BOOL)atomic;

// Returns constantSet and variableSet used by the particular formula
-(NSCharacterSet *)constantSet;
-(NSCharacterSet *)variableSet;

// Returns whether the formula permits free variables
-(BOOL)freeVariables;

// Returns whether the character is bound by a quantifier
-(BOOL)isCharacterBound:(NSString *)theCharacter;

// Returns the entire parse tree of a wff
-(NSArray *)parseTree;

// Exposes _setFormula method
-(void)setFormula:(NSString *)aFormula adopt:(BOOL)adoptFormula wffCheck:(BOOL)wffFormula
  withConstantSet:(NSCharacterSet *)aConstantSet andVariableSet:(NSCharacterSet *)aVariableSet withFreeVariables:(BOOL)allowsFreeVariables;

@end

NS_ASSUME_NONNULL_END

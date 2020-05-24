# Turnstyle

*Turnstyle* is the logic engine for *Deductions*, which is a proof assistant for natural deduction problems in first-order logic with identity.  Formula.m is the code that allows *Turnstyle* to parse single formulae in first-order logic.  It is heavily commented, and is very fast.

## Class: Formula

### `-(id)initWithFormula:(NSString *)aFormula`

Parameters:

    aFormula: NSString that gets paresd to become a formula

Return:

    A Formula object

Example:

    Formula *f = [[Formula alloc] initWithFormula:@"A&B"];

### `-(void)setFormula`

Variations:

    -(void)setFormula:(NSString *)aFormula withConstantSet:(NSCharacterSet *)aConstantSet andVariableSet:(NSCharacterSet *)aVariableSet withFreeVariables:(BOOL)allowsFreeVariables
    -(void)setFormula:(NSString *)aFormula withConstantSet:(NSCharacterSet *)aConstantSet andVariableSet:(NSCharacterSet *)aVariableSet
    -(void)setFormula:(NSString *)aFormula

Parameters: 

    aFormula: NSString that gets paresd to become a formula
    aConstantSet: NSCharacterSet that specifies which lower case letters are constants in the language
    aVariableSet: NSCharacterSet that specifies which lower case letters are variables in the language
    allowsFreeVaribles: BOOL that specifies whether free variables are permitted (YES) or whether all variables must be bound (NO)

Return:

    none

Example:

    [f setFormula:@"A&B" withConstantSet:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrs"] andVariableSet:[NSCharacterSet characterSetWithCharactersInString:@"tuvwxyz"] withFreeVariables:NO];

### `-(NSString *)formula`

Parameters:

    none

Return:

    The formula as a string, with identity predicates in the prefix position.

Example:

    [f formula];

### `-(NSString *)unswappedFormula`

Parameters:

    none

Returns:

    The formula as a string, with identity predicates in the infix position.

Example:

    [f unswappedFormula];

### `-(NSArray *)subformulaeOf:(NSUInteger)aCharacterPosition`

Parameters:

    aCharacterPosition: the position of a character in the formula

Returns:

    An array of all the subformulae where the character at aCharacterposition first appears in the semantic tree.

Example:

    [f subformulaeOf:5];

### `-(NSUInteger)formulaLength`

Parameters:

    none

Returns:

    An integer representing the length of the formula.

Example:

    [f formulaLength];

### `-(NSUInteger)mainConnective`

Parameters:

    none

Returns:

    An integer representing the position of the main connective.

Example:

    [f mainConnective];
    
### `-(NSString *)leftBranch`
### `-(NSString *)centreBranch`
### `-(NSString *)rightBranch`
### `-(NSString *)unswappedLeftBranch`
### `-(NSString *)unswappedRightBranch`
Parameters:

    none

Returns:

    The main subformula on the left of the main connective [leftBranch]
    The main subformula on the right of the main connective [rightBranch]
    The main connective [centreBranch]
    The main subformula on the left of the main connective with identity predicates in the infix position [unswappedLeftBranch]
    The main subformula on the right of the main connective with identity predicates in the infix position [unswappedRightBranch]

### `-(BOOL)wff`
### `-(BOOL)atomic`
### `-(BOOL)freeVariables`

Parameters:

    none

Returns:

    YES if the formula is well-formed; NO otherwise [wff]
    YES if the formula is atomic; NO otherwise [atomic]
    YES if the formula permits free variable; NO otherwise [freeVariables]

Parameters:

    none

Returns:


### `-(NSCharacterSet *)constantSet`
### `-(NSCharacterSet *)variableSet`

Parameters:

    none

Returns:

    The set of characters corresponding to constants [constantSet]
    The set of characters corresponding to variables [variableSet]


### `-(BOOL)isCharacterBound:(NSString *)theCharacter`

Parameters:

    A string representing the charcater in question.

Returns:

    YES if theCharacter is bound; NO otherwise

### `-(NSArray *)parseTree`

Parameters:

    none

Returns:

    An array of the next set of branches for the syntactic tree.

Example:

    [f setFormula:@"(A&(~B&C))"];
    [f parseTree];
***
    A
    (~B&C)

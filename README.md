# Turnstyle

*Turnstyle* is the logic engine for *Deductions*, which is a proof assistant for natural deduction problems in first-order logic with identity.  Formula.m is the code that allows *Turnstyle* to parse single formulae in first-order logic.  It is heavily commented, and is very fast.

The Formula class governs the syntax and parsing for single formulae.  The syntax rules are taken from Graeme Forbes' _Modern Logic: A Text in Elementary Symbolic Logic_ (Oxford, 1994).  Parentheses are used for operators that have two terms; for example, "(A & B)", not "A & B".  Furthermore, parentheses are used around quantifiers; for example, "(∀x)Fx", not "∀xFx".  Main connectives are ~, &, →, &#x27F7;, ∨, ∀, ∃.  ⋏ (the contradiction symbol) is treated as a sentence letter.  = and ≠ are treated as predicates (prefix in the "swapped" state, e.g., "=ab"; infix in the "unswapped" state, e.g., "a=b").  Parentheses are the only permissible punctuation.

By default: (i) all capital letters and ⋏ are sentence letters, (ii) small letters a through s are constants, (iii) small letters t through z are variables, and (iv) free variables are not permitted.  Defaults concerning constant and variable ranges, together with free variables, may be set through `setFormula`.

Basic useage for the class is to initialise the object and set the formula.  Whether the formula is a well-formed, atomic, what its main connective is, what its main subformulae are calculated automatically.  Furthermore, we may use `leftBranch`, `centreBranch`, and `rightBranch` to determine the subformulae of the main connective, and `subformulaeOf` to list all the subformulae of a given symbol.

## Class: Formula

### `-(id)initWithFormula:(NSString *)aFormula`

Parameters:

    aFormula: NSString that gets paresd to become a formula

Return:

    A Formula object

Example:

    Formula *f = [[Formula alloc] initWithFormula:@"A&B"];
***
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

***

### `-(NSString *)formula`
### `-(NSString *)unswappedFormula`

Parameters:

    none

Return:

    The formula as a string, with identity predicates in the prefix position [formula]
    The formula as a string, with identity predicates in the infix position [unswappedFormula]

Example:

    [f setFormula:@"(A&(B&c=d))"];
    [f formula];                   => (A&(B&c=d))
    [f unswappedFormula];          => (A&(B&=cd))

***

### `-(NSArray *)subformulaeOf:(NSUInteger)aCharacterPosition`

Parameters:

    aCharacterPosition: the position of a character in the formula (counting from 0 as the first position)

Returns:

    An array for all the subformulae where the character at aCharacterposition first appears in the semantic tree.

Example:

    [f setFormula:@"(A&(B&c=d))"];
    [f subformulaeOf:4];           => {(A&(B&=cd)), (B&=cd)}

***

### `-(NSUInteger)formulaLength`
### `-(NSUInteger)mainConnective`

Parameters:

    none

Returns:

    An unsigned integer representing the length of the formula [formulaLength]
    An integer representing the position of the main connective of the formula [mainConnective]

***
   
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

***

### `-(BOOL)wff`
### `-(BOOL)atomic`
### `-(BOOL)freeVariables`

Parameters:

    none

Returns:

    YES if the formula is well-formed; NO otherwise [wff]
    YES if the formula is atomic; NO otherwise [atomic]
    YES if the formula permits free variable; NO otherwise [freeVariables]

***

### `-(NSCharacterSet *)constantSet`
### `-(NSCharacterSet *)variableSet`

Parameters:

    none

Returns:

    The set of characters corresponding to constants [constantSet]
    The set of characters corresponding to variables [variableSet]

***

### `-(BOOL)isCharacterBound:(NSString *)theCharacter`

Parameters:

    A string representing the charcater in question.

Returns:

    YES if theCharacter is bound; NO otherwise

***

### `-(NSArray *)parseTree`

Parameters:

    none

Returns:

    An array of the next set of branches for the syntactic tree.

Example:

    [f setFormula:@"(A&(~B&C))"];
    [f parseTree];                => {A, (~B&C)}

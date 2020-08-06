# The Countdown Problem

The _countdown problem_ is defined as follows:

> Given a sequence of numbers and a target number, attempt to construct an
> expression whose value is the target, by combining one or more numbers from
> the sequence using addition, subtraction, multiplication, division and
> parentheses.

Further restrictions are:

1. Each number of the sequence can _at most_ be used once.
2. All numbers (including intermediary numbers) must be positive natural
   numbers. Negative numbers, zero, and, fractions, such as 2/3 are not
   allowed.

Given the sequence 1, 3, 7, 10, 25, 50, and the target 765, a possible solution would be:

    (1+50)*(25-10)
    = 51*15
    = 765

## Arithmetic Operators

The following arithmetic operators are going to be supported:

    data Op = Add | Sub | Mul | Div

The `Op` data type is made showable using this declaration:

    instance Show Op where
        show Add = "+"
        show Sub = "-"
        show Mul = "*"
        show Div = "/"

The `valid` function checks if the given operands result in integers when
applied with the operators defined before:

    valid :: Op -> Int -> Int -> Bool
    valid Add _ _ = True
    valid Sub x y = x > y
    valid Mul _ _ = True
    valid Div x y = x `mod` y == 0

The operation is performed using the `apply` function:

    apply :: Op -> Int -> Int -> Int
    apply Add x y = x + y
    apply Sub x y = x - y
    apply Mul x y = x * y
    apply Div x y = x `div` y

## Numeric Expressions

A numeric expression is either an integer value, or the application of an
operator to two argument expressions:

    data Expr = Val Int | App Op Expr Expr

An expression can be pretty-printed using special formatting rules for
expressions (in parentheses, that is):

    instance Show Expr where
        show (Val n)     = show n
        show (App o l r) = brak l ++ show o ++ brak r
                           where
                               brak (Val n) = show n
                               brak e       = "(" ++ show e ++ ")"

Example:

    > App Add (App Div (Val 4) (Val 2)) (App Mul (Val 3) (Val 4))
    (4/2)+(3*4)

The function `values` returns the list of values used in an expression:

    values :: Expr -> [Int]
    values (Val n)     = [n]
    values (App _ l r) = values l ++ values r

Example:

    > values (App Add (App Div (Val 4) (Val 2)) (App Mul (Val 3) (Val 4)))
    [4,2,3,4]

The `eval` function evaluates the value of an expression, if that value is a
positive natural number:

    eval :: Expr -> [Int]
    eval (Val n)     = [n | n > 0]
    eval (App o l r) = apply o x y | x <- eval l,
                                     y <- eval r,
                                     valid o x y]

Example:

    > eval (App Add (App Div (Val 4) (Val 2)) (App Mul (Val 3) (Val 4)))
    [14]

A singleton list (i.e. a list with a single entry) signifies successful
evaluation. In case of a failure (caused by an input or intermediary value not
being a positive natural number), an empty list is returned:

    > eval (App Add (App Div (Val 4) (Val 3)) (App Mul (Val 3) (Val 4)))
    []

## Combinatorial Functions

Combinatorial functions are the building blocks to build up combinations of the
given elements (numbers, operators) that forma possible solution to the problem
stated:

The function `subs` returns all subsequences of a list while keeping the order
of the elements:

    subs :: [a] -> [[a]]
    subs [] = [[]]
    subs (x:xs) = yss ++ map (x:) yss
                  where yss = subs xs

Example:

    > subs []
    [[]]
    > subs [1]
    [[],[1]]
    > subs [1,2]
    [[],[2],[1],[1,2]]
    > subs [1,2,3]
    [[],[3],[2],[2,3],[1],[1,3],[1,2],[1,2,3]]

The `interleave` function returns all possible ways a new element can be
inserted into a given list:

    interleave :: a -> [a] -> [[a]]
    interleave x []     = [[x]]
    interleave x (y:ys) = (x:y:ys) : map(y:) (interleave x ys)

Example:

    > interleave 0 [1,2]
    [[0,1,2],[1,0,2],[1,2,0]]
    > interleave 0 [1,2,3]
    [[0,1,2,3],[1,0,2,3],[1,2,0,3],[1,2,3,0]]

The function `perms` returns all permutations of a given list by reordering the
elements in all possible ways:

    perms :: [a] -> [[a]]
    perms []     = [[]]
    perms (x:xs) = concat (map (interleave x) (perms xs))

The `interleave` function is used to insert the head element into all possible
positions of the tail permutations.

Example:

    > perms []
    [[]]
    > perms [0]
    [[0]]
    > perms [0,1]
    [[0,1],[1,0]]
    > perms [0,1,2]
    [[0,1,2],[1,0,2],[1,2,0],[0,2,1],[2,0,1],[2,1,0]]:w
    
The `choices` function returns all the possible ways of selecting zero or more
elements of a list in any order:

    choices :: [a] -> [[a]]
    choices = concat . map perms . subs

All permutations and subsequences are considered to build up the list of
possible choices.

Example:

    > choices []
    [[]]
    > choices [1]
    [[],[1]]
    > choices [1,2]
    [[],[2],[1],[1,2],[2,1]]
    > choices [1,2,3]
    [[],[3],[2],[2,3],[3,2],[1],[1,3],[3,1],[1,2],[2,1],[1,2,3],
     [2,1,3],[2,3,1],[1,3,2],[3,1,2],[3,2,1]]

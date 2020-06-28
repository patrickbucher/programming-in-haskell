# Defining Functions

## Conditional Expressions

Since conditionals are expressions, they always need an `else` branch:

    abs :: Int -> Int
    abs n = if n >= 0 then n else -n

Conditional expressions can be nested:

    signum :: Int -> Int
    signum n = if n < 0 then -1 else
               if n == 0 then 0 else 1

## Guarded Equations

Gards are used to choose between a sequence of results of the same type:

    abs n | n >= 0    = n
          | otherwise = -n

    signum n | n < 0     = -1
             | n == 0    = 0
             | otherwise = 1

It is good practice to have a _fallback_ case defined using `otherwise` as the
last guard in the sequence.

## Pattern Matching

Patterns are used to choose between a sequence of results. The first pattern
that matches is used to produce the result. The other patterns are then
ignored.

The function `not` is defined using two patterns, `False` and `True`:

    not :: Bool -> Bool
    not False = True
    not True  = False

The logical `and` function can be defined as such:

    (&&) :: Bool -> Bool -> Bool
    True && True   = True
    True && False  = False
    False && True  = False
    False && False = False

The expression can be simplified using a wildcard expression that matches any
value:

    True && True = True
    _    && _    = False

The expression can be optimized using _lazy evaluation_:

    True && b  = b
    False && _ = False

Arguments need different names in a single equation:

    b && b = b -- wrong
    _ && _ = False

    b && c | b == c    = b
           | otherwise = False

A tuple can be used as a pattern:

    fst :: (a,b) -> a
    fst (x,_) = x

    snd :: (a,b) -> b
    snd (_,y) = y

So can a list:

    test :: [Char] -> Bool
    test ['a',_,_] = True
    test _         = False

The right-associative `cons` operator (`:`) can be used to construct lists:

    [1,2,3]
    1 : [2,3]
    1 : (2 : [3])
    1 : (2 : (3 : []))

The `cons` operator can be used for pattern matching:

    test :: [Char] -> Bool
    test ('a':_) = True
    test _       = False

Note that `('a':_)` is not a tuple; the parentheses are used for precedence.

The library functions `head` and `tail` can be implemented using the `cons`
operator:

    head :: [a] -> a
    head (x:_) = x

    tail :: [a] -> [a]
    tail (_:xs) = xs

## Lambda Expressions

Functions can be defined using equations or _lambda expressions_, without a name, that is.

The greek letter lambda is represented by a backslash `\`:

    \x -> x + x

    (\x -> x + x) 2
    4

Curried functions can be expressed in terms of lambdas:

    -- definition using an equation
    add :: Int -> Int -> Int
    add x y = x + y

    -- definition using lambdas
    add :: Int -> (Int -> Int)
    add = \x -> (\y -> x + y)

The latter declaration and definition makes it more clear, that `add` returns a
function.

Lambdas can be used to avoid additional function names for functions that are
only used once:

    -- equation (introduces function f)
    odds :: Int -> [Int]
    odds n = map f [0..n-1]
             where f x = x * 2 + 1

    -- lambda (instead of function f)
    odds :: Int -> [Int]
    odds n = map (\x -> x * 2 + 1) [0..n-1]

## Operators

Functions that take two arguments can be used as operators by surrounding them
with backticks:

    div 10  5
    10 `div` 5

Operators are written in between arguments by default:

    10 + 3

They can turned into curried functions by surrounding them with parentheses:

    (+) 10 3
    (+ 10) 3

If `#` is an operator, expressions like `(#)`, `(x #)` and `(# y)` are called
_sections_, and can be formalised as such:

    (#) = \x -> (\y -> x # y)
    (x #) = \y -> x # y
    (# y) = \x -> x # y

Sections have the following applications:

1. construct simple but useful functions, such as `(1+)` (successor) or `(1/)` (reciprocation)
2. declaring types, such as `(+) :: Int -> Int -> Int`, because the operator
   itself is not a valid expression
3. to use operators as arguments, such as `sum = foldl (+) 0`

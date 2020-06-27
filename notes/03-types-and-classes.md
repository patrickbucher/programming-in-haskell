# Types and Classes

Notation: `v` has type `T`:

    v :: T

`True` and `False` are `Bool` values:

    True :: Bool
    False :: Bool

The logical operators `not` maps a `Bool` to another `Bool`:

    not :: Bool -> Bool

_Type inference_: if `f` is a function that maps arguments of type `A` to
results of type `B`, and if `e` is an expression of type `A`, then the
application of `f` to `e` has the type `B`:

    f :: A -> B
    e :: A
    f e :: B

## Basic Types

- `Bool`: logical values `True` and `False`
- `Char`: single characters, such as `'a'`, `'3'` and `'_'` or `'\n'` enclosed in single quotes
- `String`: sequences of characters, such as `"foobar"`, `"/home"` enclosed in double quotes
- `Int`: integers from -2^63 to +2^63-1
- `Integer`: integers without lower or upper limits
- `Float`: single precision floating point numbers
- `Double`: double precision floating point numbers

## Lists

Elements of the same type:

    [False,True,False] :: [Bool]
    [1,2,3,4,5,6,7,8] :: [Int]
    ['a','b','c','d'] :: [Char]
    ["one","two","three"] :: [String]
    [['a','b'],['c','d']] :: [[Char]]

## Tuples

Finite sequence of components of possibly different types:

    (False,True) :: (Bool,Bool)
    (False,"Foo",True) :: (Bool,String,Bool)
    ("I have",3,"Apples") :: (String,Int,String)
    (4,("green","Apples")) :: (Int,(String,String))

The number of components of a tuple is called its _arity_.

## Functions

Mapping from arguments of one type to results of possibly another type:

    not :: Bool -> Bool
    even :: Int -> Bool

The function definition is preceded by the type:

    add :: (Int,Int) -> Int
    add = (x,y) = x + y

    zeroto :: Int -> [Int]
    zeroto n = [0..n]

## Curried Functions

Since functions can return functions, taking multiple arguments can be
implemented using curried functions:

    add' :: Int -> (Int -> Int)
    add' x y = x + y

`add'` is a function that takes an `Int`, and returns something that takes an
`Int`, too, and returns an `Int`.

Illustration of the two different approaches in pseudo-code. First, the initial definition:

    add :: (Int,Int) -> Int

    function add(x, y):
        return x + y

Second, the "curried" definition:

    add' :: Int -> (Int -> Int)

    function add'(x):
        function add''(y):
            return x + y
        return add''

Curried functions can be partially applied.

The function arrow `->` associates to the right. Therefore:

    Int -> (Int -> (Int -> Int))

can be written as:

    Int -> Int -> Int -> Int

Function application associates to the left. Therefore:

    ((mult x) y) z

can be written as:

    mult x y z

## Polymorphic Types

The library function `length` is polymorphic, i.e. it can be applied to lists
of different types:

    length [1,2,3,4]
    4

    length ["Yes","No"]
    2

    length [sin,cos,tan]
    3

The type of `length` is defined using a _type variable_:

    length :: [a] -> Int

## Overloaded Types

Arithmetic operators can be applied to different numeric types:

    1 + 2
    3

    1.0 + 2.5
    3.5

These operators are defined with a _class constraint_:

    (+) :: Num a => a -> a -> a

A type with multiple class constraints is called _overloaded_. `Num a => a -> a
-> a` is an overloaded type, `(+)` is an overloaded function.

## Basic Classes

A class is a collectin of types that supports overloaded operations called _methods_:

- `Eq`: equality types (`Bool`, `Char`, `String`, `Int`, `Integer`, `Float`, `Double`, list, tuples)
    - `(==) :: a -> a -> Bool` (equal)
    - `(/=) :: a -> a -> Bool` (not equal)
- `Ord`: ordered types (`Bool`, `Char`, `String`, `Int`, `Integer`, `Float`, `Double`, list, tuples)
    - `(<) :: a -> a -> Bool` (less than)
    - `(<=) :: a -> a -> Bool` (less than or equal)
    - `(>) :: a -> a -> Bool` (bigger than)
    - `(>=) :: a -> a -> Bool` (bigger than or equal)
    - `min :: a -> a -> a` (minimum)
    - `max :: a -> a -> a` (maximum)
- `Show`: showable types (ditto)
    - `show :: a -> String` (convert value to String)
- `Read`: readable types (ditto)
    - `read :: String -> a` (convert value from String)
- `Num`: numeric types (`Int`, `Integer`, `Float`, `Double`)
    - `(+) :: a -> a -> a`
    - `(-) :: a -> a -> a`
    - `(*) :: a -> a -> a`
    - `negate :: a -> a`
    - `abs :: a -> a`
    - `signum :: a -> a`
- `Integral`: integer types (`Int`, `Integer`)
    - `div :: a -> a -> a`
    - `mod :: a -> a -> a`
- `Fractional`: fractional types (`Float`, `Double`)
    - `(/) :: a -> a -> a`
    - `recip :: a -> a`

Note: the negative sign must be used in parentheses:

    abs -3 -- wrong
    abs (-3) -- correct

## Exercises

TODO

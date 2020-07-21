# Introduction

A function is a mapping of one or more elements to a single result.

The function `double` takes an argument `x` and returns the value `x + x`:

    double x = x + x

    > double 2
    4

    > double (double 2)
    8

Build the sum of a list from `1` to `n`:

    sum [1..n]

    > sum [1..3]
    6

## Features of Haskell

- _Concise Programs_ due to high-level nature of functional style and few
  keywords
- _Powerful Type System_ that can detect a lot of errors with little type
  information and type inference
- _List Comprehensions_ to costruct new lists on the basis of existing lists
- _Recursive Functions_ to provide simple and natural definitions
- _Higher-order Functions_ that accept functions as parameters, and return
  functions as results
- _Effectful Functions_ to program with side-effects without compromising
  function purity
- _Generic Functions_ to allow functions to be applied for different types
- _Lazy Evaluation_ to only compute results when they are needed
- _Equational Reasoning_ for proving properties of programs

## Historical Background

- 1930s: _Lambda Calculus_ Alonzo Church
    - mathematical theory of functions
- 1950s: _LISP_ ("LISt Processor") by John McCarthy
    - first functional programming language
    - with variable assignments
- 1960s: _ISWIM_ ("If you See What I Mean") by Peter Landin
    - first pure functional programming language
    - no variable assignments
- 1970s
    - _FP_ ("Functional Programming") by John Backus
        - higher-order functions
    - _ML_ ("Meta-Language") by Robin Milner
        - polymorphic types
        - type inference
- 1970s and 1980s: _Miranda_ ("admirable") by David Turner
    - commercial language
    - lazy programming
- 1987: development of _Haskell_ initiated by a committee of researchers
    - named after Haskell Curry
- 1990s: type classes and monads by Philip Wadler et. al.
- 2003: publication of the _Haskell Report_ by the Haskell committee
    - stable version of the language
- 2010: revised and updated _Haskell Report_

## Examples

Definition of the `sum` function:

    sum [] = 0
    sum (n:ns) = n + sum ns

The `sum` function has a type definition:

    sum :: Num a => [a] -> a

- `Num` is a numeric type
- `a` is a type parameter
- `[a]` is a list of elements of the numeric type `a`
- `a` is the resulting type of the function

`sum` is a function that takes a type parameter `a` and a list of `a`s as a
function parameter, and returns a value of type `a`.

The function `qsort` sorts a list by applying the quick sort algorithm to it:

    qsort :: Ord a => [a] -> [a]
    qsort []     = []
    qsort (x:xs) = qsort smaller ++ [x] ++ qsort bigger
                   where
                       smaller = [a | a <- xs, a <= x]
                       bigger =  [b | b <- xs, b > x]

The `Ord` type allows for comparisons (`>`, `<`, `>=`, `<=`, `\=`, `==`).

The function `seqn` performs sequences of actions:

    seqn []         = return []
    seqn (act:acts) = do x <- act
                         xs <- acts
                         return (x:xs)

For input/output actions, the type could be:

    seqn :: [IO a] -> IO [a]

`IO` is a so-called _monadic_ type. The general type definition of `seqn` thus would be:

    seqn :: Monad m => [m a] -> m [a]

## Exercises

Ex. 1) Give another possible calculation for the result of `double (double 2)`.

    double (double 2)
    double (2 + 2)
    double (4)
    4 + 4
    8

Ex. 2) Show that `sum [x] = x` for any number `x`.

- The sum of an empty list is 0.
- The sum of a non-empty list is the sum of the first element with the sum of the remainder.
- The first element of `[x]` is `x`.
- The remainder of `[x]` is `[]` ‒ the empty list.
- The sum of the empty list is 0.
- The sum of `x` and 0 is `x`.

Ex. 3) Define a function product that produces the product of a list of numbers,
and show using your definition that `product [2,3,4] = 24`.

    product :: Num a => [a] -> a
    product []     = 1
    product (x:xs) = x * product xs

- The product of an empty list is 1 (the multiplication's neutral element).
- The product of a non-empty list is the product of the list's first element
  and the product of the remainder.

Calculation:

    product [2,3,4]
    2 * product [3,4]
    2 * 3 * product [4]
    2 * 3 * 4 * product[]
    2 * 3 * 4 * 1
    6 * 4 * 1
    24 * 1
    24

Ex. 4) How should the definition of the function `qsort` be modified so that it
produces a _reverse_ sorted versoin of a list?

The `bigger` elements are put to the left, the `smaller` elements to the right side of `[x]`:

    rqsort :: Ord a => [a] -> [a]
    rqsort [] = []
    rqsort (x:xs) = rqsort bigger ++ [x] ++ rqsort smaller
                    where
                        smaller = [a | a <- xs, a <= x]
                        bigger  = [b | b <- xs, b > x]

Ex. 5) What would be the effect of replacing <= by < in the original definition of
`qsort`? Hint: consider the example `qsort [2,2,3,1,1]`.

Elements equal to the first element would be omitted. The result would be a
sorted list of unique values.

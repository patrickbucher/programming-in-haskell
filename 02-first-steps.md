# First Steps

## Interpreter

Install GHC, the _Glasgow Haskell Compiler_ on Arch Linux:

    # pacman -S ghc

Start the interactive interpreter GHCi:

    $ ghci

Start the interpreter by loading a source file:

    $ ghci scratch.hs

A file can be loaded using the `:load` command:

    > :load scratch.hs
    > :l scratch.hs

A changed file can be reloaded using the `:reload` command:

    > :reload
    > :r

If an editor is set, a file can edited without leaving the session.

The file `hello.hs` is defined as:

    double_plus_one :: Num a => a -> a
    double_plus_one x = 2 * x + 1

The interpreter is started with that file:

    $ ghci hello.hs
    > double_plus_one 3
    7

The editor `vim` is set:

    >:set editor vim

The file is edited:

    >:edit

The new content is (`triple_plus_two` is added):

    double_plus_one :: Num a => a -> a
    double_plus_one x = 2 * x + 1

    triple_plus_two :: Num a => a -> a
    triple_plus_two x = 3 * x + 2

When exiting `vim` and saving using `:x`, the edited module is reloaded
automatically:

    > triple_plus_two 3
    11

Some basic commands of GHCi are:

| Command           | Meaning                   |
|-------------------|---------------------------|
| `:load name`      | load a file with `name`   |
| `:reload`         | reload the current script |
| `:set editor name | set editor to `name`      |
| `:edit name`      | edit file with `name`     |
| `:edit`           | edit current script       |
| `:type expr`      | show the type of `expr`   |
| `:?`              | list all commands         |
| `quit`            | quit GHCi                 |

## Prelude Functions

The _Prelude_ is imported automatically and provides basic functions.

`head` selects the first element of a non-emtpy list:

    head [1,2,3,4]
    1

`tail` removes the first element from a non-empty list:

    tail [1,2,3,4]
    [2,3,4]

`!!` selects the `n`th (zero-based index) element of a list:

    [1,2,3,4,5] !! 2
    3

`take` selects the first `n` elements of a list:

    take 3 [1,2,3,4,5]
    [1,2,3]

`drop` removes the first `n` elements from a list:

    drop 3 [1,2,3,4,5]
    [4,5]

`length` calculates the length of a list:

    length [1,2,3,4]
    4

`sum` calculates the sum of a list:

    sum [1,2,3,4]
    10

`product` calculates the product of a list:

    product [1,2,3,4]
    24

`++` appends two lists:

    [1,2,3] ++ [4,5]
    [1,2,3,4,5]

`reverse` reverses a list:

    reverse [1,2,3,4]
    [4,3,2,1]

## Syntax

Haskell's syntax is very terse and differs from mathematical notations:

| Mathematics | Haskell     | Description                                                                |
|-------------|-------------|----------------------------------------------------------------------------|
| `f(x)`      | `f x`       | apply `f` to `x`                                                           |
| `f(x,y)`    | `f x y`     | apply `f` to `x` and `y`                                                   |
| `f(g(x))    | `f (g x)`   | apply `g` to `x`, and `f` to the result                                    |
| `f(x,g(y))` | `f x (g y)` | apply `g` to `y`, and `f` to `x` and the result of `g`                     |
| `f(x) g(y)` | `f x * g y` | apply `f` to `x`, and `g` to `y`, the build the product of the two results |

The application of a function binds strongest and does not need parentheses.
It's the default operation in Haskell (in math, it's multiplication)

When written in backticks, a function's name can be written between its arguments:

    div 4 2
    2

    4 `div` 2
    2

Functions start with a lower-case letter. Both lower. and upper-case letters,
as well as digits, underscores and single forward quotes can follow.

The following keywords are reserved:

    case   class    data      default   deriving
    do     else     foreign   if        import
    in     infix    infixl    infixr    instance
    let    module   newtype   of        then
    type   where

Definitions at the same level must begin in the same column (layout rule):

    a = b + c
    where
        b = 1
        c = 2

Haskell has single-line and multi-line comments:

    -- This is a single line comment

    {- this is a
       multi-line comment -}

## Exercises

Ex. 1) Work through the examples from this chapter using GHCi.

...

Ex. 2) Parenthesise the following nuemric expressions:

    2^3*4    (2^3)*4
    2*3+4*5  (2*3)+(4*5)
    2+3*4^5  2+(3*(4^5)) 

Ex. 3) The script below contains three syntactic errors. Correct these errors and
then check that your script works properly using GHCi.

    N = a `div` length xs
    where
    a = 10
    xs = [1,2,3,4,5]

    n = a `div` length xs
        where
        a = 10
        xs = [1,2,3,4,5]

Ex. 4) The library function `last` selects the last element of a non-empty list;
for example, `last [1,2,3,4,5] = 5`. Show how the function `last` could be
defined in terms of the other library functions introduced in this chapter. Can
you think of another possible definition?

    last [xs] = head (reverse xs)

    last [xs] = head (drop ((length xs) - 1) xs)

Ex. 5) The library function `init` removes the last element from a non-emtpy list;
for example, `init [1,2,3,4,5] = [1,2,3,4]`. Show how `init` could similarly be
defined in two different ways.

    init [xs] = reverse (tail (reverse xs))

    init [xs] = take (length xs - 1) xs

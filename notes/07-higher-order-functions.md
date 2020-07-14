# Higher Order Functions

Functions can take other functions as arguments. The function `twice` expects a
function as the first argument, and a value as the second argument. It applies
the function twice to the value:

    twice :: (a -> a) -> a -> a
    twice f x = f (f x)

    twice (*2) 3
    12

    twice reverse [1,2,3]
    [1,2,3]

A function that accepts another function as an argument is called a _higher
order function_.

Curried functions, such as `twice`, can be applied partially, and stored for
later use:

    quadruple = twice (*2)
    quadruple 1
    4

## Processing Lists

`map`, defined as a list comprehension, applies a function to all elements of a
list:

    map :: (a -> b) -> [a] -> [b]
    map f xs = [f x | x <- xs]

    map (*3) [1,2,3]
    [3,6,9]

    map even [1,2,3]
    [False,True,False]

    map reverse ["foo","bar","qux"]
    ["oof","rab","xuq"]

Nested lists can be processed by applying `map` to itself:

    map (map (+1)) [[1,2,3],[4,5]]

    [map (+1) [1,2,3], map (+1) [4,5]] 
    [[2,3,4],[5,6]]

`map` can also be defined recursively:

    map :: (a -> b) -> [a] -> [b]
    map f []     = []
    map f (x:xs) = f x : map f xs

The `filter` function selects all elements of a list that satisfy a predicate:

    filter :: (a -> Bool) -> [a] -> [a]
    filter p xs = [x | x <- xs, p x]

    filter even [1..10]
    [2,4,6,8,10]

    filter (> 5) [1..10]
    [6,7,8,9,10]

    filter (/= ' ') "abc def ghi"
    "abcdefghi"

`filter` can be defined recursively, too:

    filter :: (a -> Bool) -> [a] -> [a]
    filter p []                 = []
    filter p (x:xs) | p x       = x : filter p xs
                    | otherwise = filter p xs

`filter` and `map` are often combined to apply functions only to list elements
that satisfy certain criteria:

    sumsquareseven :: [Int] -> Int
    sumsquareseven xs = sum (map (^2) (filter even xs))

    sumsquareseven [1..10]
    220

The standard prelude defines a number of higher-order functions.

`all` decides if all elements of a list satisfy a predicate:

    all even [2,4,6,8]
    True

`any` decides if any element of a list satisfies a predicate:

    any odd [2,4,6,8]
    False

`takeWhile` selects elements from a list until the first element that does not
satisfy the predicate:

    takeWhile even [2,4,6,7,8]
    [2,4,6]

`dropWhile` removes elements from a list until the first element that does not
satisfy the predicate:

    dropWhile odd [1,3,5,6,7]
    [6,7]

## The `foldr` Function

Functions that process lists are often defined using a pattern as follows:

    f []     = v
    f (x:xs) = x # f xs

Where `v` is a value assigned to an empty list, and `#` an operator being
applied to the head of the list.

Some library functions can be defined using this pattern:

    sum []     = 0
    sum (x:xs) = x + sum xs

    product []     = 0
    product (x:xs) = x * product xs

    or []     = True
    or (x:xs) = x || or xs

    and []     = False
    and (x:xs) = x && and xs

The function `foldr` (short for _fold right_) encapsulates this pattern, and
accepts the parameters `v` and `#` as arguments.

The functions aboved can be re-defined using `foldr` as follows:

    sum :: Num  a => [a] -> a
    sum = foldr (+) 0

    product :: Num  a => [a] -> a
    product = foldr (*) 1

    or :: [Bool] -> Bool
    or = foldr (||) False

    and :: [Bool] -> Bool
    and = foldr (&&) True

The `foldr` function itself can be defined recursively:

    foldr :: (a -> b -> b) -> b -> [a] -> b
    foldr f v []     = v
    foldr f v (x:xs) = f x (foldr f v xs)

    foldr (+) 0 [1,2,3]
    6

`foldr` can be understood as a function that replaces the `cons` operator of a
list with the given function `f`, and uses `v` as a replacement value as soon
as the list is exhausted:

    foldr (+) 0 [1,2,3]
    1 : (2 : (3 : []))
    1 + (2 + (3 + 0))

`foldr` is intended to be used with operators that associate to the right:

    foldr (+) 0 [1,2,3]
    1+(2+(3+0))

As a general pattern, `foldr` is evaluated as follows:

    foldr (#) v [x0,x1,...,xn] = x0 # (x1 # (... (xn # v) ...))

## The `foldl` Function

`sum` can be redifened using an operator that associates to the left, and an
additional function called `sum'`:

    sum :: Num a => [a] -> a
    sum = sum' 0
          where
             sum' v []     = v
             sum' v (x:xs) = sum' (v+x) xs

Example:

    sum [2,4,6]
    sum' 0 [2,4,6]
    sum' (0+2) [4,6]
    sum' ((0+2)+4) [6]
    sum' (((0+2)+4)+6) []
    (((0+2)+4)+6)
    ((2+4)+6)
    (6+6)
    12

As a pattern, left-associative functions can be generalised as follows:

    f v []     = v
    f v (x:xs) = f (v # x) xs

An empty list is mapped to a _accumulator_ value `v`. For every step, the
accumulator is re-calculated using the old accumulator value, the operator `#`,
and the list's head.

The `foldl` function implements this pattern, and can be used to simplify the
definition of `sum` from above:

    sum :: Num a => [a] -> a
    sum = foldl (*) 1

Other functions, defined using `foldr` before, can be defined using `foldl` as
follows:

    product :: Num a => [a] -> a
    product = foldl (*) 1

    or :: [Bool] -> Bool
    or = foldl (||) False

    and :: [Bool] -> Bool
    and = foldl (&&) True

`foldl` itself can be defined recursively:

    foldl :: (a -> b -> a) -> a -> [b] -> a
    foldl f v [] = v
    foldl f v (x:xs) = foldl f (f v x) xs

As a general pattern, `foldl` is evaluated as follows:

    foldl (#) v [x0,x1,...,xn] = (... ((v # x0) # x1) ...) # xn

## The Composition Operator

The operator `.` combines two given functions to a single function and returns
this _composition_ as a new function:

    (.) :: (b -> c) -> (a -> b) -> (a -> c)
    f . g = \x -> f (g x)

The composition of `f` and `g` of `x` is defined as `(f . g) x = f (g x)`. The
result of the above definition is a lambda expression that accepts `x` as a
parameter. Example:

    f = (*2)
    g = (+1)
    h = f . g
    h 5
    12

The inner function `g` adds one to the parameter, the outer function `f`
doubles the parameter:

    h 5 = f (g 5)
    h 5 = f 6
    h 5 = 12

The following definitions:

    odd n = not (even n)

    twice f x = f (f x)

    sumsquareseven ns = sum (map (^2) (filter even ns))

Can be simplified using the compose operator:

    odd = not . even

    twice f = f . f

    sumsquareseven = sum . map (^2) . filter even

Note that composition is associative:

    f . (g . h) = (f . g) . h

## Binary String Transmitter

A binary number can be converted to a decimal number by considering every digit
separately with a weight doubling to the left `(w * b)`:

    1101 = (8 * 1) + (4 * 1) + (2 * 0) + (1 * 1)

The weights can be noted in an increasing manner when reversing the binary
number:

    1011 = (1 * 1) + (2 * 1) + (4 * 0) + (8 * 1)

A list of binary digits can be converted to decimal as follows:

    type Bit = Int

    bin2int :: [Bit] -> Int
    bin2int bits = sum [w*b | (w,b) <- zip weights bits']
                   where weights = iterate (*2) 1
                         bits' = reverse bits

`Bit` is introduced as an additional type. The function `iterate` produces an
infinite sequence of numbers starting by 1, and increasing by the factor of 2
with every iteration. Example:

    bin2int [1,0,1,1] = sum [w*b | (w,b) <- zip [1,2,4,8] [1,1,0,1]]
                        sum [w*b | (w,b) <- [1,1,2,1,4,0,8,1]]
                        sum [1*1,2*1,4*0,8*1]
                        sum [1,2,0,8]
                        11

Generally, a reversed four-digit binary number `[a,b,c,d]` can be converted to
binary as follows:

    (1 * a) + (2 * b) + (4 * c) + (8 * d)

This expression can be restructured:


    a + (2 * b) + (4 * c) + (8 * d) | factoring out 2
    a + 2 * (b + (2 * c) + (4 * d)) | factoring out 2
    a + 2 * (b + 2 * (c + (2 * d))) | factoring out 2
    a + 2 * (b + 2 * (c + 2 * (d))) | complicating d with (+ 2 * 0)
    a + 2 * (b + 2 * (c + 2 * (d + 2 * 0)))

The last expression has the same structure as a nested cons operation, where
the first argument is added twice to the second argument. The empty list is
replaced with 0.

The function can thus be simplified using foldr:

    bit2int bits = bit2int' (reverse bits)
    bit2int' = foldr (\x y -> x + 2*y) 0

TODO: p. 84

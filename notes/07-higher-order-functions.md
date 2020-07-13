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

    foldr (#) v [x0,x1,...,xn] = x0 # (x1 # (... (xn # v) ...))

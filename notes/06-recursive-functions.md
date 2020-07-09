# Recursive Functions

The factorial can be computed by a function defined as follows:

    fac :: Int -> Int
    fac 0 = 1
    fac n = n * fac (n-1)

The first definition (`fac 0 = 1`) is the _base case_, to which the _recursive
case`_ (`fac n = n * fac (n-1)` is reduced with every invocation:

    fac 4
    4 * fac 3
    4 * (3 * fac 2)
    4 * (3 * (2 * fac 1))
    4 * (3 * (2 * (1 * fac 0)))
    4 * (3 * (2 * (1 * 1)))
    4 * (3 * (2 * 1))
    4 * (3 * 2)
    4 * 6
    24

The multiplication can be expressed as a recursive function that applies
repeated addition:

    (*) :: Int -> Int -> Int
    m * 0 = 0
    m * n = m + (m * (n-1))

Example:

    4 * 3
    4 + (4 * (3 - 1))
    4 + (4 * 2)
    4 + (4 + (4 * (2 - 1)))
    4 + (4 + (4 * 1))
    4 + (4 + (4 + (4 * (1 - 1))))
    4 + (4 + (4 + (4 * 0)))
    4 + (4 + (4 + 0))
    4 + (4 + 4)
    4 + 8
    12

## Recursion on Lists

The product of a list of numbers can be defined recursively as follows:

    product :: Num a => [a] -> a
    product []     = 1
    product (n:ns) = n * product ns

The product of an empty list is the multiplication's neutral element 1 (base
case). The product of a non-empty list is obtained by the multiplication of
the first element with the list's tail. Example:

    product [2,3,5]
    2 * product [3,5]
    2 * (3 * product [5])
    2 * (3 * (5 * product []))
    2 * (3 * (5 * 1))
    2 * (3 * 5)
    2 * 15
    30

The length of a list can be computed in a similar way:

    length :: [a] -> Int
    length []     = 0
    length (_:xs) = 1 + length xs

The length of an empty list is 0 (base case). For the recursive case, the head
of the list is discarded, and 1 added for every step. Example:

    length [1,2,3,4]
    1 + length [2,3,4]
    1 + 1 + length [3,4]
    1 + 1 + 1 + length [4]
    1 + 1 + 1 + 1 + length []
    1 + 1 + 1 + 1 + 0
    4

A list can be reversed using a recursive function:

    reverse :: [a] -> [a]
    reverse []     = []
    reverse (x:xs) = reverse xs ++ [x]

The reverse of an empty list is an empty list (base case). The reverse of an
non-empty list is its head attached to its reversed tail. Example:

    reverse [1,2,3,4]
    (reverse [2,3,4]) ++ [1]
    ((reverse [3,4]) ++ [2]) ++ [1]
    (((reverse [4]) ++ [3]) ++ [2]) ++ [1]
    ((((reverse []) ++ [4]) ++ [3]) ++ [2]) ++ [1]
    ((([] ++ [4]) ++ [3]) ++ [2]) ++ [1]
    (([4] ++ [3]) ++ [2]) ++ [1]
    ([4,3] ++ [2]) ++ [1]
    [4,3,2] ++ [1]
    [4,3,2,1]

TODO: append operator, p. 62

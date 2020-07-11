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

The append operation can be defined recursively:

    (++) :: [a] -> [a] -> [a]
    []     ++ ys = ys
    (x:xs) ++ ys = x : (xs ++ ys)

Attaching an empty list in front of second list is the same as the second list
(base case). A non-empty list can be attached to the front of a second list by
copying elements of the first list from the left (recursive case). Example:

    [1,2,3] ++ [4,5,6]
    1 : ([2,3] ++ [4,5,6])
    1 : (2 : ([3] ++ [4,5,6]))
    1 : (2 : (3 : ([] ++ [4,5,6])))
    1 : (2 : (3 : ([4,5,6])))
    1 : (2 : ([3,4,5,6]))
    1 : ([2,3,4,5,6])
    [1,2,3,4,5,6]

An element can be inserted at the right spot into an ordered list recursively:

    insert :: Ord a => a -> [a] -> [a]
    insert x []                 = [x]
    insert x (y:ys) | x <= y    = x : y : ys
                    | otherwise = y : insert x ys

Inserting an element into an empty list is a list consisting just of that
element (base case). For the recursive case, two cases must be distinguished.
If the element to be inserted is smaller or equal compared to the list's
leftmost element, the right spot is found. Otherwise, the element must be
inserted in the list's remainder. Example:

    insert 13 [10,20,30]
    insert 13 (10 : [20,30])
    10 : (insert 13 [20,30])
    10 : (insert 13 (20:[30]))
    10 : (13 : 20 : [30])
    10 : (13 : [20,30])
    10 : [13,20,30]
    [10,13,20,30]

The `insert` function can be used to implement _insertion sort_:

    isort :: Ord a => [a] -> [a]
    isort []     = []
    isort (x:xs) = insert x (isort xs)

The leftmost element is to be inserted in the tail of the list, which shrinks
with every step.

Example:

    isort [4,2,1,5]
    insert 4 (isort [2,1,5])
    insert 4 (insert 2 (isort [1,5]))
    insert 4 (insert 2 (insert 1 (isort [5])))
    insert 4 (insert 2 (insert 1 (insert 5 (isort []))))
    insert 4 (insert 2 (insert 1 (insert 5 [])))
    insert 4 (insert 2 (insert 1 [5]))
    insert 4 (insert 2 [1,5])
    insert 4 [1,2,5]
    [1,2,4,5]

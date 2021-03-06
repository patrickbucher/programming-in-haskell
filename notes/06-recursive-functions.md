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

## Multiple Arguments

The `zip` function merges two lists to one, by pairing up the leftmost elements
of both lists to a tuple. The process ends, as soon as one of the two lists is
exhausted:

    zip :: [a] -> [b] -> [(a,b)]
    zip [] _          = []
    zip _ []          = []
    zip (x:xs) (y:ys) = (x,y) : zip xs ys

Two base cases are required, because either the left or right list might be
exhausted first. The remainder is discarded. Example:

    zip [1,2,3] ['a','b','c','d']
    zip (1:[2,3]) ('a':['b','c','d'])
    (1,'a') : zip [2,3] ['b','c','d']
    (1,'a') : (zip (2:[3]) ('b':['c','d']))
    (1,'a') : ((2,'b') : (zip [3] ['c','d']))
    (1,'a') : ((2,'b') : (zip (3:[]) ('c':['d'])))
    (1,'a') : ((2,'b') : ((3,'c') : (zip [] ['d'])))
    (1,'a') : ((2,'b') : ((3,'c') : [])) -- first base case
    (1,'a') : ((2,'b') : [(3,'c')])
    (1,'a') : [(2,'b'),(3,'c')]
    [(1,'a'),(2,'b'),(3,'c')]

The library function `drop` requires two base cases, too:

    drop :: Int -> [a] -> [a]
    drop 0 xs = xs
    drop _ [] = []
    drop n (_:xs) = drop (n-1) xs

Example:

    drop 3 [1,2,3,4,5,6]
    drop 3 (_:[2,3,4,5,6])
    drop 2 [2,3,4,5,6]
    drop 2 (_:[3,4,5,6])
    drop 1 [3,4,5,6]
    drop 1 (_:[4,5,6])
    drop 0 [4,5,6]
    [4,5,6]

## Multiple Recursion

A function that applies itself more than once in its own definition is said to
use _multiple recursion_.  The fibonaccy sequence can be defined recursively
using that technique:

    fib :: Int -> Int
    fib 0 = 0
    fib 1 = 1
    fib n = fib (n-2) + fib (n-1)

Example:

    fib 5
    fib 3 + fib 4
    (fib 1 + fib 2) + (fib 2 + fib 3)
    (1 + (fib 0 + fib 1)) + ((fib 0 + fib 1) + (fib 1 + fib 2))
    (1 + (0 + 1)) + ((0 + 1) + (1 + (fib 0 + fib 1)))
    (1 + 1) + (1 + (1 + (0 + 1)))
    2 + (1 + (1 + 1))
    2 + (1 + 2)
    2 + 3
    5

The function `qsort` uses multiple recursion for sorting the left and right
hand side of the pivot element.

Multiple recursion makes the call stack grow very fast.

## Mutual Recursion

Functions that are defined recursively in terms of each other are said to apply
_mutual recursion_.

The functions `even` and `odd` can be defined (inefficiently) using mutual
recursion:

    even :: Int -> Bool
    even 0 = True
    even n = odd (n-1)

    odd :: Int -> Bool
    odd 0 = False
    odd n = even (n-1)

A number is even, if a number smaller by one is odd, and vice versa.

Example:

    even 7
    odd 6
    even 5
    odd 4
    even 3
    odd 2
    even 1
    odd 0
    False

The even and odd elements of a list in terms of their index can be found in a
similar fashion:

    evens :: [a] -> [a]
    evens []     = []
    evens (x:xs) = x : odds xs

    odds :: [a] -> [a]
    odds []     = []
    odds (_:xs) = evens xs

Example:

    evens "abc"
    evens ('a':['b','c'])
    'a' : odds ['b','c']
    'a' : (odds (_:['c'])
    'a' : (evens ['c'])
    'a' : (evens ('c':[]))
    'a' : ('c' : odds [])
    'a' : ('c' : [])
    'a' : ['c']
    ['a','c']

## Advice on Recursion

Recursive functions can be defined by following this recipe:

1. define the type
2. enumerate the cases
3. define the simple cases
4. define the other cases
5. generalise and simplify

For example, `product` can be defined as follows:

Step 1, define the type:

    product :: [Int] -> Int

Step 2, enumerate the cases:

    product []     =
    product (n:ns) =

Step 3, define the simple cases:

    product [] = 1

Step 4, define the other cases:

    product (n:ns) = n * product ns

Step 5, generalise and simplify:

    product :: Num a => [a] -> a
    product = foldr (*) 1

## Exercises

Ex. 1) How does the recursive version of the factorial function behave if
applied to a negative argument, such as `(-1)`? Modify the definition to
prohibit negative arguments by adding a guard to the recursive case:

Original definition:

    fac :: Int -> Int
    fac 0 = 1
    fac n = n * fac (n-1)

    fac (-1)
    (-1) * (fac (-2))
    (-1) * ((-2) * (fac (-3)))
    ...
    Exception: stack overflow

Improved definition:

    fac :: Int -> Int
    fac 0 = 1
    fac n | n < 0     = 0
          | otherwise = n * fac (n-1)

Ex. 2) Define a recursive function `sumdown :: Int -> Int` that returns the sum
of the non-negative integers from a given value down to zero. For example,
`sumdown 3` should return the result `3+2+1+0 = 6`.

    sumdown :: Int -> Int
    sumdown 0             = 0
    sumdown n | n < 0     = 0
              | otherwise = n + sumdown (n - 1)

Ex. 3) Define the exponentiation operator `^` for non-negative integers using
the same pattern of recursion as the multiplication operator `*`, and show how
the expression `2 ^ 3` is evaluated using your definition.

    (^) :: Int -> Int -> Int
    0 ^ _ = 0
    m ^ 0 = 1
    m ^ n = m * (m ^ (n - 1))

    2 ^ 3
    2 * (2 ^ (3 - 1))
    2 * (2 ^ 2)
    2 * (2 * (2 ^ (2 - 1)))
    2 * (2 * (2 ^ 1))
    2 * (2 * (2 * (2 ^ (1 - 1))))
    2 * (2 * (2 * (2 ^ 0)))
    2 * (2 * (2 * 1))
    2 * (2 * 2)
    2 * 4
    8

Ex. 4) Define a recursive function `euclid :: Int -> Int -> Int` that
implements _Euclid's algorithm_ for calculating the greatest common divisor of
two non-negative integers: if the two numbers are equal, this number is the
result; otherwise, the smaller number is subtracted from the larger, and the
same process is then repeated. For example:

    > euclid 6 27
    3

    euclid :: Int -> Int -> Int
    euclid 0 _ = 0
    euclid _ 0 = 0
    euclid 1 _ = 1
    euclid _ 1 = 1
    euclid x y | x == y = x
               | x > y  = euclid (x - y) y
               | x < y  = euclid (y - x) x

Ex. 5) Using the recursive definitions given in this chapter, show how `length
[1,2,3]`, `drop 3 [1,2,3,4,5]`, and `init [1,2,3]` are evaluated.

    length :: [a] -> Int
    length []     = 0
    length (_:xs) = 1 + length xs

    length [1,2,3]
    length (_:[2,3])
    1 + length [2,3]
    1 + length (_:[3])
    1 + (1 + length [3])
    1 + (1 + length (_:[]))
    1 + (1 + (1 + length []))
    1 + (1 + (1 + 0))
    1 + (1 + 1)
    1 + 2
    3


    drop :: Int -> [a] -> [a]
    drop 0 xs = xs
    drop _ [] = []
    drop n (_:xs) = drop (n-1) xs

    drop 3 [1,2,3,4,5]
    drop 3 (_:[2,3,4,5])
    drop (3 - 1) [2,3,4,5]
    drop 2 [2,3,4,5]
    drop 2 (_:[3,4,5])
    drop (2 - 1) [3,4,5]
    drop 1 [3,4,5]
    drop 1 (_:[4,5])
    drop (1 - 1) [4,5]
    drop 0 [4,5]
    [4,5]

    init :: [a] -> [a]
    init [_]    = []
    init (x:xs) = x : init xs

    init [1,2,3]
    init (1:[2,3])
    1 : init [2,3]
    1 : init (2:[3])
    1 : (2 : init [3])
    1 : (2 : [])
    1 : [2]
    [1,2]

Ex. 6) Without looking at the definitions from the standard prelude, define the
following library functions on lists using recursion.

a.) Decide if all logical values in a list are `True`:

    and :: [Bool] -> Bool
    and []        = True
    and (False:_) = False
    and (True:xs) = and xs

b.) Concatenate a list of lists:

    concat :: [[a]] -> [a]
    concat [[]]     = []
    concat [[xs]]   = [xs]
    concat (xs:[])  = [x | x <- xs]
    concat (xs:xss) = [x | x <- xs] ++ concat xss

c.) Produce a list with `n` identical elements: 

    replicate :: Int -> a -> [a]
    replicate 0 x = []
    replicate n x = [x] ++ replicate (n - 1) x

d.) Select the nth element of a list:

    (!!) :: [a] -> Int -> a
    (!!) (x:_) 0  = x
    (!!) (_:xs) n = xs !! (n - 1)

e.) Decide if a value is an element of a list:

    elem :: Eq a => a -> [a] -> Bool
    elem x []     = False
    elem x (y:ys) | x == y = True
                  | x /= y = elem x ys

Ex. 7) Define a recursive function `merge :: Ord a => [a] -> [a] -> [a]` that
merges two sorted lists to give a single sorted list. For example:

    > merge [2,5,6] [1,3,4]
    [1,2,3,4,5,6]

    merge :: Ord a => [a] -> [a] -> [a]
    merge [] ys     = ys
    merge xs []     = xs
    merge xs (y:ys) = merge ([x | x <- xs, x <= y] ++ [y] ++ [x | x <- xs, x > y]) ys

Ex. 8) Using `merge`, define a function `msort :: Ord a => [a] -> [a]` that
implements _merge sort_, in which the empty list and singleton lists are
already sorted, and any other list is sorted by merging together the two lists
that result from sorting the two halves of the list separately.

Hint: first define a function `halve :: [a] -> ([a],[a])` that splits a list
into two halves whose lengths differ by at most one.

    merge :: Ord a => [a] -> [a] -> [a]
    merge [] ys     = ys
    merge xs []     = xs
    merge xs (y:ys) = merge ([x | x <- xs, x <= y] ++ [y] ++ [x | x <- xs, x > y]) ys

    halve :: [a] -> ([a],[a])
    halve []  = ([],[])
    halve [x] = ([x],[])
    halve xs  = (take ((length xs) `div` 2) xs, drop ((length xs) `div` 2) xs)

    first :: (a,a) -> a
    first (a,_) = a

    second :: (a,a) -> a
    second (_,a) = a

    msort :: Ord a => [a] -> [a]
    msort []  = []
    msort [x] = [x]
    msort xs  = merge (msort (first (halve xs))) (msort (second (halve xs)))

Ex. 9) Using the five step process, construct the library functions that:

a.) calculate the `sum` of a list of numbers;

Step 1: define the type:

    sum :: Num a => [a] -> a

Step 2: enumerate the cases:

    sum []     =
    sum (x:xs) =

Step 3: define the simple cases:

    sum []     = 0

Step 4: define the other cases:

    sum (x:xs) = x + sum xs

Step 5: generalise and simplify:

    [nothing to do]

b.) `take` a given number of elements from the start of a list;

Step 1: define the type:

    take :: Int -> [a] -> [a]

Step 2: enumerate the cases:

    take 0 []     =
    take n []     =
    take 1 (x:_)  =
    take n (x:xs) =

Step 3: define the simple cases:

    take 0 []     = []
    take n []     = []

Step 4: define the other cases:

    take 1 (x:_)  = [x]
    take n (x:xs) = [x] ++ take (n - 1) xs

Step 5: generalise and simplify:

    take :: Int -> [a] -> [a]
    take 1 (x:_)  = [x]
    take n (x:xs) | n <= (length xs) + 1 = [x] ++ take (n - 1) xs
                  | otherwise            = []

c.) select the `last` element of a non-empty list.

Step 1: define the type:

    last :: [a] -> a

Step 2: enumerate the cases:

    last [x]    =
    last (x:xs) =

Step 3: define the simple cases:

    last [x]    = x

Step 4: define the other cases:

    last (x:xs) = last xs

Step 5: generalise and simplify:

    [nothing to do]

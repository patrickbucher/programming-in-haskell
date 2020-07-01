# List Comprehensions

A list comprehension can be used to construct lists from rules:

    [x^2 | x <- [1..5]]
    [1,4,9,16,25]

A list of all squares from 1 to 5 is built. The symbol `|` means _such that_,
and `<-` means _is drawn from_. The expression `x <- [1..5]` is called a
_generator_.

A list can be generated using multiple generators:

    [(x,y) | x <- [1,2,3], y <- [4,5]]
    [(1,4),(1,5),(2,4),(2,5),(3,4),(3,5)]

The order of the generators affects the result's order:

    [(x,y) | y <- [4,5], x <- [1,2,3]]
    [(1,4),(2,4),(3,4),(1,5),(2,5),(3,5)]

The order is established like in a multiplication:

    (a + b) * (c + d) = ac + ad + bc + bd

A later generator can access the expression of an earlier generator:

    [(x,y) | x <- [1..3], y <- [x..3]]
    [(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]

`concat` combines multiple lists to a single list:

    concat :: [[a]] -> [a]
    concat xss = [x | xs <- xss, x <- xs]

`firsts` uses the wildcard pattern to discard second tuple values:

    firsts :: [(a,b)] -> [a]
    firsts ps = [x | (x,_) <- ps]

`length` replaces every list item with `1` and sums it up:

    length :: [a] -> Int
    length xs = sum [1 | _ <- xs]

## Guards

_Guards_ are logical expressions to filter values in list comprehensions.

Often, a predicate function is used:

    [x | x <- [1..10], even x]
    [2,4,6,8,10]

The factors of a number can be found as follows:

    factors :: Int -> [Int]
    factors n = [x | x <- [1..n], n `mod` x == 0]

    factors 15
    [1,3,5,15]

    factors 7
    [1,7]

Prime numbers are numbers with only two factors, 1 and the number itself:

    prime :: Int -> Bool
    prime n = factors n == [1,n]

Using lazy evaluations, prime numbers can be found using a list comprehension:

    primes :: Int -> [Int]
    primes n = [x | x <- [2..n], prime x]
    primes 20
    [2,3,5,7,11,13,17,19]

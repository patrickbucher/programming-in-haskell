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

`find`, when given a key to search for, returns a list of values belonging to
that key:

    find :: Eq a => a -> [(a,b)] -> [b]
    find k t = [v | (k',v) <- t, k == k']

    find 'a' [('a',1),('b',2),('c',3),('a',4)]
    [1,4]

## The `zip` Function

`zip` creates a list by pairing successive elements from two existing lists:

    zip [1,2,3] ['a','b','c']
    [(1,'a'),(2,'b'),(3,'c')]

`pairs` uses `zip` to create a list of adjacent elements:

    pairs :: [a] -> [(a,a)]
    pairs xs = zip xs (tail xs)

    pairs [1,2,3,4]
    [(1,2),(2,3),(3,4)]

`sorted` uses `pairs` to determine if a list is sorted in ascending order:

    sorted :: Ord a => [a] -> Bool
    sorted xs = and [x <= y | (x,y) <- pairs xs]

    sorted [1,2,3,4,5]
    True
    sorted [1,2,4,3,5]
    False

`positions` returns the indices of values found in a list:

    positions :: Eq a => a -> [a] -> [Int]
    positions x xs = [i | (x',i) <- zip xs [0..], x == x']

    positions True [True,False,False,True,False,True]
    [0.3,5]

Thanks to lazy evaluation, the infinite list `[0..]` is only evaluated up to
the point where all `xs` have been processed.

## String Comprehensions

Technically, a `String` is just a list of `Char` values, so list operations can
also be applied to strings.

    "foobar" !! 2
    'o'

    take 3 "foobar"
    foo

    length "foobar"
    6

    zip "abc" [1,2,3,4,5]
    [('a',1),('b',2),('c',3)]

Consequently, _string comprehensions_ are list comprehensions producing lists
of `Char` values.

`lowers` counts the number of lower-case letters in a string:

    lowers :: String -> Int
    lowers xs = length [x | x <- xs, x >= 'a' && x >= 'z']

    lowers 'abc'
    3
    lowers 'Foobar'
    6

`count` counts the number of occurences of a given character in a string:

    count :: Char -> String > Int
    count x xs = length [x' | x' <- xs, x == x']

    count 's' "Mississippi"
    4

## Exmample: Caesar Cipher

The _Caesar Cipher_ is a simple (and insecure) method to encrypt textual
information. Every letter of the alphabet is shifted by an offset, which again
can be used to decrypt the message.

`let2int` converts a character (letter) to an integer:

    let2int :: Char -> Int
    let2int c = ord c - or 'a'

`int2let` performs the opposite operation:

    int2let :: Int -> Char
    int2let n = chr (ord 'a' + n)

`ord` and `chr` are library functions, which convert from characters to integers
(unicode code point) and vice-versa, and need to be imported from `Data.Char`:

    import Data.Char

`shift` moves a letter by n positions, and makes sure the alphabet is wrapped at
the end:

    shift :: Int -> Char -> Char
    shift n c | isLower c = int2let ((let2int c + n) `mod` 26
              | otherwise = c

Only lower-case characters are shifted, other characters are left as they are.
`isLower` is a predicate (`Char -> Bool`) that checks if a character is a
lower-case letter.

The `shift` function can deal with both negative and positive offsets:

    shift 3 'a'
    'd'

    shift (-3) 'd'
    'a'

`encode` applies the `shift` function to an entire string using a list
comprehension:

    encode :: Int -> String -> String
    encode n xs = [shift n x | x <- xs]

    encode 13 "Hello, World!"
    "Hryyb, Wbeyq!"

    encode (-13) "Hryyb, Wbeyq!"
    "Hello, World!"

    encode (-13) (encode 13 "Hello, World!")
    "Hello, World!"

The Caesar cipher can be cracked (i.e. the shift factor can be found) using
_frequency tables_, since letters have different frequencies in natural
languages.

`percent` calculates a percentage using the `fromIntegral` library function,
which converts an integer to a float value:

    percent :: Int -> Int -> Float
    percent n m = (fromIntegral n / fromIntegral m)

    percent 2 8
    0.25

Using `lowers` and `count` from the previous section, `percent` can be used to
calculate the frequencies in a string:

    freqs :: String -> [Float]
    freqs xs = [percent (count x xs) n | x <- ['a'..'z']] where n = lowers xs

    freqs "abbcccdddd"
    [0.1,0.2,0.3,0.4,...] -- omitted

The _chi-square statistic_ compares a list of observed frequencies (`os`) with
expected frequencies (`es`); the smaller the value, the better the match:

    chisqr :: [Float] -> [Float] -> Float
    chisqr os es = sum [((o-e)^2)/e | (o,e) <- zip os es]

`rotate` rotates a list by `n` items:

    rotate :: Int -> [a] -> [a]
    rotate n xs = drop n xs ++ take n xs

    rotate 3 [1,2,3,4,5]
    [4,5,1,2,3]

TODO

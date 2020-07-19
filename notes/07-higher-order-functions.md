# Higher Order Functions

Functions can take other functions as arguments. The function `twice` expects a
function as the first argument, and a value as the second argument. It applies
the function twice to the value:

    twice :: (a -> a) -> a -> a
    twice f x = f (f x)

    > twice (*2) 3
    12

    > twice reverse [1,2,3]
    [1,2,3]

A function that accepts another function as an argument is called a _higher
order function_.

Curried functions, such as `twice`, can be applied partially, and stored for
later use:

    quadruple = twice (*2)

    > quadruple 1
    4

## Processing Lists

`map`, defined as a list comprehension, applies a function to all elements of a
list:

    map :: (a -> b) -> [a] -> [b]
    map f xs = [f x | x <- xs]

    > map (*3) [1,2,3]
    [3,6,9]

    > map even [1,2,3]
    [False,True,False]

    > map reverse ["foo","bar","qux"]
    ["oof","rab","xuq"]

Nested lists can be processed by applying `map` to itself:

    map (map (+1)) [[1,2,3],[4,5]]

    > [map (+1) [1,2,3], map (+1) [4,5]] 
    [[2,3,4],[5,6]]

`map` can also be defined recursively:

    map :: (a -> b) -> [a] -> [b]
    map f []     = []
    map f (x:xs) = f x : map f xs

The `filter` function selects all elements of a list that satisfy a predicate:

    filter :: (a -> Bool) -> [a] -> [a]
    filter p xs = [x | x <- xs, p x]

    > filter even [1..10]
    [2,4,6,8,10]

    > filter (> 5) [1..10]
    [6,7,8,9,10]

    > filter (/= ' ') "abc def ghi"
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

    > sumsquareseven [1..10]
    220

The standard prelude defines a number of higher-order functions.

`all` decides if all elements of a list satisfy a predicate:

    > all even [2,4,6,8]
    True

`any` decides if any element of a list satisfies a predicate:

    > any odd [2,4,6,8]
    False

`takeWhile` selects elements from a list until the first element that does not
satisfy the predicate:

    > takeWhile even [2,4,6,7,8]
    [2,4,6]

`dropWhile` removes elements from a list until the first element that does not
satisfy the predicate:

    > dropWhile odd [1,3,5,6,7]
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

    sum :: Num a => [a] -> a
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

    > foldr (+) 0 [1,2,3]
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

A decimal number can be converted into a binary number by repeatedly dividing
the decimal number by two until 0 is reached. Reading the remainders backwards
gives the sequence of binary digits:

    13 / 2 = 6 R 1
     6 / 2 = 3 R 0
     3 / 2 = 1 R 1
     1 / 2 = 0 R 1

    1101

`int2bin` implements this algorithm:

    int2bin :: Int -> [Bit]
    int2bin n = reverse (int2bin' n)
    int2bin' 0 = []
    int2bin' n = n `mod` 2 : int2bin' (n `div` 2)

    > int2bin 13
    [1,1,0,1]

`make8` ensures that the sequence is always 8 bit (i.e. one byte) long:

    make8 :: [Bit] -> [Bit]
    make8 bits = reverse (take 8 ((reverse bits) ++ repeat 0))

    > make8 (int2bin 25)
    [0,0,0,1,1,0,0,1]

These functions allow to encode strings as binary sequences:

    import Data.Char

    encode :: String -> [Bit]
    encode = concat . map (make8 . int2bin . ord)

The code point of every character is found using `ord`. The code point is then
converted to binary (`int2bin`) and aligned into a byte (`make8`). This is done
for every individual character (`map`). The results are then concatenated.

The reverse process starts by chopping up the entire sequence into blocks of
eight bits:

    chop8 :: [Bit] -> [[Bit]]
    chop8 []   = []
    chop8 bits = take 8 bits : chop8 (drop 8 bits)

Decoding is almost the same as encoding, albeit in reverse order:

    decode :: [Bit] -> String
    decode = map (chr . bin2int) . chop8

The bitstream is first chopped up into bytes. The individual bytes are then
converted to decimals, and the resulting code points are converted to
characters.

    > decode (encode "abc")
    "abc"

The transmission can be simulated as a perfect communication channel using the
_identity function_:

    transmit :: String -> String
    transmit = decode . channel . encode

    channel :: [Bit] -> [Bit]
    channel = id

    > transmit "this is so higher-order"
    "this is so higher-order"

## Voting Algorithms

### First Past the Post

Each person has one vote, and the candidate with the most votes wins. The
following votes have been cast:

    votes :: [String]
    votes = ["Red", "Blue", "Green", "Blue", "Blue", "Red"]

"Blue" got three, "Red" two, and "Green" two votes, hence "Blue" is the winner.

The votes of a specific candidate can be counted as follows:

    count :: Eq a => a -> [a] -> Int
    count x = length . filter (== x)

    > count "Blue" votes
    3

    > count "Red" votes
    2

A list of candidates can be obtained by removing duplicates from the votes
list:

    rmdups :: Eq a => [a] -> [a]
    rmdups [] = []
    rmdups (x:xs) = x : filter (/= x) (rmdups xs)

    > rmdups votes
    ["Red","Blue","Green"] 

Combining the `count` and `rmdups` functions using a list comprehension gives a
list of tuples consisting of the candidate's votes and name:

    import Data.List

    result :: Ord a => [a] -> [(Int,a)]
    result vs = sort [(count v vs, v) | v <- rmdups vs]

The results are sorted (requires `Data.List`) increasingly by the number of
votes.

The winner of the election is the second component of the last tuple in the
list:

    winner :: Ord a => [a] -> a
    winner = snd . last . result

    > winner votes
    "Blue"

### Alternative Vote

Each person can vote for multiple candidates listed in the order of their
preference (first choice, second choice, etc.). Thus, every ballot can contain
multiple candidates:

    ballots :: [[String]]
    ballots = [["Red", "Green"],
               ["Blue"],
               ["Green", "Red", "Blue"],
               ["Blue", "Green", "Red"],
               ["Green"]]

The candidate with the smallest number of first-choice votes ‒ "Red", with only
one first-choice vote ‒ is eliminated from _all_ ballots.

    [["Green"],
     ["Blue"],
     ["Green", "Blue"],
     ["Blue", "Green"],
     ["Green"]]

This process is repeated for "Blue", which has fever first-choice votes than "Green":

    [["Green"],
     [],
     ["Green"],
     ["Green"],
     ["Green"]]

"Green" is the only remaining candidate ‒ and hence the winner.

Empty ballots can removed using `filter` and `map`:

    rmempty :: Eq a => [[a]] -> [[a]]
    rmempty = filter (/= [])

    > rmempty [["Green"],[],["Green"],["Green"],["Green"]]
    [["Green"],["Green"], ["Green"], ["Green"]]

    elim :: Eq a => a -> [[a]] -> [[a]]
    elim x = map (filter (/= x))

    > elim "Red" ballots
    [["Green"],["Blue"],["Green","Blue"],["Blue","Green"],["Green"]]

Using the `result` function from before, the candidates can be ranked as
follows:

    import Data.List

    count :: Eq a => a -> [a] -> Int
    count x = length . filter (== x)

    rmdups :: Eq a => [a] -> [a]
    rmdups [] = []
    rmdups (x:xs) = x : filter (/= x) (rmdups xs)

    result :: Ord a => [a] -> [(Int,a)]
    result vs = sort [(count v vs, v) | v <- rmdups vs]

    rank :: Ord a => [[a]] -> [a]
    rank = map snd . result . map head

    > rank ballots
    ["Red","Blue","Green"]

The results of `rank` can now be discarded from the left, until only one
element ‒ the winner ‒ remains:

    winner :: Ord a => [[a]] -> a
    winner bs = case rank (rmempty bs) of
                    [c]    -> c
                    (c:cs) -> winner (elim c bs)

    > winner ballots
    "Green"

The `case` mechanism allows pattern matching to be used inside a function body.

## Exercises

Ex. 1) Show how the list comprehension `[f x | x <- xs, p x]` can be
re-expressed using the higher-order functions `map` and `filter`.

    -- example implementation
    f :: Int -> Int
    f x = 2 * x

    -- example implementation, too
    p :: Int -> Bool
    p x = x `mod` 2 == 0

    -- example values
    xs :: [Int]
    xs = [1..10]

    > [f x | x <- xs, p x]
    [4,8,12,16,20]

    > map f (filter p xs)
    [4,8,12,16,20]

Ex. 2) Without looking at the definitions from the standard prelude, define the
following higher-order library functions on lists.

a.) Decide if all elements of a list satisfy a predicate:

    all :: (a -> Bool) -> [Bool] -> Bool

    is_true :: Bool -> Bool
    is_true x = x

    all :: (a -> Bool) -> [Bool] -> Bool
    all p []        = True
    all p (True:xs) = all p xs
    all p (False:_) = False

    > all is_true [True,True,True]
    True

    > all is_true [True,False,True]
    False

b.) Decide if any element of a list satisfies a predicate:

    any :: (a -> Bool) -> [Bool] -> Bool

    is_true :: Bool -> Bool
    is_true x = x

    any :: (a -> Bool) -> [Bool] -> Bool
    any p []         = False
    any p (True:_)   = True
    any p (False:xs) = any p xs

    > any is_true [False,False,False]
    False

    > any is_true [False,True,False]
    True

c.) Select elements from a list while they satisfy a predicate:

    takeWhile :: (a -> Bool) -> [a] -> [a]
    takeWhile p []                 = []
    takeWhile p (x:xs) | p x       = [x] ++ Main.takeWhile p xs
                       | otherwise = []

    > takeWhile even [2,4,6,7,8,9]
    [2,4,6]

d.) Remove elements from a list while they satisfy a predicate:

    dropWhile :: (a -> Bool) -> [a] -> [a]
    dropWhile p []                 = []
    dropWhile p (x:xs) | p x       = Main.dropWhile p xs
                       | otherwise = [x] ++ xs

    > dropWhile even [2,4,6,7,8,9]
    [7,8,9]

Note: in the prelude the first two of these functions are generic functions
rather than being specific to the type of lists.

Ex. 3) Redefine the functions `map f` and `filter p` using `foldr`.

    map :: (a -> a) -> [a] -> [a]
    map f = foldr (\x xs -> f x : xs) []

    filter :: (a -> Bool) -> [a] -> [a]
    filter p = foldr (\x xs -> if p x then x:xs else xs) []

Ex. 4) Using `foldl`, define a function `dec2int :: [Int] -> Int` that converts
a decimal number into an integer. For example:

    > dec2int [2,3,4,5]
    2345

    dec2int :: [Int] -> Int
    dec2int xs = foldl (\x y -> x * 10 + y) 0 xs

Ex. 5) Without looking at the definitions from the standard prelude, define the
higher-order library function `curry` that converts a function on pairs into a
curried function, and, conversely, the function `uncurry` that converts a
curried function with two arguments into a function on pairs.

Hint: first write down the types of the two functions.

    curry :: ((a,b) -> c) -> (a -> b -> c)
    curry f = \x y -> f (x,y)

    uncurry :: (a -> b -> c) -> ((a,b) -> c)
    uncurry f = \(x,y) -> f x y

Ex. 6) A higher-order function `unfold` that encapsulates a simple pattern of
recursion for producing a list can be defined as follows:

    unfold p h t x | p x       = []
                   | otherwise = h x : unfold p h t (t x)

That is, the function `unfold p h t` produces the empty list if the predicate
`p` is true of the argument value, and otherwise produces a non-empty list by
applying the function `h` to this value to give the head, and the function `t`
to generate another argument that is recursively processed in the same way to
produce the tail of the list. For example, the function `int2bin` can be
rewritten more compactly using `unfold` as follows:

    int2bin = unfold (== 0) (`mod` 2) (`div` 2)

Redefine the functions `chop8`, `map f` and `iterate f` using `unfold`.

    chop8 :: [Int] -> [[Int]]
    chop8 = unfold (== []) (take 8) (drop 8)

    map :: Eq a => (a -> a) -> [a] -> [a]
    map f = unfold (== []) (\xs -> f (head xs)) (drop 1)

    iterate :: (a -> a) -> a -> [a]
    iterate f = unfold (\_ -> False) f f

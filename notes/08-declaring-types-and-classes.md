# Declaring Types and Classes

New types can be defined in terms of existing types:

    type String = [Char]

Type names start with a capital letter.

Types can be declared in terms of another:

    type Pos = (Int,Int)
    type Trans = Pos -> Pos

Recursive declarations are _not_ allowed:

    type Tree = (Int,[Tree]) -- error

Type declarations can be parameterised by other types:

    type Pair a = (a,a)

    type Assoc k v = [(k,v)]

    find :: Eq k => k -> Assoc k v -> v
    find k t = head [v | (k',v) <- t, k == k']

## Data Declarations

New types, as opposed to synonyms for existing types, can be declared using the
`data` mechanism:

    data Bool = False | True

- the symbol `|` is read as _or_
- the two values are called _constructors_
    - must begin with capital letter
    - must be unique, i.e. cannot be used for more than one type

Example:

    data Move = North | South | East | West

    move :: Move -> Pos -> Pos
    move North (x,y) = (x,y+1)
    move South (x,y) = (x,y-1)
    move East (x,y) = (x+1,y+1)
    move West (x,y) = (x-1,y)

    moves :: [Move] -> Pos -> Pos
    moves [] p     = p
    moves (m:ms) p = moves ms (move m p)

    rev :: Move -> Move
    rev North = South
    rev South = North
    rev East = West
    rev West = East

For use within GHCi, `deriving Show` must follow the data declaration:

    data Move = North | South | East | West deriving Show

Data declaration constructors can have type arguments:

    data Shape = Circle Float | Rect Float Float

    square :: Float -> Shape
    square n = Rect n n

    area :: Shape -> Float
    area (Circle r) = pi * r^2
    area (Rect x y) = x * y

`Circle` and `Rect` are constructor functions, which produce a `Shape` by
arguments of type `Float`:

    > :type Circle
    Circle :: Float -> Shape

    > :type Rect
    Rect :: Float -> Float -> Shape

Data declarations can be parameterised:

    data Maybe a = Nothing | Just a

    safediv :: Int -> Int -> Maybe Int
    safediv _ 0 = Nothing
    safediv m n = Just (m `div` n)

    safehead :: [a] -> Maybe a
    safehead [] = Nothing
    safehead xs = Just (head xs)

## Newtype Declarations

A type with a single constructor with a single argument can be declared using
the `newtype` mechanism:

    newtype Nat = N Int

`N` is a single constructor, and takes a single `Int` argument.

This creates a new, _distinct_ type from `Int`.

The definition with `type` has a different meaning:

    type Nat = Int

Here, `Nat` and `Int` are _synonyms_.

The definition with `data` has the same effect:

    data Nat = N Int

But using `newtype` is more efficient, because the compiler removes the
constructors after type checking.

## Recursive Types

`data` and `newtype`, but not `type`, allow for recursive data type
definitions:

    data Nat = Zero | Succ Nat

A `Nat` is either `Zero` or of the form `Succ n`, which allows for infinite
sequences to represent natural numbers:

    Zero
    Succ Zero
    Succ (Succ Zero)
    Succ (Succ (Succ Zero))
    ...

Converting integers from/to `Nat`can be done using two conversion functions:

    nat2int :: Nat -> Int
    nat2int Zero     = 0
    nat2int (Succ n) = 1 + nat2int n

    int2nat :: Int -> Nat
    int2nat 0 = Zero
    int2nat n = Succ (int2nat (n-1))

Operations, such as the addition, can be expressed in terms of those
conversions:

    add :: Nat -> Nat -> Nat
    add m n = int2nat (nat2int m + nat2int n)

Or by implementing the mechanism for the new type:

    add :: Nat -> Nat -> Nat
    add Zero n     = n
    add (Succ m) n = Succ (add m n)

Example (`2 + 3`):

    add (Succ (Succ Zero)) (Succ Zero)
    Succ (add (Succ Zero) (Succ Zero))
    Succ (Succ (add Zero (Succ Zero)))
    Succ (Succ (Succ Zero))

A parameterised list type can be created using the `data` mechanism:

    data List a = Nil | Cons a (List a)

The list is either empty (`Nil`) or of th eform `Cons x xs` with `x :: a` and
`xs :: List a`.

A `len` function for this type an be implemented as follows:

    len :: List a -> Int
    len Nil         = 0
    len (Cons _ xs) = 1 + len xs

Binary trees can be expressed with this `Tree` type:

    data Tree a = Leaf a | Node (Tree a) a (Tree a)

Each tree element is either a Leaf (with just a value), or a Node, with another
element to the left and right ‒ and a value in the middle.

A tree can be build as follows:

    t :: Tree Int
    t = Node (Node Leaf 1) 3 (Leaf 4)) 5
             (Node Leaf 6) 7 (Leaf 9))

Which represents the following binary tree:

        5
       / \
      3   7
     / \ / \
    1  4 6  9

The `occurs` function checks whether or not a value exists in a tree:

    occurs :: Eq a => a -> Tree a -> Bool
    occurs x (Leaf y)     = x == y
    occurs x (Node l y r) = x == y || occurs x l || occurs x r

A value is either found in a leaf, in the middle of a node, or in either the
left or right subtree of a given node.

A tree can be flattened into a list:

    flatten :: Tree a -> [a]
    flatten (Leaf x)     = [x]
    flatten (Node l x r) = flatten l ++ [x] ++ flatten r

Since the values in the tree are sorted from left to right, the resulting list
of `flatten` is also sorted. Such a tree is called a _search tree_. The
`occurs` function can be optimized for search trees by only looking into the
subtree that possibly can contain a value:

    occurs :: Ord a => a -> Tree a -> Bool
    occurs x (Leaf y)
    occurs x (Node l y r) | x == y    = True
                          | x < y     = occurs x l
                          | otherwise = occurs x r

Alternative tree definitions have only data in their nodes or leaves, data of
different types, or lists of subtrees:

    -- only data in the leaves
    data Tree a = Leaf a | Node (Tree a) (Tree a)

    -- only data in the nodes
    data Tree a = Leaf | Node (Tree a) a (Tree a)

    -- different types in leaves and nodes
    data Tree a b = Leaf a | Node (Tree a b) b (Tree a b)

    -- list of subtrees:
    data Tree a = Node a [Tree a]

## Classes

A class can be defined using the `class` mechanism:

    class Eq a where
        (==), (/=) :: a -> a -> Bool

        x /= y = not (x == y)

A type `a` is an instance of class `Eq`, if it supports the equality and
inequality operators. For the inequality operator, a _default definition_ has
been given, which can optionally be overwritten. New instances only need to
define the equality operator:

    instance Eq Bool where
        False == False = True
        True  == True  = True
        _     == _     = False

Types defined using `data` and `newtype`, but _not_ `type`, can be made into
instances of classes.

Existing classes can be extended to build new classes. Here, `Ord` is defined
as an extension to `Eq` (for `a` to be of type `Ord`, it first must be of type
`Eq`):

    class Eq a => Ord a where
        (<), (<=), (>), (>=) :: a -> a -> Bool
        min, max             :: a -> a -> a

        min x y | x <= y    = x
                | otherwise = y

        max x y | x <= y    = y
                | otherwise = x

`Bool` can be implemented as an instance of `Ord` (and, implicitly, `Eq`):

    instance Ord Bool where
        False < True = True
        _     < _    = False

        b <= c = (b < c) || (b == c)
        b > c  = c < b
        b >= c = c <= b

### Derived Instances

New types can be made into instances of existing classes using the `deriving`
mechenism:

    data Bool = False | True
                deriving (Eq, Ord, Show, Read)

This new type automatically supports the functions of the derived types:

    -- Eq
    > False == False
    True

    -- Ord
    > False < True
    True

    -- Show
    > show False
    "False"

    -- Read
    > read "False" :: Bool
    False

`Ord` uses the position of `False` and `True` as stated in the definition for
its operators.

Read needs additional type information in order to know which type is to be
created, which cannot be inferred automatically.

The types of arguments must also be instances of the derived classes:

    data Shape   = Circle Float | Rect Float Float

    data Maybe a = Nothing | Just a

To derive `Shape` as an equality type, `Float` must also be an equality type.
To derive `Maybe` as an equality type, `a` must also be an equality type
(_class constraint_).

For types derived as an ordered type, values built using constructors with
arguments are ordered lexicographically:

    > Rect 1.0 4.0 < Rect 2.0 3.0
    True

    > Rect 1.0 4.0 < Rect 1.0 3.0
    False

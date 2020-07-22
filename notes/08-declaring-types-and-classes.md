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

TODO: p. 97 ff.

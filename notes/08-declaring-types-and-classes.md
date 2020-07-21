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

For use within in GHCi, `deriving Show` must follow the data declaration.

Data declaration constructors can have arguments:

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

TODO: p. 95 ff.

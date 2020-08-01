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

## Tautology Checker

A _tautology_ is a proposition that is always true, no matter what the values
of the proposition's variables are.

`Prop` is a type that defines different forms of propositions, supporting the
logical operators _not_, _and_, and _implication_:

    data Prop = Const Bool
              | Var Char
              | Not Prop
              | And Prop Prop
              | Imply Prop Prop

Propositions can be defined as follows:

    p1 :: Prop
    p1 = And (Var 'A') (Not (Var 'A'))
    -- A and not A

    p2 :: Prop
    p2 = Imply (And (Var 'A') (Var 'B')) (Var 'A')
    -- (A and B) => A

    p3 :: Prop
    p3 = Imply (Var 'A') (And (Var 'A') (Var 'B'))
    -- A => (A and B)

    p4 :: Prop
    p4 = Imply (And (Var 'A') (Imply (Var 'A') (Var 'B'))) (Var 'B')
    -- (A and (A => B)) => B

`Subst` can be used to substitute variable names with boolean expressions:

    type Assoc k v = [(k,v)]
    type Subst = Assoc Char Bool

The following expression is a substitution that assigns the truth value `False`
to variable `A`, and `True` to variable `B`:

    [('A',False),('B',True)]

The `eval` function evaluates a proposition using such a substitution ‒ and a
slightly modified `find` function from chapter 5:

    find :: Eq a => a -> [(a,b)] -> b
    find k t = head [v | (k',v) <- t, k == k']

    eval :: Subst -> Prop -> Bool
    eval _ (Const b)   = b
    eval s (Var x)     = find x s
    eval s (Not p)     = not (eval s p)
    eval s (And p q)   = eval s p && eval s q
    eval s (Imply p q) = eval s p <= eval s q

The evaluation rules work as follows:

1. A constant expression evaluates to the constant itself.
2. A variable expression can be looked up using the substitutions.
3. A not expression is evaluated as the negation of that expression.
4. An and expression is evaluated by evaluation both variables using the substitutions.
5. An implication is implemented using a trick:
    - Since `False <= True`, and _ex falso quod libet_, the expression is
      `True` if the left hand value is `False`.
    - If the left hand value is `True`, the right hand value must also be
      `True`, or the expression evaluates to `False`.

To check if a proposition is a tautology, all possible substitutions for a
variable need to be considered. To do that, a list of all variables in a
proposition needs to be extracted:

    vars :: Prop -> [Char]
    vars (Const _)   = []
    vars (Var x)     = [x]
    vars (Not p)     = vars p
    vars (And p q)   = vars p ++ vars q
    vars (Imply p q) = vars p ++ vars q

The function `bools` takes a number of variables as argument and produces all
possible permutations of the variables `True` and `False`:

    > bools 3
    [[False, False, False],
     [False, False, True],
     [False, True, False],
     [False, True, True],
     [True, False, False],
     [True, False, True],
     [True, True, False],
     [True, True, True]]

A list of all possible substitutions for `n` variables can be computed by
interpreting a substitution as a binary number of length `n` with `False` as
`0` and `True` as `1`:

    > bools 3
    [[False, False, False], -- 000
     [False, False, True],  -- 001
     [False, True, False],  -- 010
     [False, True, True],   -- 011
     [True, False, False],  -- 100
     [True, False, True],   -- 101
     [True, True, False],   -- 110
     [True, True, True]]    -- 111

The `bools` function can be implemented as follows:

    bools :: Int -> [[Bool]]
    bools 0 = [[]]
    bools n = map (False:) bss ++ map (True:) bss
              where bss = bools (n-1)

A result of size `n` is simply the result of size `n-1`, with once `True` and
once `False` added in front of every element.

The `substs` function, which generates all possible substitutions for a
proposition, can be implemented using the `rmdups` function from chapter 7:

    rmdups :: Eq a => [a] -> [a]
    rmdups [] = []
    rmdups (x:xs) = x : filter (/= x) (rmdups xs)

    substs :: Prop -> [Subst]
    substs p = map (zip vs) (bools (length vs))
               where vs = rmdups (vars p)

The unique variables in the given proposition are mapped to all possible
permutations of boolean values. The function can be used as follows:

    > p1 = And (Var 'A') (Not (Var 'A'))
    > substs p1
    [[('A',False)],
     [('A',True)]]

    > p2 = Imply (And (Var 'A') (Var 'B')) (Var 'A')
    > substs p2
    [[('A',False),('B',False)],
     [('A',False),('B',True)],
     [('A',True),('B',False)],
     [('A',True),('B',True)]]

If all variables in the substitution list of a proposition evaluate to `True`,
then the proposition is a tautology:

    isTaut :: Prop -> Bool
    isTaut p = and [eval s p | s <- substs p]

    > p1 = And (Var 'A') (Not (Var 'A'))
    > isTaut p1
    False

    > p2 = Imply (And (Var 'A') (Var 'B')) (Var 'A')
    > isTaut p2
    True

    > p3 = Imply (Var 'A') (And (Var 'A') (Var 'B'))
    > isTaut p3
    False

    > isTaut p4
    > p4 = Imply (And (Var 'A') (Imply (Var 'A') (Var 'B'))) (Var 'B')
    True

## Abstract Machine

The type `Expr` represents either an integer, or an addition operation of two
other integers:

    data Expr = Val Int | Add Expr Expr

The `value` function evaluates such an expression:

    value :: Expr -> Int
    value (Val n)   = n
    value (Add x y) = value x + value y

Example:

    value (Add (Val 7) (Add (Val 2) (Val 5)))
    value (Val 7) + (Add (Val 2) (Val 5))
    7 + (value (Val 2) + value (Val 5))
    7 + (2 + 5)
    7 + 7
    14

The order of evaluation is determined by Haskell. In order to make the
evaluation order explicit, an _abstract machine_ can be defined.

A _control stack_ is a list of operations to be performed after an avaluation
has been completed:

    type Cont = [Op]

    data Op = EVAL Expr | ADD Int

An expression in the context of a control stack is evaluated as follows:

    eval :: Expr -> Cont -> Int
    eval (Val n) c   = exec c n
    eval (Add x y) c = eval x (EVAL y : c)

For an integer (`Val n`) expression, the control stack is executed.

For an addition (`Add x y`) expression, the first argument (`x`) is evaluated,
and the second argument (`y`) is put on the control stack for evaluation.

The control stack is executed using the `exec` function:

    exec :: Cont -> Int -> Int
    exec [] n           = n
    exec (EVAL y : c) n = eval y (ADD n : c)
    exec (ADD n : c) m  = exec c (n+m)

For an empty control stack, the integer argument is returned.

If an evaluation operation (`EVAL`) is on top of the stack, it is evaluated by
placing the according `ADD` operation on top of the stack.

If an addition operation (`ADD`) is on top of the stack, the remaining control
stack is executed with the sum of the argument `m` and `n` from the top of the
stack.

An integer expression is evaluated using this `value` function:

    value :: Expr -> Int
    value e = eval e []

Notice that the functions `exec` and `value` use _mutual recursion_!

Now an expression is evaluated as follows:

    value (Add (Add (Val 1) (Val 2)) (Val 3))
    eval (Add (Add (Val 1) (Val 2)) (Val 3)) []
    eval (Add (Val 1) (Val 2)) [EVAL (Val 3)]
    eval (Val 1) [EVAL (Val 2), [EVAL (Val 3)]
    exec [EVAL (Val 2), EVAL (Val 3)] 1
    eval (Val 2) [ADD 1, EVAL (Val 3)]
    exec [ADD 1, EVAL (Val 3)] 2
    exec [EVAL (Val 3)] (1 + 2)
    exec [EVAL (Val 3)] 3
    eval (Val 3) [ADD 3]
    exec [ADD 3] 3
    exec [] (3 + 3)
    exec [] 6
    6

## Exercises

TODO: p. 109 ff.

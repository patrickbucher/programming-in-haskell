data Expr = Val Int | Add Expr Expr

folde :: (Int -> a) -> (a -> a -> a) -> Expr -> a
folde f _ (Val i)   = f i
folde f g (Add x y) = g (folde f g x) (folde f g y)

eval :: Expr -> Int
eval (Val i)   = i
eval (Add x y) = eval x + eval y

size :: Expr -> Int
size (Val i)   = 1
size (Add x y) = size x + size y

e0 = (Val 1)
e1 = (Add (Val 1) (Val 2))
e2 = (Add (Val 1) (Add (Val 2) (Val 3)))
e3 = (Add (Add (Val 1) (Val 2)) (Add (Val 3) (Val 4)))

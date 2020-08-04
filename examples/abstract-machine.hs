data Expr = Val Int | Add Expr Expr | Mul Expr Expr

type Cont = [Op]

data Op = EVAL_P Expr | EVAL_M Expr | ADD Int | MUL Int

eval :: Expr -> Cont -> Int
eval (Val n) c   = exec c n
eval (Add x y) c = eval x (EVAL_P y : c)
eval (Mul x y) c = eval x (EVAL_M y : c)

exec :: Cont -> Int -> Int
exec [] n           = n
exec (EVAL_P y : c) n = eval y (ADD n : c)
exec (EVAL_M y : c) n = eval y (MUL n : c)
exec (ADD n : c) m  = exec c (n+m)
exec (MUL n : c) m  = exec c (n*m)

value :: Expr -> Int
value e = eval e []

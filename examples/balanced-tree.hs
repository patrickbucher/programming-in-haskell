data Tree a = Void | Leaf a | Node (Tree a) (Tree a) deriving Show

halves :: [a] -> [[a]]
halves xs = [take n xs, drop n xs]
              where l = length xs
                    m = l `div` 2
                    n = l - m

balance :: [a] -> Tree a
balance []  = Void 
balance [x] = Leaf x
balance xs  = Node (balance x) (balance y)
              where ys = halves xs
                    x = head ys
                    y = head (reverse ys)

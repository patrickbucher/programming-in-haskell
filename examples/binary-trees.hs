data Tree a = Leaf a | Node (Tree a) (Tree a)

t1 :: Tree Int
t1 = Node (Node (Leaf 3) (Leaf 3))
          (Node (Node (Leaf 5) (Leaf 7)) (Leaf 1))

t2 :: Tree Int
t2 = Node (Node (Leaf 3) (Leaf 3))
          (Node (Node (Leaf 5) (Leaf 7)) (Node (Leaf 1) (Leaf 2)))

balanced :: Tree a -> Bool
balanced (Leaf _)   = True
balanced (Node l r) = abs ((leaves l) - (leaves r)) <= 1

leaves :: Tree a -> Int
leaves (Leaf _)   = 1
leaves (Node l r) = (leaves l) + (leaves r)

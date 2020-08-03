-- True if the first list is contained in the second list, False otheriwse
contained :: Eq a => [a] -> [a] -> Bool
contained [] []                     = True
contained [] ys                     = True
contained xs []                     = False
contained (x:xs) (y:ys) | x == y    = and [x == y | (x,y) <- zip xs ys]
                                      && length xs <= length ys
                                      || contained (x:xs) ys
                        | otherwise = contained (x:xs) ys

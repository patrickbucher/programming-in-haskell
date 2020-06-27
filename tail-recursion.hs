-- Source: https://www.youtube.com/watch?v=_JtPhF8MshA


-- Factorial
--
-- without tail recursion
fac 0 = 1
fac x = x * fac (x - 1)

-- fac 4 = 4 * fac 3
-- fac 4 = 4 * (3 * fac 2)
-- fac 4 = 4 * (3 * (2 * fac 1))
-- fac 4 = 4 * (3 * (2 * fac 1))
-- fac 4 = 4 * (3 * (2 * 1 * (fac 0)))
-- fac 4 = 4 * (3 * (2 * 1 * 1))
-- fac 4 = 4 * (3 * (2 * 1))
-- fac 4 = 4 * (3 * 2)
-- fac 4 = 4 * 6
-- fac 4 = 24

-- with tail recursion
fac' 0 = 1
fac' n = gofac n 1
gofac 1 a = a
gofac n a = gofac (n - 1) (a * n)

-- fac' 4 = gofac 4 1
-- fac' 4 = gofac (4 - 1) (1 * 4)
-- fac' 4 = gofac 3 4
-- fac' 4 = gofac 2 12
-- fac' 4 = gofac 1 24
-- fac' 4 = 24
--
-- There is only one recursive call, as the last thing that happens.


-- Fibonacci
--
-- without tail recursion
fib 0 = 0
fib 1 = 1
fib x = fib (x - 1) + fib (x - 2)

-- fib 4 = fib 3 + fib 2
-- fib 4 = fib 2 + fib 1 + fib 1 + fib 0
-- fib 4 = fib 1 + fib 0 + 1 + 1 + 0
-- fib 4 = 1 + 0 + 1 + 1 + 0
-- fib 4 = 3

-- with tail recursion
fib' n = gofib n 0 1
gofib 0 a b = a
gofib 1 a b = b
gofib n a b = gofib (n - 1) b (a + b)

-- fib' 4 = gofib 4 0 1
-- fib' 4 = gofib 3 1 1
-- fib' 4 = gofib 2 1 2
-- fib' 4 = gofib 1 2 3
-- fib' 4 = gofib 0 3 5
-- fib' 4 = 3

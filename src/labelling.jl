

yrqtrfun(dt) = string(year(dt),"Q",quarterofyear(dt))

monthtoquarter(n::Int) = ifelse( 1 <= n <= 12, ifelse(1 <= n <= 3,1,ifelse(4 <= n <= 6,2, ifelse(7 <= n <= 9,3,4)))  ,missing)

perioditerator(t::Int,n::Int) = collect(Iterators.take(Iterators.cycle(1:n),t))

simiterator(t::Int,n::Int) = collect(Iterators.take(Iterators.flatten(Iterators.take(Iterators.repeated(i),n) for i in Iterators.countfrom(1)),t))

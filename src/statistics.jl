

loggrowth(X,n=1; scal=100.0) = scal.*(log.(X) .- lag(log.(X),n))

# function loggrowthfast(X,n=1; scal=100.0)
#     scaledlogx = scal .* log.(X)
#     scaledlogx_n = applyrolling(makekernel(first,-n:0),scaledlogx,missing)
#     out = scaledlogx .- scaledlogx_n
#     return out 
# end


"""
```
autocorrelate(x,n=1;demean=true)
autocorrelate(f,x,n=1;demean=true)
```

Compute the autocorrelation of lag `n` of `x` or `f(x)`. `demean` defaults to true and takes place after `f` is applied.
"""
function autocorrelate(x,n::Int=1; demean::Bool=true)
    T = typeof(zero(eltype(x)) / 1)
    z::Vector{T} = demean ? x .- mean(x) : x
    zz = dot(z, z)
    ac = @views dot(z[1+n:end],z[1:end-n]) / zz
    return ac
end

function autocorrelate(f::Function,x,n::Int=1;demean::Bool=true)
    y = f.(x)
    T = typeof(zero(eltype(y)) / 1)
    z::Vector{T} = demean ? y .- mean(y) : y
    zz = dot(z, z)
    ac = @views dot(z[1+n:end],z[1:end-n]) / zz
    return ac
end

## static kernels are terrible here for long windows, need some branching on n to happen
function varianceratio(x::AbstractVector{T},n::Int) where {T}
    n == 1 && return one(T)
    k = makekernel(sum,-(n-1):0)
    vr = varianceratio(x,k,n)
    return vr
end

function varianceratio(x::AbstractVector{T},k::Kernel,n::Int) where {T}
    v1 = var(x)
    summed = applyrolling(k,x)
    vn = @views var(summed[n:end])
    vr = vn / (n*v1)
    return vr
end

# the below are optimized versions for frequently used horizons
# uses beyond the first will not incur the cost of kernel construction (~250ns)
vr2(x) = varianceratio(x,makekernel(sum,-1:0),2)
vr4(x) = varianceratio(x,makekernel(sum,-3:0),4)
vr6(x) = varianceratio(x,makekernel(sum,-5:0),6)
vr8(x) = varianceratio(x,makekernel(sum,-7:0),8)
vr12(x) = varianceratio(x,makekernel(sum,-11:0),12)





"""
`conditionalcor(f,x,y)`

Compute the correlation between `x` and `y` conditional on some event defined by the function `f(x,y)`. 
The function `f` must return an object that can index into `x` and `y`.

__**Example**__
```
x = randn(1000)
y = randn(1000)
conditionalcor((xx,yy) -> xx .<= 0,x,y)
conditionalcor((xx,yy) -> (xx .<= 0) .& (yy .<= 0),x,y)
```
"""
function conditionalcor(f,x,y)
    loc = f(x,y)
    out = @views cor(x[loc],y[loc])
    return out
end

downsidecor(x,y;q=0.5) = conditionalcor((xx,yy) -> xx .<= quantile(x,q),x,y)

upsidecor(x,y;q=0.5) = conditionalcor((xx,yy) -> xx .>= quantile(x,q),x,y)



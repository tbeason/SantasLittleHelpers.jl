

#########
# THIS SECTION JUST STEALS FROM STATSBASE BUT REMOVES TYPE RESTRICTIONS AND ADDS SIMD


# Skewness
# This is Type 1 definition according to Joanes and Gill (1998)
"""
    skew(v, m=mean(v))

Compute the standardized skewness of iterable `v`.
"""
function skew(v, m::T) where {T<:Union{Missing,Real}}
    n = length(v)
    cm2 = 0.0   # empirical 2nd centered moment (variance)
    cm3 = 0.0   # empirical 3rd centered moment
    @simd for v_i in v
        z = v_i - m
        z2 = z * z

        cm2 += z2
        cm3 += z2 * z
    end
    cm3 /= n
    cm2 /= n
    return cm3 / sqrt(cm2 * cm2 * cm2)  # this is much faster than cm2^1.5
end

skew(v) = skew(v,mean(v))

# (excess) Kurtosis
# This is Type 1 definition according to Joanes and Gill (1998)
"""
    kurt(v, m=mean(v))

Compute the excess kurtosis of iterable `v`.
"""
function kurt(v, m::T) where {T<:Union{Missing,Real}}
    n = length(v)
    cm2 = 0.0  # empirical 2nd centered moment (variance)
    cm4 = 0.0  # empirical 4th centered moment
    @simd for v_i in v
        z = v_i - m
        z2 = z * z
        cm2 += z2
        cm4 += z2 * z2
    end
    cm4 /= n
    cm2 /= n
    return (cm4 / (cm2 * cm2)) - 3.0
end

kurt(v) = kurt(v,mean(v))




"""
    autocorrelate(x,n=1;demean=true)

Compute the autocorrelation of lag `n` of `x`. `demean` defaults to true.
"""
function autocorrelate(x,n::Int=1; demean::Bool=true)
    T = typeof(zero(eltype(x)) / 1)
    z::Vector{T} = demean ? x .- mean(x) : x
    zz = dot(z, z)
    ac = @views dot(z[1+n:end],z[1:end-n]) / zz
    return ac
end

"""
    autocorrelate(f,x,n=1;demean=true)

Compute the autocorrelation of lag `n` of `f(x)`. `demean` defaults to true and takes place after `f` is applied.
"""
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
    conditionalcor(f,x,y)

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


loggrowth(X,n=1; scal=100.0) = scal.*(log.(X) .- lag(log.(X),n))



"""
    correlogram(x,y;leadlags::Int=10)

Create a correlogram from `x` and `y`. By default, uses up to lag 10. Total output is `2*leadlags+1` in size.
If the plot peaks to the left of 0, `x` leads `y`. 
"""
function correlogram(x,y;leadlags::Int=10)
    leadlagrange = -leadlags:leadlags
    N = length(leadlagrange)
    cors = zeros(N)
    k = 1
    for i in -leadlags:0
        cors[k] = @views cor(x[1:end+i],y[(-i+1):end])
        k += 1
    end

    for i in 1:leadlags
        cors[k] = @views cor(x[i+1:end],y[1:end-i])
        k += 1
    end
    return cors,leadlagrange
end


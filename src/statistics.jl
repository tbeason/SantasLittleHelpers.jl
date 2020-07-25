

loggrowth(X,n=1; scal=100.0) = scal.*(log.(X) .- lag(log.(X),n))

# function loggrowthfast(X,n=1; scal=100.0)
#     scaledlogx = scal .* log.(X)
#     scaledlogx_n = applyrolling(makekernel(first,-n:0),scaledlogx,missing)
#     out = scaledlogx .- scaledlogx_n
#     return out 
# end



function ac1(x; demean::Bool=true)
    T = typeof(zero(eltype(x)) / 1)
    z::Vector{T} = demean ? x .- mean(x) : x
    zz = dot(z, z)
    ac = @views dot(z[2:end],z[1:end-1]) / zz
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
vr2(x) = varianceratio(x,makekernel(sum,-1:0),2)
vr4(x) = varianceratio(x,makekernel(sum,-3:0),4)
vr6(x) = varianceratio(x,makekernel(sum,-5:0),6)
vr8(x) = varianceratio(x,makekernel(sum,-7:0),8)
vr12(x) = varianceratio(x,makekernel(sum,-11:0),12)










function downsidecor(x,y;q=0.5)
    qxi = quantile(x,q)
    loc = x .<= qxi
    out = @views cor(x[loc],y[loc])
    return out
end

function upsidecor(x,y;q=0.5)
    qxi = quantile(x,q)
    loc = x .>= qxi
    out = @views cor(x[loc],y[loc])
    return out
end


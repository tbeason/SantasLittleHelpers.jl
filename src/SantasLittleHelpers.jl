module SantasLittleHelpers

using Statistics, Dates, LinearAlgebra
using Missings
using StaticKernels
using ShiftedArrays: lag
using DataFrames



export skew, kurt, autocorrelate, varianceratio, vr2, vr4, vr6, vr8, vr12, loggrowth
export isnanmissing, nantomissing!, showallrows
export applyrolling, makekernel, logdiff
export yrqtrfun, simiterator, perioditerator, monthtoquarter
export conditionalcor, downsidecor, upsidecor

include("rollingkernels.jl")
include("statistics.jl")
include("labelling.jl")
include("datautils.jl")

end # module

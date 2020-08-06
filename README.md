# SantasLittleHelpers.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/tbeason/SantasLittleHelpers.jl.svg?branch=master)](https://travis-ci.com/tbeason/SantasLittleHelpers.jl)
[![codecov.io](http://codecov.io/github/tbeason/SantasLittleHelpers.jl/coverage.svg?branch=master)](http://codecov.io/github/tbeason/SantasLittleHelpers.jl?branch=master)
<!--
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://tbeason.github.io/SantasLittleHelpers.jl/stable)
[![Documentation](https://img.shields.io/badge/docs-master-blue.svg)](https://tbeason.github.io/SantasLittleHelpers.jl/dev)
-->


[![santaslittlehelper.jpg](https://upload.wikimedia.org/wikipedia/en/8/8a/SantasLittleHelper.png)](https://en.wikipedia.org/wiki/Santa%27s_Little_Helper)

I factored out pieces of code that I always found myself using so that it would all live in one spot (here).

This package has
 - Static rolling functions `applyrolling` and `makekernel` using StaticKernels.jl. For small window sizes, this is probably the fastest existing way to do rolling means, sums, etc.
 - Variance ratios `varianceratio`
 - SIMD `skew` and `kurt` functions that are faster and more forgiving than `StatsBase.skewness` and `StatsBase.kurtosis`
 - Autocorrelation function `autocorrelate` because `StatsBase.autocor` was too annoying when you only want the first one, and this is faster. Plus I allow for transformations like `autocorrelate(abs,x)` if you want the autocorrelation of absolute `x`. you can replicate `StatsBase.autocor` via `autocorrelate.(Ref(x),0:L)` where `L` are your desired lags.
 - `correlogram(x,y;leadlags::Int=10)` for cross-correlations
 - `nantomissing!` for DataFrames
 - Conditional correlations `conditionalcor(f,x,y)` spawning `downsidecor` and `upsidecor` (eventually will live in [AsymmetricRisk.jl](https://github.com/tbeason/AsymmetricRisk.jl) when I give it more love)
 - `loggrowth(x,n)` for computing log growth rates over different horizons
 - `simiterator` and `perioditerator` for labelling observations in simulations.
 - `yrqtrfun` and `monthtoquarter` Date-like helper functions
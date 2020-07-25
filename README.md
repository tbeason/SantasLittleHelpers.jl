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


I factored out pieces of code that I always found myself using so that it would all live in one spot (here).

This package has
 - Static rolling functions `applyrolling` and `makekernel` using StaticKernels.jl. For small window sizes, this is probably the fastest existing way to do rolling means, sums, etc.
 - Variance ratios `varianceratio`
 - First order autocorrelation `ac1` because `StatsBase.autocor` was too annoying when you only want the first one, and this is faster.
 - `nantomissing!` for DataFrames
 - Conditional correlations `downsidecor` and `upsidecor` (eventually will live in AsymmetricRisks.jl when I give it more love)
 - `loggrowth(x,n)` for computing log growth rates over different horizons
 - `simiterator` and `perioditerator` for labelling observations in simulations.
 - `yrqtrfun` and `monthtoquarter` Date-like helper functions
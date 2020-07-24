


makekernel(f,r::UnitRange{Int}) = Kernel{(r,)}(w->f(Tuple(w)))
makekernel(f,t::NTuple{2,Int}) = Kernel{(first(t):last(t),)}(w->f(Tuple(w)))
makekernel(f,A::NTuple{<:Any,UnitRange{Int}}) = Kernel{A}(w->f(Tuple(w)))

function applyrolling(f,data,window,filler)
    k=makekernel(f,window)
    return map(k,extend(data,StaticKernels.ExtensionConstant(filler)))
end

function applyrolling(k::Kernel,data,filler)
    return map(k,extend(data,StaticKernels.ExtensionConstant(filler)))
end

function applyrolling(k::Kernel,data)
    return map(k,extend(data,StaticKernels.ExtensionNothing()))
end


logdiff(x) = log(last(x)) - log(first(x))



# below also works but needs to be cleaned up
# for w in 1:12
#     for f in (:sum,:mean,:std,:var,:minimum,:maximum,:median,:middle,:logdiff)
#         nm = Symbol("RollingKernel_",w,"_",f)
#         @eval const $nm = Kernel{(-$w:0,)}(x -> $f(Tuple(x)))
#     end
# end



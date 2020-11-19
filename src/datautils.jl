

isnanmissing(x) =  ismissing(x) || isnan(x)


function nantomissing!(d,x::Union{Integer,Symbol,String})
    if any(isnan,d[!,x])
        allowmissing!(d,x)
	    replace!(d[!,x], NaN => missing)
    end
end

function nantomissing!(d)
	for nm in names(d)
		if eltype(d[!,nm]) <: Float64
			nantomissing!(d,nm)
		end
	end
end






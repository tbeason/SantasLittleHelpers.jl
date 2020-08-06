

isnanmissing(x) =  ismissing(x) || isnan(x)


function nantomissing!(d::AbstractDataFrame,x::Union{Integer,Symbol,String})
    if any(isnan,d[!,x])
        allowmissing!(d,x)
	    replace!(d[!,x], NaN => missing)
    end
end

function nantomissing!(d::AbstractDataFrame)
	for nm in names(d)
		if eltype(d[!,nm]) <: Float64
			nantomissing!(d,nm)
		end
	end
end




showallrows(x) = show(x; allrows=true)
showallrows(io,x) = show(io,x; allrows=true)

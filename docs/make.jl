using Documenter, SantasLittleHelpers

makedocs(
    modules = [SantasLittleHelpers],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Tyler Beason",
    sitename = "SantasLittleHelpers.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/tbeason/SantasLittleHelpers.jl.git",
    push_preview = true
)

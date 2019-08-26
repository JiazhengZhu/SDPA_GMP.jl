using Documenter
using SDPA_GMP

makedocs(
    sitename = "SDPA_GMP",
    format = Documenter.HTML(),
    modules = [SDPA_GMP]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/JiazhengZhu/SDPA_GMP.jl.git"
)

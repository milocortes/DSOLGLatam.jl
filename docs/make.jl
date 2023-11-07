using Documenter
using DSOLGLatam

makedocs(
    sitename = "DSOLGLatam",
    format = Documenter.HTML(),
    modules = [DSOLGLatam]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#

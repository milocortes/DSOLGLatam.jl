using Documenter
using DSOLGLatam

makedocs(
    sitename = "DSOLGLatam",
    format = Documenter.HTML(),
    modules = [DSOLGLatam],
    clean     = true,
    pages = Any[
        "Modelo de Generaciones Traslapadas Dinámico y Estocástico" => "index.md",
        "Modelo" => Any[
           "modelo/dsolg.md"
         ],        
         "Datos" => Any[
          "datos/dsolg_data.md"
        ],
        "Calibración" => Any[
            "calib/dsolg_calib.md"
          ]      
])

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/milocortes/DSOLGLatam.jl.git"
)

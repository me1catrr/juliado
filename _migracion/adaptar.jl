# Adapta las rutas de la vía J tras moverla de resonancia/julia/ a la raíz de JuliaDo.
#
# Las unidades bajan un nivel de profundidad (julia/j1-esencial/j1-1-entorno/ pasa a
# j1-esencial/j1-1-entorno/), así que las rutas que salían de julia/ cambian:
#   - el tema de CairoMakie pasa de recursos/r1-datos/_tema.jl a recursos/_tema.jl;
#   - los enlaces a la vía M y a la vía C apuntan a los sitios publicados;
#   - el resto de rutas a la raíz pierde un «../»;
#   - los tests de Python suben un nivel menos hasta la raíz (parents[4] → parents[3]).
#
# Uso: julia _migracion/adaptar.jl            (aplica y resume)
#      julia _migracion/adaptar.jl --simular  (solo resume)
# Script de un solo uso: queda como registro de la migración.

const RESONANCIA = "https://me1catrr.github.io/resonancia/"
const CLAUDEDO = "https://me1catrr.github.io/claudedo/"
const SIMULAR = "--simular" in ARGS

"Convierte una ruta de fuente Quarto (`mse/m03/index.qmd#sec`) en su URL publicada."
function url_publicada(base, ruta)
    ruta, ancla = occursin('#', ruta) ? split(ruta, '#'; limit=2) .|> String |> Tuple : (ruta, "")
    ruta = replace(ruta, r"(^|/)index\.qmd$" => s"\1", r"\.qmd$" => ".html")
    return base * ruta * (isempty(ancla) ? "" : "#" * ancla)
end

const REGLAS_QMD = [
    "tema" => (r"\.\./\.\./\.\./recursos/r1-datos/_tema\.jl", s -> "../../recursos/_tema.jl"),
    "enlace a M" => (r"\]\(\.\./\.\./\.\./mse/([^)\s]+)\)",
        s -> "](" * url_publicada(RESONANCIA * "mse/", match(r"mse/([^)\s]+)\)", s)[1]) * ")"),
    "enlace a C" => (r"\]\(\.\./\.\./\.\./claude/([^)\s]+)\)",
        s -> "](" * url_publicada(CLAUDEDO, match(r"claude/([^)\s]+)\)", s)[1]) * ")"),
    "ruta a la raíz" => (r"\.\./\.\./\.\./", s -> "../../"),
]
const REGLAS_PY = ["parents[4]" => (r"parents\[4\]", s -> "parents[3]")]

function aplicar!(cuenta, ruta, reglas)
    texto = read(ruta, String)
    nuevo = texto
    for (nombre, (patron, f)) in reglas
        n = length(collect(eachmatch(patron, nuevo)))
        n == 0 && continue
        nuevo = replace(nuevo, patron => f)
        cuenta[nombre] = get(cuenta, nombre, 0) + n
    end
    if nuevo != texto
        SIMULAR || write(ruta, nuevo)
        return 1
    end
    return 0
end

function main()
    cuenta = Dict{String,Int}()
    ficheros = 0
    for nivel in ("j1-esencial", "j2-datos", "j3-computacion"), (dir, _, archivos) in walkdir(nivel)
        # Solo las carpetas de unidad (dos niveles por debajo de la raíz) suben tres «../».
        count(==('/'), dir) >= 1 || continue
        for a in archivos
            ruta = joinpath(dir, a)
            endswith(a, ".qmd") && (ficheros += aplicar!(cuenta, ruta, REGLAS_QMD))
            endswith(a, ".py") && (ficheros += aplicar!(cuenta, ruta, REGLAS_PY))
        end
    end
    println(SIMULAR ? "Simulación" : "Aplicado", ": $ficheros ficheros modificados")
    for (k, v) in sort(collect(cuenta))
        println("  ", rpad(k, 16), v)
    end
end

main()

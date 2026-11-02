# Reduce recursos/bibliografia.bib a las entradas que citan las páginas de este sitio.
#
# Copia literal de cada ficha (con sus campos keywords y verificado), en el orden
# original. La bibliografía completa sigue en Resonancia.
#
# Uso: julia _migracion/subconjunto_bib.jl carpeta1 carpeta2 …
# Script de un solo uso: queda como registro de la migración.

const BIB = "recursos/bibliografia.bib"

"Devuelve [(clave, texto_literal)] de cada entrada @tipo{clave, … } del .bib."
function entradas(texto)
    out = Tuple{String,String}[]
    i = firstindex(texto)
    while (m = match(r"(?m)^@(\w+)\s*\{\s*([^,\s]+)\s*,", texto, i)) !== nothing
        k = m.offset + ncodeunits(m.match)
        prof = 1
        while prof > 0
            c = texto[k]
            c == '{' && (prof += 1)
            c == '}' && (prof -= 1)
            k = nextind(texto, k)
        end
        push!(out, (m.captures[2], texto[m.offset:prevind(texto, k)]))
        i = k
    end
    return out
end

function main(carpetas)
    texto = read(BIB, String)
    todas = entradas(texto)
    paginas = String[]
    for c in carpetas, (dir, _, fs) in walkdir(c), f in fs
        endswith(f, ".qmd") && push!(paginas, read(joinpath(dir, f), String))
    end
    citada(k) = any(p -> occursin(Regex("@\\Q" * k * "\\E(?![A-Za-z0-9_:-])"), p), paginas)
    usadas = filter(e -> citada(e[1]), todas)
    cabecera = """
    % =============================================================================
    % Bibliografía de este sitio: subconjunto de la de Resonancia
    % (https://github.com/me1catrr/resonancia, recursos/bibliografia.bib) con las
    % entradas que citan sus páginas. Mismos campos propios:
    %   keywords   = {grupo}      grupo del informe recursos/_bibliografia.qmd
    %   verificado = {sí: …}      cómo se comprobó la ficha contra el original;
    %              = {no: …}      pendiente de cotejar;
    %              = {parcial: …} parte de la ficha comprobada.
    % El informe se genera con scripts/generar_bibliografia.jl.
    % No se reproduce texto de las obras: se cita y se redacta con palabras propias.
    % =============================================================================
    """
    write(BIB, cabecera * "\n" * join(last.(usadas), "\n\n") * "\n")
    println("$(length(usadas)) de $(length(todas)) entradas conservadas:")
    println(join(first.(usadas), ", "))
end

main(ARGS)

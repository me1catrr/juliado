<p align="center">
  <img src="recursos/identidad/fig/banner.svg" alt="JuliaDo: aprende Julia haciendo. Computación científica." width="760">
</p>

# JuliaDo

**Aprende Julia haciendo.**

JuliaDo es una web de autoformación en programación y computación científica con
[Julia](https://julialang.org/), en tres niveles. Cada unidad tiene teoría breve,
práctica guiada con código que se ejecuta, ejercicios de autoevaluación, un
apartado «Pídeselo a Claude» con su comprobación y diapositivas. Los ejemplos
proceden de la ingeniería de vibraciones y de una planta termosolar.

Web: <https://me1catrr.github.io/juliado/>

## Niveles

| Nivel | Carpeta | Unidades |
|---|---|---|
| **J1** · Julia esencial | `j1-esencial/` | J1.1–J1.8 |
| **J2** · Datos y estadística | `j2-datos/` | J2.1–J2.8 |
| **J3** · Computación científica | `j3-computacion/` | J3.1–J3.9 |

Ficheros clave:

- `temario.yml`: fuente de verdad de identificadores, títulos, carpetas, prerrequisitos, perfiles y duraciones.
- `scripts/generar_estructura.jl`: genera `_navegacion.yml` y las tablas de índice a partir del temario.
- `Resonancia.jl/`: copia del paquete de Resonancia (versión 0.9.0) que usan las unidades.
- `datos/sinteticos/`: datos sintéticos del edificio de tres plantas y de los casos de empresa.

## Origen

JuliaDo era la vía J de [Resonancia](https://github.com/me1catrr/resonancia) y se separó
en un repositorio propio en noviembre de 2026 (commit de origen `resonancia@f677c80`). El
historial anterior de estos ficheros está en Resonancia. Detalles en `_migracion/`.

**Copias compartidas con Resonancia.** `Resonancia.jl/` y `recursos/_tema.jl` son copias
congeladas: la versión de referencia vive en Resonancia. `styles.css`,
`recursos/tikz/resonancia.sty`, `recursos/js/ejercicios.js` y los filtros `scripts/*.lua`
son la base común de Resonancia, JuliaDo y ClaudeDo; los acentos de este sitio están en
`marca.css` y `_brand.yml`. Ninguna copia se descarga al compilar: el sitio es autónomo.

## Compilar en local

Requisitos: [Julia](https://julialang.org/) 1.12 (se recomienda `juliaup`) y
[Quarto](https://quarto.org/) 1.10.

```sh
julia --project=. -e 'using Pkg; Pkg.instantiate()'   # entorno de Julia
quarto preview                                       # vista previa
quarto render                                        # sitio completo en _site/
```

Las páginas que ejecutan Julia guardan sus resultados en `_freeze/` (`freeze: auto`), así que
la publicación no necesita Julia. Si cambias una página con código, compílala en local y
confirma también los cambios de `_freeze/`.

## Pruebas

```sh
julia --project=. -e 'using Pkg; Pkg.test("Resonancia")'     # paquete
uv run pytest j1-esencial j2-datos                           # pestañas Python
julia --project=. scripts/compilar_tikz.jl --comprobar       # figuras TikZ
julia --project=. scripts/generar_estructura.jl --comprobar  # cabeceras frente al temario
julia --project=. scripts/generar_bibliografia.jl --comprobar
```

## Licencias

- **Código y Resonancia.jl:** MIT, véase [`LICENSE`](LICENSE).
- **Textos, diapositivas y figuras:** CC BY-SA 4.0, véase [`LICENSE-CONTENIDO`](LICENSE-CONTENIDO).
- **Datos:** cada conjunto de datos lleva la licencia indicada en su ficha `.meta.toml`.

## Errores, preguntas y sugerencias

Usa los [issues del repositorio](https://github.com/me1catrr/juliado/issues).

## Aviso

JuliaDo es un proyecto docente independiente, sin afiliación con Anthropic ni con el proyecto Julia.

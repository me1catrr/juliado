# JuliaDo — instrucciones para Claude Code

## Qué es este proyecto
Web de autoformación en Quarto: *JuliaDo — Aprende Julia haciendo*, programación y
computación científica con Julia. Responsable único: Rafael Castro Triguero
(GitHub `me1catrr`). Se publica en https://me1catrr.github.io/juliado/.

Tres niveles en la raíz: `j1-esencial/` (J1.1–J1.8), `j2-datos/` (J2.1–J2.8) y
`j3-computacion/` (J3.1–J3.9).

Es un proyecto independiente: las páginas hablan solo de JuliaDo y no enlazan ni remiten
a otros cursos o sitios del autor (Resonancia, matematicado, ClaudeDo). Si una unidad
necesita teoría, se resume en la propia unidad o se cita bibliografía.

## Fuente de verdad
`temario.yml` define identificadores, títulos, carpetas, prerrequisitos, perfiles y
duraciones. No inventes unidades ni identificadores. Si algo falta o cambia, propón
primero el cambio en `temario.yml` y espera aprobación.

## Convenciones de contenido
- Español de España. Término técnico inglés entre paréntesis la primera vez.
- Unidades SI. Notación: f (Hz), ω (rad/s), ζ (amortiguamiento), M, C, K.
- Julia primero. Pestaña Python paralela solo en unidades con `python: true`.
- Toda página que ejecute Julia lleva `engine: julia` en su cabecera.
  Nunca uses Jupyter ni IJulia.
- El código Python de las pestañas no se ejecuta en la web: su versión
  probada vive en la carpeta `python/` de la unidad, con test pytest.
- Figuras con CairoMakie y el tema de `recursos/_tema.jl`. Datos aleatorios siempre con semilla fija.
- No reproduzcas texto de libros ni de fuentes con copyright: redacta con
  palabras propias y cita con `recursos/bibliografia.bib`.

## Plantilla de unidad (orden fijo de secciones)
1. Objetivos y prerrequisitos
2. Teoría breve
3. Práctica guiada (pestañas Julia/Python cuando proceda)
4. «Pídeselo a Claude»: `.callout-tip` con el prompt y un apartado *Verifica*
5. Ejercicios
6. «La doy por superada si…»
Diapositivas: `slides.qmd` (reveal.js) en la misma carpeta de la unidad.

## Metadatos obligatorios en la cabecera de cada unidad
`id`, `title`, `via: J`, `nivel`, `requiere`, `perfil`, `estado` (borrador | revisado |
publicado) y `verificado` (versión de Julia con la que se comprobó).

## Código y entornos
- Un único entorno Julia en la raíz (`Project.toml` + `Manifest.toml`).
- `JuliaDo.jl/` es el paquete local del curso, incorporado con `Pkg.develop` por ruta.
  Toda función que se reutiliza en varias páginas vive allí, con docstring y test
  (`julia --project=. JuliaDo.jl/test/runtests.jl`). No copies funciones entre páginas.
- Python: entorno gestionado con `uv` (`pyproject.toml`). No uses conda.
- `_freeze/`: toda página con código Julia se commitea junto con su `_freeze/`. Tras
  editarla, `quarto render <fichero>` y, en el mismo commit, la página y los ficheros
  que cambien en `_freeze/`. La publicación en GitHub Actions no tiene Julia y lee
  `_freeze/`. No ignores `_freeze/` en `.gitignore`.

## Estilos
`styles.css` es la base de estilos (web y diapositivas); los acentos propios (verde) van
en `marca.scss`.

## Figuras, cajas y bibliografía
- **Reparto de figuras.** TikZ para esquemas y diagramas; Makie u OJS para datos y
  simulaciones. Nada de capturas de páginas como sustituto del texto.
- **TikZ.** Fuente `fig/nombre.tex` (`\documentclass[tikz,border=4pt]{standalone}` y
  `\usepackage{juliado}`). Se compila con `julia --project=. scripts/compilar_tikz.jl`
  y se commitean el `.tex` y el `.svg`. `--comprobar` detecta SVG ausentes o desactualizados.
- **Figuras en la página.** Pie, `{#fig-…}` y `fig-alt` obligatorios. El color nunca es la única señal.
- **Cajas** (`styles.css`): `{#def-…}`, `{#thm-…}`/`{#prp-…}`, `{#exm-…}`, demostración
  plegable, `.idea-clave`, `.callout-warning`, `.caso-real`, `.curiosidad`, `.reto`,
  `.historia` y `.noticia` (solo hechos comprobados con fuente enlazada).
- **Bibliografía.** Una sola fuente, `recursos/bibliografia.bib`, con `keywords` y `verificado`. Las páginas que citan llevan
  `citation-location: margin`. El informe `recursos/_bibliografia.qmd` (no se publica) se
  regenera con `julia --project=. scripts/generar_bibliografia.jl` (`--comprobar` para verificar).
- **Portada de cada unidad.** `fig/portada.tex` (TikZ) y `![](fig/portada.svg){.portada fig-alt="…"}`.
- **Licencias.** Contenido CC BY-SA 4.0; código MIT.

## Ejercicios intercalados
`::: {.ejercicio tipo="…" id="…" respuesta="…" tol="1%" unidad="…"}` con hijos `.pista`,
`.solucion`, `.opciones`, `.retro`, `.rubrica` y `.criterios`. Tipos: `vf`, `opcion`,
`numerico`, `abierta`, `programacion`, `investigacion` y `encuesta`. Los activan
`scripts/ejercicios.lua` y `recursos/js/ejercicios.js`; todo ocurre en el navegador y se
guarda en `localStorage`. Toda respuesta numérica se comprueba antes en Julia. Pruebas:
`deno test --no-check --allow-read recursos/js/`.

## Datos
- `datos/sinteticos/`: en git, públicos, con su ficha `.meta.toml`. Se regeneran con
  `scripts/datos/generar_edificio.jl` y `scripts/datos/generar_casos.jl`.
- `datos/privados/`: NUNCA lo leas, listes, copies ni menciones su contenido.

## Apuntes de consulta (solo locales)
`docs/` (ignorada por Git) puede guardar PDF de consulta. Consulta solo los necesarios
cuando el usuario lo pida; cita título y página; no enlaces ni copies los PDF.
`scripts/no_publicar_docs.ts` comprueba tras el render que `docs/` no llegue a la web.

## Forma de trabajar
- Antes de cambios que afecten a varios ficheros, presenta un plan y espera aprobación.
- Tras editar una página, compruébala con `quarto render <fichero>`.
- Nunca ejecutes `git push`, `quarto publish`, `gh repo create` ni cambies
  la configuración de GitHub sin petición explícita.
- Commits pequeños, mensaje en español en imperativo: «Añade unidad J3.10».

## Comandos útiles
- Vista previa: `quarto preview`
- Compilar una página: `quarto render j3-computacion/j3-8-senales/index.qmd`
- Julia del proyecto: `julia --project=.`
- Estructura: `julia --project=. scripts/generar_estructura.jl [--comprobar]`

# Informe de migración: vía J de Resonancia → JuliaDo

Fecha: 2 de noviembre de 2026. Origen: `me1catrr/resonancia`, commit `f677c80`, más las
páginas J1.3, J1.5 y J3.3 de `1878147` («Redirige a matematicado los enlaces a M2»), que
llegó a `main` durante la migración. Nota de trabajo: no se publica (prefijo `_`).

## Qué se ha hecho

| Paso | Commit | Contenido |
|---|---|---|
| Importación literal | `Importa la vía J desde resonancia@f677c80` | `git archive` de los ficheros versionados necesarios, con sus rutas originales |
| Reorganización | `Reorganiza la vía J en la raíz del sitio` | `git mv`: niveles a la raíz, `julia/index.qmd` → `index.qmd`, `_tema.jl` → `recursos/` |
| Rutas | `Adapta las rutas de la vía J a un sitio autónomo` | `adaptar.jl`: tema (25), rutas a la raíz (15), enlaces a M (22) y a C (4) como URL, `parents[3]` (10) |
| Sitio | `Configura JuliaDo como sitio Quarto autónomo` | `_quarto.yml`, `temario.yml` (solo J), navegación, identidad verde, bibliografía (35 de 136) |
| Documentación | `Adapta la documentación a JuliaDo` | README, CLAUDE.md, «Acerca de», CITATION.cff, plantilla de erratas |
| Tema | `Pasa los acentos de JuliaDo a un tema SCSS` | `marca.scss` en lugar de `_brand.yml` (evita ids repetidos en el `<head>`) |
| `_freeze` | `Incorpora los enlaces a matematicado y corrige el enlace a las diapositivas` | 25 unidades ejecutadas aquí; `slides.html` en `other-links` |

Mapa: `julia/<nivel>/<unidad>/` → `<nivel>/<unidad>/` (URL: `/resonancia/julia/j3-computacion/j3-8-senales/`
→ `/juliado/j3-computacion/j3-8-senales/`). Los slugs y los identificadores no cambian.

## Comprobaciones (todas en local)

| Comprobación | Resultado |
|---|---|
| Ficheros de `julia/` con destino | 187 de 187 |
| Datos sintéticos y `Resonancia.jl` | idénticos byte a byte a los de Resonancia |
| Recuentos | 25 unidades, 25 diapositivas, 215 ejercicios, 50 TikZ, 25 portadas, 16 ficheros de tests Python |
| `quarto render` completo | sin avisos; 25 `_freeze` con hash igual al de su fuente |
| Salidas frente a `resonancia/_freeze/julia` | solo cambian rutas, tiempos medidos (J3.1, J3.5, duración de tests en J3.2) y dos salidas que en Resonancia estaban desactualizadas (J1.2, J3.2) |
| Tests de `Resonancia.jl` (`julia --project=. Resonancia.jl/test/runtests.jl`) | 64 bloques, sin fallos |
| `uv run --frozen pytest j1-esencial j2-datos` | 79 pasan |
| Deno (`recursos/js/`, `no_publicar_docs`) | 18 pasan |
| `pruebas/web/test_enlaces.py` (todo el sitio) | 55 pasan |
| `compilar_tikz.jl --comprobar` | 54 figuras al día |
| `generar_bibliografia.jl --comprobar` | al día |
| `generar_estructura.jl --comprobar` | 7 discrepancias previas (véase abajo) |

## Incidencias

Previas a la migración (también están en Resonancia):

1. **`Pkg.test` de Resonancia.jl falla**: `test/test_lscf.jl` usa `Random`, que no está en `[extras]`
   ni en `[targets]` de `Resonancia.jl/Project.toml`. Con el entorno raíz los tests pasan. Se corrige
   primero en Resonancia (versión de referencia) y se vuelve a copiar.
2. **`requiere` de J1.2–J1.8**: las cabeceras encadenan la unidad anterior (`[J1.1]`…) y `temario.yml`
   no lo declara. Pendiente de decidir en el temario.
3. **Enlace «Diapositivas» roto** (`other-links: slides.qmd` no se convierte en `.html`): corregido aquí;
   en Resonancia sigue en las páginas de M y L.
4. **`_freeze` desactualizado de J1.2 y J3.2** en Resonancia: aquí ya está regenerado.

De la migración:

- Las páginas J2 y J3 no tenían párrafo de presentación; la tabla «Tres niveles» de la portada usa
  dos descripciones de una línea nuevas.
- `Pkg.instantiate` descargó OrdinaryDiffEq (no estaba en el depósito de este equipo).

## Copias que pueden divergir de Resonancia

`Resonancia.jl/` (0.9.0) y `recursos/_tema.jl` son copias congeladas. `styles.css` (base común v1),
`recursos/tikz/resonancia.sty`, `recursos/js/ejercicios.js`, `scripts/ejercicios.lua`,
`scripts/referencias.lua`, `scripts/no_publicar_docs.ts` y `scripts/generar_estructura.jl` son la
base común de los tres sitios.

## Pendiente

- Crear el repositorio `me1catrr/juliado` (privado) y hacer push: requiere autorización expresa.
- GitHub Pages: publicar junto con ClaudeDo y la nueva versión de Resonancia.
- Decidir si matematicado se añade a los sitios hermanos (`curso.hermanos` de `temario.yml`).

tab_metodologiaUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    

    tags$style(HTML("
      .card-header {
        background-color: #1A3A5C !important;
        color: white !important;
      }
    ")),
    
    tags$div(class = "section-header", "Metodología del Análisis"),
    
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("gears"), " 3.1 — Herramientas y Librerías"),
      status = "primary", solidHeader = TRUE,
      tags$p(style = "margin-bottom:12px;",
             "El análisis se realizó en ", tags$strong("R (versión 4.4.1)"),
             " y RStudio. Los paquetes principales utilizados son:"
      ),
      tags$div(
        tags$table(class = "pkg-table",
                   tags$thead(
                     tags$tr(
                       tags$th("Paquete"),
                       tags$th("Función en el análisis")
                     )
                   ),
                   tags$tbody(
                     tags$tr(tags$td(tags$code("tidyverse")),   tags$td("Manipulación y visualización de datos")),
                     tags$tr(tags$td(tags$code("skimr")),       tags$td("Resúmenes descriptivos rápidos")),
                     tags$tr(tags$td(tags$code("janitor")),     tags$td("Limpieza y estandarización de nombres")),
                     tags$tr(tags$td(tags$code("RColorBrewer")),tags$td("Paletas de colores accesibles")),
                     tags$tr(tags$td(tags$code("viridis")),     tags$td("Paletas perceptualmente uniformes")),
                     tags$tr(tags$td(tags$code("patchwork")),   tags$td("Combinación de múltiples gráficos")),
                     tags$tr(tags$td(tags$code("scales")),      tags$td("Formateo de ejes y etiquetas numéricas")),
                     tags$tr(tags$td(tags$code("usmap")),       tags$td("Mapas coropléticos estáticos")),
                     tags$tr(tags$td(tags$code("leaflet")),     tags$td("Mapas interactivos con zoom y popups")),
                     tags$tr(tags$td(tags$code("tigris")),      tags$td("Datos geoespaciales vectoriales de EE.UU.")),
                     tags$tr(tags$td(tags$code("sf")),          tags$td("Operaciones con geometrías espaciales (simple features)")),
                     tags$tr(tags$td(tags$code("htmlwidgets")), tags$td("Integración de widgets JS en R"))
                   )
        )
      )
    ),
    
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("filter"), " 3.2 — Pipeline de Limpieza de Datos"),
      status = "warning", solidHeader = TRUE,
      lapply(seq_along(c(
        "Lectura del CSV con read_csv() usando ruta relativa (here::here())",
        "Limpieza y estandarización de nombres con janitor::clean_names()",
        "Renombrado de variables: year→año, cause_name→causa, state→estado, deaths→muertes, age_adjusted_death_rate→tasa_ajust",
        "Conversión de tipos: as.numeric() para muertes y tasa_ajust; as.integer() para año",
        "Filtro temporal: se conservan solo registros con 1999 ≤ año ≤ 2017",
        "Separación de subconjuntos: datos_us (estado == 'United States') y datos_estados (resto)",
        "Exclusión de 'All causes' en análisis por causa específica para evitar doble conteo"
      )), function(i) {
        paso <- c(
          "Lectura del CSV con read_csv() usando ruta relativa (here::here())",
          "Limpieza y estandarización de nombres con janitor::clean_names()",
          "Renombrado de variables: year→año, cause_name→causa, state→estado, deaths→muertes, age_adjusted_death_rate→tasa_ajust",
          "Conversión de tipos: as.numeric() para muertes y tasa_ajust; as.integer() para año",
          "Filtro temporal: se conservan solo registros con 1999 ≤ año ≤ 2017",
          "Separación de subconjuntos: datos_us (estado == 'United States') y datos_estados (resto)",
          "Exclusión de 'All causes' en análisis por causa específica para evitar doble conteo"
        )[i]
        tags$div(class = "pipeline-step",
                 tags$div(class = "step-num", i),
                 tags$span(paso)
        )
      })
    ),
    
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("table"), " 3.3 — Variables del Dataset"),
      status = "info", solidHeader = TRUE,
      DTOutput(ns("tabla_vars_met"))
    )
  )
}
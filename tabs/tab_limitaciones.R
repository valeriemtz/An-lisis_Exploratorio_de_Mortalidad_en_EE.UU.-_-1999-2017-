# ============================================================
# tabs/tab_limitaciones.R
# Módulo: Limitaciones del Estudio
# ============================================================

tab_limitacionesUI <- function(id) {
  ns <- NS(id)

  limitaciones <- list(
    list(
      icono = "clock",
      titulo = "Período Acotado (1999-2017)",
      texto = "El análisis cubre 1999-2017 y no incluye los efectos de la pandemia
               de COVID-19 (2020) ni tendencias posteriores a 2017. Los hallazgos
               deben interpretarse como una fotografía pre-pandémica.",
      color = "#1A3A5C"
    ),
    list(
      icono = "map-marker-alt",
      titulo = "Granularidad Geográfica Estatal",
      texto = "Los datos están agregados a nivel estatal. No es posible identificar
               disparidades intra-estatales a nivel de condado, ciudad o área rural/urbana,
               lo que puede ocultar inequidades subnacionales.",
      color = "#1A3A5C"
    ),
    list(
      icono = "file-alt",
      titulo = "Posible Subregistro de Causas",
      texto = "La calidad del registro de causas de muerte puede variar entre estados
               y años. Causas como Alzheimer podrían estar subregistradas en períodos
               tempranos por cambios en prácticas diagnósticas.",
      color = "#1A3A5C"
    ),
    list(
      icono = "database",
      titulo = "Datos Agregados sin Microdatos",
      texto = "No se dispone de microdatos individuales, lo que impide análisis por
               grupo etario, sexo, raza/etnia o nivel socioeconómico dentro de cada
               causa de muerte.",
      color = "#1A3A5C"
    ),
    list(
      icono = "link",
      titulo = "Correlación ≠ Causalidad",
      texto = "Este es un análisis exploratorio descriptivo. Las asociaciones
               observadas no implican causalidad y requieren estudios adicionales
               con diseños analíticos apropiados (cohortes, estudios ecológicos, etc.).",
      color = "#1A3A5C"
    )
  )

  tagList(
    tags$div(class = "section-header", "Limitaciones del Estudio"),
    tags$p(style = "color:#1A3A5C; font-size:0.88rem; margin-bottom:18px;",
      "Toda investigación tiene límites metodológicos y de datos. A continuación
       se documentan las principales limitaciones de este análisis para orientar
       la interpretación correcta de los hallazgos."
    ),
    lapply(limitaciones, function(lim) {
      tags$div(
        class = "limitacion-card",
        style = paste0("border-left-color:", lim$color, ";"),
        tags$h6(
          style = paste0("color:", lim$color, ";"),
          icon(lim$icono), " ", lim$titulo
        ),
        tags$p(style = "font-size:0.87rem; color:#555; margin:0;", lim$texto)
      )
    })
  )
}

tab_limitacionesServer <- function(id, datos_us, datos_estados) {
  moduleServer(id, function(input, output, session) {
    # Este módulo es estático (no requiere outputs reactivos)
  })
}

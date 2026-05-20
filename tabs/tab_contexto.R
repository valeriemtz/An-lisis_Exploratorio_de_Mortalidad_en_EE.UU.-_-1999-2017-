# ============================================================
# tabs/tab_contexto.R
# Módulo: Marco Teórico y Contexto
# ============================================================

tab_contextoUI <- function(id) {
  ns <- NS(id)

  tagList(
    tags$div(class = "section-header",
      "Marco Teórico y Estado del Conocimiento"
    ),
    tags$p(style = "color:#666; font-size:0.88rem; margin-bottom:20px;",
      "Sustento bibliográfico sobre tendencias y disparidades en mortalidad en EE.UU. (1999-2017)."
    ),

    # ── 2.1 Enfermedades crónicas ──────────────────────────────
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("heart-pulse"), " 2.1 — El Predominio de las Enfermedades Crónicas"),
      status = "primary", solidHeader = TRUE,
      tags$div(class = "texto-academico",
        "EE.UU. completó hace décadas la transición epidemiológica que desplazó
         a las enfermedades infecciosas, dando paso al predominio de enfermedades
         crónicas. Desde mediados del siglo XX, las enfermedades cardíacas, el
         cáncer y el stroke han ocupado consistentemente los primeros lugares.
         Tras décadas de reducción, la mortalidad cardiovascular comenzó a
         estabilizarse ~2010 (Shah et al., 2019). Paralelamente, Alzheimer,
         diabetes y enfermedades renales han incrementado su contribución,
         reflejando el envejecimiento poblacional y el aumento de obesidad.
         Los accidentes no intencionales crecieron impulsados por la crisis
         de opioides (Daugherty et al., 2019)."
      )
    ),

    # ── 2.2 Disparidades geográficas ──────────────────────────
    tags$style(HTML("
      .cards-contexto-row {
        display: flex;
        flex-wrap: wrap;
      }
      .cards-contexto-row > div {
        display: flex;
        flex-direction: column;
      }
      .cards-contexto-row .card {
        flex: 1;
        min-height: 280px !important;
        max-height: 280px !important;
        height: 280px !important;
        overflow: hidden !important;
      }
      .cards-contexto-row .card-body {
        overflow: hidden !important;
        padding-top: 8px !important;
      }
    ")),
    fluidRow(
      class = "cards-contexto-row",
      column(6,
        bs4Card(
          width = 12, collapsible = FALSE,
          title = tags$span(icon("map-location-dot"), " 2.2 — Disparidades Geográficas"),
          status = "warning", solidHeader = TRUE,
          tags$div(class = "texto-academico",
            style = "margin-top:0;",
            "El estudio de James, Cossman y Wolf (2018) demostró que los condados
             con mortalidad alta se concentran en la división Este Sur Central
             (Alabama, Kentucky, Mississippi y Tennessee). La brecha pasó de 50 a
             220 muertes por 100,000 en cinco décadas, atribuida a menor nivel
             socioeconómico, peor acceso a salud y mayor prevalencia de riesgo."
          )
        )
      ),
      column(6,
        bs4Card(
          width = 12, collapsible = FALSE,
          title = tags$span(icon("chart-line"), " 2.3 — Análisis Temporal y por Ranking"),
          status = "info", solidHeader = TRUE,
          tags$div(class = "texto-academico",
            style = "margin-top:0;",
            "El Alzheimer ha ascendido en el ranking por envejecimiento poblacional;
             los accidentes escalaron por la crisis de opioides. Estos cambios
             reflejan transformaciones en perfiles de riesgo y en la efectividad
             de intervenciones de salud pública."
          )
        )
      )
    ),

    # ── Tabla operacionalización de variables ──────────────────
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("table"), " Operacionalización de Variables"),
      status = "secondary", solidHeader = TRUE,
      DTOutput(ns("tabla_variables"))
    )
  )
}

tab_contextoServer <- function(id, datos_us, datos_estados) {
  moduleServer(id, function(input, output, session) {

    output$tabla_variables <- renderDT({
      df_vars <- data.frame(
        Variable     = c("año (year)", "causa (cause_name)", "estado (state)",
                         "muertes (deaths)", "tasa_ajust"),
        Tipo         = c("Numérica", "Categórica", "Categórica", "Numérica", "Numérica"),
        Descripción  = c("Año de registro del dato",
                         "Nombre de la causa de muerte",
                         "Estado o agregado nacional",
                         "Número absoluto de muertes",
                         "Tasa ajustada por edad por 100,000 hab."),
        Escala       = c("Razón", "Nominal", "Nominal", "Razón", "Razón"),
        stringsAsFactors = FALSE
      )
      datatable(df_vars,
        options  = list(dom = 't', pageLength = 10, scrollX = TRUE),
        rownames = FALSE,
        class    = "stripe hover compact"
      ) %>%
        formatStyle("Variable",
          fontWeight = "bold",
          color      = "#1a3a5c"
        ) %>%
        formatStyle("Tipo",
          backgroundColor = styleEqual(
            c("Numérica", "Categórica"),
            c("#eaf4fb", "#fef9f0")
          )
        )
    })
  })
}

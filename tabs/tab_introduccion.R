# ============================================================
# tabs/tab_introduccion.R
# Módulo: Introducción / Home
# ============================================================

tab_introduccionUI <- function(id) {
  ns <- NS(id)

  tagList(
    # ── Título principal ───────────────────────────────────────
    tags$div(class = "section-header",
      tags$h3("Análisis Exploratorio de Mortalidad en EE.UU. (1999-2017)",
              style = "margin:0; font-size:1.4rem; color:#1a3a5c;")
    ),

    # ── Value Boxes ────────────────────────────────────────────
    tags$style(HTML("
      .vb-intro-row .small-box {
        min-height: 110px !important;
        max-height: 110px !important;
        height: 110px !important;
        overflow: hidden !important;
      }
      .vb-intro-row .small-box .inner h3 {
        font-size: 1.6rem !important;
        white-space: nowrap;
      }
      .vb-intro-row .small-box .inner p {
        font-size: 0.82rem !important;
        white-space: nowrap;
      }
    ")),
    fluidRow(
      class = "vb-intro-row",
      valueBoxOutput(ns("vb_muertes"),  width = 3),
      valueBoxOutput(ns("vb_causas"),   width = 3),
      valueBoxOutput(ns("vb_estados"),  width = 3),
      valueBoxOutput(ns("vb_periodo"),  width = 3)
    ),

    # ── Pregunta central ───────────────────────────────────────
    tags$div(class = "pregunta-central",
      "¿Cómo han cambiado las principales causas de muerte en Estados Unidos
       a lo largo del tiempo (1999-2017) y qué diferencias persistentes
       se observan entre los distintos estados?"
    ),

    # ── 3 Dimensiones del análisis ─────────────────────────────
    fluidRow(
      column(4,
        tags$div(class = "dimension-card",
          tags$div(class = "dimension-icon", "📅"),
          tags$h5("Dimensión Temporal"),
          tags$p("Tendencias, puntos de inflexión e importancia relativa
                  de causas a lo largo de dos décadas (1999-2017).")
        )
      ),
      column(4,
        tags$div(class = "dimension-card",
          tags$div(class = "dimension-icon", "🗺️"),
          tags$h5("Dimensión Geográfica"),
          tags$p("Disparidades entre estados y regiones, persistencia
                  territorial de alta mortalidad en el Sur-Appalachia.")
        )
      ),
      column(4,
        tags$div(class = "dimension-card",
          tags$div(class = "dimension-icon", "📊"),
          tags$h5("Dimensión de Ranking"),
          tags$p("Posición relativa de causas en el tiempo, patrones
                  regionales en variaciones del ranking anual.")
        )
      )
    ),

    tags$br(),

    # ── Sección 1.1 — Contexto del problema ────────────────────
    fluidRow(
      column(12,
        bs4Card(
          width = 12,
          title = tags$span(style = "color:#fff;", icon("circle-info"), " 1.1 — Contexto del Problema"),
          status = "navy", solidHeader = TRUE, collapsible = FALSE,
          tags$div(class = "texto-academico",
            tags$p("Las enfermedades crónicas no transmisibles constituyen la principal
              carga de mortalidad en Estados Unidos. Afecciones como las enfermedades
              cardíacas, el cáncer, las enfermedades cerebrovasculares, la diabetes,
              las enfermedades renales, la enfermedad de Alzheimer y las enfermedades
              respiratorias crónicas han figurado sistemáticamente entre las principales
              causas de defunción durante décadas. A este grupo se suman causas externas
              como los suicidios y las lesiones no intencionales (accidentes), que también
              representan una parte significativa de la mortalidad anual."),
            tags$p("La mortalidad no se distribuye uniformemente en el territorio. Un estudio
              de James, Cossman y Wolf (2018) demostró que las disparidades geográficas
              persisten en el tiempo: los condados con mortalidad persistentemente alta se
              concentran en el Sur rural (división Este Sur Central). La brecha entre esta
              región y el resto del país pasó de ~50 a ~220 muertes por 100,000 habitantes
              en cinco décadas — lo que los autores denominan 'The difference between the Heart of America and Dixiela'."),
            tags$p("El presente estudio se centra en el período 1999-2017, años clave para
              comprender las dinámicas de salud del país antes de la pandemia de COVID-19.")
          )
        )
      )
    ),

    # ── Secciones 1.2 y 1.3 ────────────────────────────────────
    fluidRow(
      column(6,
        bs4Card(
          width = 12,
          title = tags$span(style = "color:#fff;", icon("database"), " 1.2 — Contexto del Dataset"),
          status = "navy", solidHeader = TRUE, collapsible = FALSE, height = "200px",
          tags$div(class = "texto-academico",
            tags$p("El dataset utilizado es ", tags$strong("'NCHS - Leading Causes of Death: United States'"),
              ". Los CDC, a través del NCHS y el NVSS, recopilan todos los certificados de
               defunción emitidos en los 50 estados y el Distrito de Columbia.")
          )
        )
      ),
      column(6,
        bs4Card(
          width = 12,
          title = tags$span(style = "color:#fff;", icon("gears"), " 1.3 — Estructura del Análisis"),
          status = "navy", solidHeader = TRUE, collapsible = FALSE, height = "200px",
          tags$ul(style = "font-size:0.88rem; line-height:1.7;",
            tags$li(tags$strong("Período:"), " 1999-2017 (19 años)"),
            tags$li(tags$strong("Fuente:"), " CDC/NCHS/NVSS"),
            tags$li(tags$strong("Causas:"), " 10 principales + All Causes"),
            tags$li(tags$strong("Cobertura:"), " 50 estados + D.C."),
            tags$li(tags$strong("Variables clave:"), " Muertes absolutas & Tasa ajustada por edad")
          )
        )
      )
    )
  )
}

tab_introduccionServer <- function(id, datos_us, datos_estados) {
  moduleServer(id, function(input, output, session) {

    # ── Value box: total muertes acumuladas ──────────────────
    output$vb_muertes <- renderValueBox({
      req(datos_us)
      total <- datos_us %>%
        filter(causa %in% c("All Causes", "All causes")) %>%
        summarise(t = sum(muertes, na.rm = TRUE)) %>%
        pull(t)
      bs4ValueBox(
        value    = paste0(format(round(total / 1e6, 1), big.mark = ","), "M"),
        subtitle = "Muertes acumuladas 1999-2017",
        icon     = icon("heart-pulse"),
        color    = "navy"
      )
    })

    # ── Value box: causas analizadas ─────────────────────────
    output$vb_causas <- renderValueBox({
      bs4ValueBox(
        value    = "10",
        subtitle = "Causas de muerte analizadas",
        icon     = icon("list"),
        color    = "navy"
      )
    })

    # ── Value box: estados ───────────────────────────────────
    output$vb_estados <- renderValueBox({
      req(datos_estados)
      n <- datos_estados %>% pull(state) %>% unique() %>% length()
      bs4ValueBox(
        value    = n,
        subtitle = "Estados + D.C.",
        icon     = icon("map"),
        color    = "navy"
      )
    })

    # ── Value box: período ───────────────────────────────────
    output$vb_periodo <- renderValueBox({
      bs4ValueBox(
        value    = "19 años",
        subtitle = "Período analizado (1999-2017)",
        icon     = icon("calendar"),
        color    = "navy"
      )
    })
  })
}

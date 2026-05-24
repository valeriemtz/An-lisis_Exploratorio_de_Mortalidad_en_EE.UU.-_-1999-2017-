# ============================================================
# tabs/tab_conclusiones.R
# Módulo: Conclusiones e Insights
# ============================================================

tab_conclusionesUI <- function(id) {
  ns <- NS(id)

  insights <- list(
    list(
      num    = "01",
      icono  = "heartbeat",
      titulo = "El dominio inquebrantable de las enfermedades crónicas",
      texto  = "Heart disease y Cancer se mantuvieron como las dos principales causas
                de muerte durante todo el período 1999-2017, acumulando más de 12,000
                y 10,000 unidades de tasa respectivamente. Su dominio es estructural
                y refleja la consolidada transición epidemiológica de EE.UU.",
      color  = "#1A3A5C"
    ),
    list(
      num    = "02",
      icono  = "exclamation-triangle",
      titulo = "La crisis silenciosa de las 'muertes por desesperación'",
      texto  = "Suicide y Unintentional injuries mostraron tendencias ascendentes
                sostenidas mientras la mayoría de las enfermedades crónicas se
                estabilizaban o reducían. Los accidentes no intencionales crecieron
                impulsados principalmente por la crisis de opioides, que afectó
                de manera desproporcionada a comunidades rurales y de clase trabajadora.",
      color  = "#1A3A5C"
    ),
    list(
      num    = "03",
      icono  = "map-marked-alt",
      titulo = "Disparidades regionales profundas y persistentes",
      texto  = "West Virginia, Mississippi, Alabama y Kentucky consistentemente
                muestran las tasas ajustadas más altas del país. Estas disparidades
                no son aleatorias: responden a factores estructurales como menor
                nivel socioeconómico, acceso limitado a servicios de salud y mayor
                prevalencia de conductas de riesgo, tal como documentan James,
                Cossman y Wolf (2018).",
      color  = "#1A3A5C"
    ),
    list(
      num    = "04",
      icono  = "brain",
      titulo = "El Alzheimer emerge como un desafío creciente",
      texto  = "La enfermedad de Alzheimer escaló posiciones en el ranking durante
                el período, reflejando el envejecimiento de la población y
                posiblemente una mejora en el registro y diagnóstico de la enfermedad.
                Este patrón anticipa uno de los mayores retos de salud pública
                para las próximas décadas.",
      color  = "#1A3A5C"
    ),
    list(
      num    = "05",
      icono  = "list-ol",
      titulo = "El ranking es dinámico, pero el top 2 es inamovible",
      texto  = "Aunque el ranking de causas mostró cambios relevantes (Alzheimer
                subió, Stroke y CLRD se mantuvieron estables, los accidentes
                escalaron), Heart disease y Cancer conservaron el #1 y #2
                sin excepción durante los 19 años analizados.",
      color  = "#1A3A5C"
    ),
    list(
      num    = "06",
      icono  = "globe-americas",
      titulo = "La carga de mortalidad se concentra geográficamente",
      texto  = "El análisis del mapa coroplético revela que la alta mortalidad se
                concentra en una banda del Sur-Appalachia. Esta concentración
                geográfica persiste independientemente de la causa analizada,
                sugiriendo determinantes estructurales compartidos más allá de
                factores individuales de riesgo.",
      color  = "#1A3A5C"
    )
  )

  tagList(
    tags$div(class = "section-header", "Conclusiones e Insights del Análisis"),

    # ── 6 Insight cards ───────────────────────────────────────
    tags$style(HTML("
      .insight-row-equal {
        display: flex;
        flex-wrap: wrap;
      }
      .insight-row-equal > div {
        display: flex;
        flex-direction: column;
        margin-bottom: 14px;
      }
      .insight-row-equal .insight-card {
        flex: 1;
        height: 100%;
      }
    ")),
    fluidRow(
      class = "insight-row-equal",
      lapply(insights, function(ins) {
        column(6,
          tags$div(
            class = "insight-card",
            style = paste0("border-left-color:", ins$color, ";"),
            tags$div(
              style = "display:flex; align-items:center; margin-bottom:8px;",
              tags$span(class = "insight-numero",
                        style = paste0("background:", ins$color, ";"),
                        ins$num),
              tags$span(
                style = "font-size:1rem; margin-right:8px;",
                icon(ins$icono, style = paste0("color:", ins$color, ";"))
              ),
              tags$h5(style = "margin:0; color:#1a3a5c; font-size:0.92rem;",
                      ins$titulo)
            ),
            tags$p(style = "font-size:0.84rem; color:#555; line-height:1.65; margin:0;",
                   ins$texto)
          )
        )
      })
    ),

    tags$br(),

    # ── Reflexión final ────────────────────────────────────────
    bs4Card(
      width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
      headerBorder = FALSE,
      title = tags$span(style = "color:#fff;", icon("flag-checkered"), " Reflexión Final"),
      tags$div(class = "texto-academico",
        tags$p(
          "Este análisis exploratorio confirma que la mortalidad en EE.UU. es un
           fenómeno multidimensional: temporal, geográfico y causal. Los patrones
           identificados antes de la pandemia de COVID-19 sientan las bases para
           comprender cómo las fragilidades preexistentes del sistema de salud
           amplificaron el impacto de la crisis sanitaria de 2020."
        ),
        tags$p(
          "Futuros estudios deberían incorporar datos post-2017, niveles de
           análisis subnacional y variables socioeconómicas para profundizar
           en los determinantes de las disparidades observadas."
        )
      )
    ),

    # ── Referencias bibliográficas ─────────────────────────────
    bs4Card(
      width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
      headerBorder = FALSE,
      title = tags$span(style = "color:#fff;", icon("book-open"), " Referencias Bibliográficas"),
      tags$div(class = "referencias",
        tags$p(
          tags$strong("James, W., Cossman, J., & Wolf, J. K. (2018)."),
          " Persistence of death in the United States: The remarkably different mortality patterns between America's Heartland and Dixieland. ",
          tags$em("Demographic Research, 39"), ", 897–910. ",
          tags$a(href = "https://doi.org/10.4054/DemRes.2018.39.33",
                 target = "_blank",
                 "https://doi.org/10.4054/DemRes.2018.39.33")
        ),
        tags$p(
          tags$strong("Shah, N. S., Lloyd-Jones, D. M., O'Flaherty, M., Capewell, S., Kershaw, K. N., Carnethon, M., & Khan, S. S. (2019)."),
          " Trends in cardiometabolic mortality in the United States, 1999-2017. ",
          tags$em("JAMA, 322"), "(8), 780–782. ",
          tags$a(href = "https://doi.org/10.1001/jama.2019.11245",
                 target = "_blank",
                 "https://doi.org/10.1001/jama.2019.11245")
        ),
        tags$p(
          tags$strong("Daugherty, J., Waltzman, D., Sarmiento, K., & Xu, L. (2019)."),
          " Traumatic brain injury–related deaths by race/ethnicity, sex, intent, and mechanism of injury — United States, 2000–2017. ",
          tags$em("MMWR. Morbidity and Mortality Weekly Report, 68"), "(46), 1050–1056. ",
          tags$a(href = "https://doi.org/10.15585/mmwr.mm6846a2",
                 target = "_blank",
                 "https://doi.org/10.15585/mmwr.mm6846a2")
        ),
        tags$p(
          tags$strong("CDC/NCHS. (2017)."),
          " National Vital Statistics System. ",
          tags$a(href = "https://www.cdc.gov/nchs/nvss/",
                 target = "_blank",
                 "https://www.cdc.gov/nchs/nvss/")
        ),
        tags$p(
          tags$strong("West Virginia Department of Health and Human Resources, Violence & Injury Prevention Program (WVDHHR–VIPP)."),
          " Violence & Injury Prevention Program. ",
          tags$a(href = "https://dhhr.wv.gov/vip/about/Pages/default.aspx",
                 target = "_blank",
                 "https://dhhr.wv.gov/vip/about/Pages/default.aspx")
        )
      )
    )
  )
}

tab_conclusionesServer <- function(id, datos_us, datos_estados) {
  moduleServer(id, function(input, output, session) {
    # Módulo estático 
  })
}

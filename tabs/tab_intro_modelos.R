# ============================================================
# tabs/tab_intro_modelos.R
# Sección 12 — Introducción a la Comparación de Modelos
# ============================================================

tab_intro_modelosUI <- function(id) {
  ns <- NS(id)

  tagList(

    # ── Encabezado ───────────────────────────────────────────
    tags$div(
      class = "mod-header",
      style = "background: linear-gradient(135deg, #0f2340 0%, #1D3557 60%, #2a4a72 100%);",
      tags$span(class = "mod-badge", "Sección 12 · Modelos Predictivos"),
      tags$h3(icon("book-open"), " Comparación de Modelos Predictivos"),
      tags$p(
        "Validación empírica del ARIMA frente a ETS y Regresión Lineal.",
        " Unintentional Injuries – West Virginia (1999–2017)."
      )
    ),

    # ── Contexto introductorio ────────────────────────────────
    tags$div(
      style = paste0(
        "background:#ffffff; border:1px solid #dee2e6; border-top:none;",
        "border-radius:0 0 10px 10px; padding:26px 28px 22px; margin-bottom:20px;"
      ),
      tags$p(
        style = "font-size:0.92rem; line-height:1.85; color:#2c2c2c; margin-bottom:12px;",
        "El modelo ", tags$strong("ARIMA(0,1,0) with drift"),
        " fue implementado en la sección anterior como estándar metodológico",
        " en epidemiología de series de mortalidad. Sin embargo, la selección",
        " de un modelo predictivo requiere validación empírica frente a alternativas."
      ),
      tags$p(
        style = "font-size:0.92rem; line-height:1.85; color:#2c2c2c; margin-bottom:12px;",
        "En esta sección se implementan dos modelos adicionales,",
        tags$strong(" ETS (Suavizamiento Exponencial de Holt)"),
        " y",
        tags$strong(" Regresión Lineal con tendencia temporal"),
        ", y se realiza una comparación sistemática que justifica la elección final",
        " mediante criterios de información, validación cruzada de series de tiempo",
        " y diagnóstico de residuos."
      ),
      tags$p(
        style = "font-size:0.92rem; line-height:1.85; color:#2c2c2c; margin-bottom:0;",
        "El foco es la serie de ",
        tags$strong("Unintentional Injuries – West Virginia"),
        ", por ser la causa de mayor crecimiento en el último año y la de mayor",
        " relevancia para política pública dentro del eje central del caso de estudio."
      )
    ),

    # ── Tarjetas de navegación ────────────────────────────────
    tags$div(
      style = "display:grid; grid-template-columns:1fr 1fr; gap:14px;",

      # Sección 13 — ETS
      tags$div(
        style = paste0(
          "background:#fff; border-radius:8px; padding:18px 20px;",
          "border:1px solid #dee2e6; border-left:4px solid #1A3A5C;",
          "box-shadow:0 1px 4px rgba(0,0,0,0.05);"
        ),
        tags$p(
          style = "margin:0 0 4px; font-size:0.68rem; font-weight:700;
                   text-transform:uppercase; letter-spacing:0.9px; color:#1A3A5C;",
          "Sección 13"
        ),
        tags$p(
          style = "margin:0 0 6px; font-size:0.97rem; font-weight:700; color:#1A3A5C;",
          icon("wave-square"), " Modelo ETS"
        ),
        tags$p(
          style = "margin:0 0 14px; font-size:0.82rem; color:#555; line-height:1.55;",
          "Suavizamiento exponencial con selección automática por AICc.",
          " Componentes Error, Trend y Seasonality."
        ),
        actionButton(
          ns("ir_ets"),
          label  = tagList(icon("wave-square"), " Modelo ETS"),
          style  = paste0(
            "background:#1A3A5C !important; color:#fff !important; border:none;",
            "border-radius:6px; padding:6px 14px; font-size:0.8rem;",
            "font-weight:600; width:100%;"
          )
        )
      ),

      # Sección 14 — Regresión Lineal
      tags$div(
        style = paste0(
          "background:#fff; border-radius:8px; padding:18px 20px;",
          "border:1px solid #dee2e6; border-left:4px solid #1A3A5C;",
          "box-shadow:0 1px 4px rgba(0,0,0,0.05);"
        ),
        tags$p(
          style = "margin:0 0 4px; font-size:0.68rem; font-weight:700;
                   text-transform:uppercase; letter-spacing:0.9px; color:#1A3A5C;",
          "Sección 14"
        ),
        tags$p(
          style = "margin:0 0 6px; font-size:0.97rem; font-weight:700; color:#1A3A5C;",
          icon("ruler"), " Regresión Lineal"
        ),
        tags$p(
          style = "margin:0 0 14px; font-size:0.82rem; color:#555; line-height:1.55;",
          "Benchmark OLS con tendencia temporal. ŷₜ = β₀ + β₁·t + εₜ.",
          " Modelo de referencia mínimo."
        ),
        actionButton(
          ns("ir_regresion"),
          label  = tagList(icon("ruler"), " Regresión Lineal"),
          style  = paste0(
            "background:#1A3A5C !important; color:#fff !important; border:none;",
            "border-radius:6px; padding:6px 14px; font-size:0.8rem;",
            "font-weight:600; width:100%;"
          )
        )
      ),

      # Secciones 15–16 — Comparación (ancho completo)
      tags$div(
        style = paste0(
          "background:#fff; border-radius:8px; padding:18px 20px;",
          "border:1px solid #dee2e6; border-left:4px solid #1A3A5C;",
          "box-shadow:0 1px 4px rgba(0,0,0,0.05); grid-column: 1 / -1;"
        ),
        tags$p(
          style = "margin:0 0 4px; font-size:0.68rem; font-weight:700;
                   text-transform:uppercase; letter-spacing:0.9px; color:#1A3A5C;",
          "Secciones 15–16"
        ),
        tags$p(
          style = "margin:0 0 6px; font-size:0.97rem; font-weight:700; color:#1A3A5C;",
          icon("scale-balanced"), " Comparación y Selección del Modelo Óptimo"
        ),
        tags$p(
          style = "margin:0 0 14px; font-size:0.82rem; color:#555; line-height:1.55;",
          "Evaluación sistemática mediante AIC/AICc/BIC, diagnóstico de residuos (Ljung-Box)",
          " y validación cruzada de series de tiempo (tsCV). Justificación del modelo final."
        ),
        actionButton(
          ns("ir_comparacion"),
          label  = tagList(icon("scale-balanced"), " Comparación de Modelos"),
          style  = paste0(
            "background:#1A3A5C !important; color:#fff !important; border:none;",
            "border-radius:6px; padding:6px 18px; font-size:0.8rem;",
            "font-weight:600;"
          )
        )
      )
    )
  )
}

# ── SERVER ────────────────────────────────────────────────────────────────────
tab_intro_modelosServer <- function(id, parent_session) {
  moduleServer(id, function(input, output, session) {

    observeEvent(input$ir_ets, {
      updateTabItems(session = parent_session, inputId = "menu_principal", selected = "ets")
    })

    observeEvent(input$ir_regresion, {
      updateTabItems(session = parent_session, inputId = "menu_principal", selected = "regresion")
    })

    observeEvent(input$ir_comparacion, {
      updateTabItems(session = parent_session, inputId = "menu_principal", selected = "comparacion")
    })

  })
}

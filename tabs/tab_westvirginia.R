# tab_westvirginia.R 

tab_westvirginiaUI <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(class = "section-header", "Estudio de Caso: West Virginia"),
    tags$p(style = "color:#666; font-size:0.88rem; margin-bottom:14px;",
      "Estado con la clasificación más alta en tasa de mortalidad ajustada por edad en 2017."
    ),

    fluidRow(
      valueBoxOutput(ns("vb_tasa_wv"),    width = 4),
      valueBoxOutput(ns("vb_ranking_wv"), width = 4),
      valueBoxOutput(ns("vb_causa1_wv"),  width = 4)
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("chart-line"),
              " West Virginia: tendencias por causa (Unintentional injuries destacada)"),
      status = "navy", solidHeader = TRUE,
      plotlyOutput(ns("plot_wv_lineas"), height = "380px"),
      tags$div(class = "nota-analitica",
        icon("triangle-exclamation"), tags$strong(" Hallazgo clave: "),
        "Desde 2014, 'Unintentional injuries' muestra una tendencia creciente,
         consistente con la crisis de opioides."
      ),
      tags$div(class = "texto-academico", style = "margin-top:10px; color:#333;",
        "Mientras todas las demás causas descienden o se estabilizan,",
        tags$strong(" las lesiones no intencionales rompen esa tendencia en 2014 y aceleran."),
        " Ese quiebre coincide con el agravamiento de la epidemia de sobredosis de opioides",
        " documentada por el WVDHHR, que convirtió las intoxicaciones en la principal causa de muerte",
        " accidental entre menores de 45 años.",
        tags$strong(" Esta curva es, en esencia, la huella visible de la crisis de opioides.")
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("magnifying-glass-chart"),
              " Subcausas detrás de Unintentional injuries — WVDHHR"),
      status = "navy", solidHeader = TRUE,
      tags$p(style = "font-size:0.81rem; color:#666; margin-bottom:14px;",
        "El Programa de Prevención de Violencia y Lesiones de West Virginia (WVDHHR) identifica",
        " cinco categorías principales detrás del crecimiento de esta causa."
      ),
      tags$style(HTML("
        .subcausas-grid {
          display: flex;
          flex-wrap: wrap;
          gap: 14px;
          margin-bottom: 14px;
        }
        .subcausa-card {
          flex: 0 0 calc(33.333% - 10px);
          box-sizing: border-box;
          border: 1px solid #dce3ea;
          border-radius: 6px;
          padding: 14px;
          min-height: 150px;
        }
      ")),
      tags$div(class = "subcausas-grid",
        # Fila 1
        tags$div(class = "subcausa-card",
          style = "border-top:3px solid #1A3A5C;",
          tags$p(style = "font-size:0.82rem; font-weight:700; color:#1A3A5C; margin-bottom:6px;",
            icon("pills"), " Sobredosis de medicamentos recetados"),
          tags$p(style = "font-size:0.79rem; color:#555; margin:0;",
            "Principal subcausa. En 2012 se emitieron 259 millones de prescripciones de opioides en EE.UU.",
            " En WV, más del 95% de los reportes de abuso correspondían a opioides;",
            " la oxicodona fue el más frecuente."
          )
        ),
        tags$div(class = "subcausa-card",
          style = "border-top:3px solid #1A3A5C;",
          tags$p(style = "font-size:0.82rem; font-weight:700; color:#1A3A5C; margin-bottom:6px;",
            icon("head-side-virus"), " Traumatismo craneoencefálico (TBI)"),
          tags$p(style = "font-size:0.79rem; color:#555; margin:0;",
            "20% de las muertes por lesión en el estado (411 en 2015).",
            " El 79% de los casos en mayores de 65 años son consecuencia de caídas,",
            " reflejando la dinámica de envejecimiento poblacional."
          )
        ),
        tags$div(class = "subcausa-card",
          style = "border-top:3px solid #1A3A5C;",
          tags$p(style = "font-size:0.82rem; font-weight:700; color:#1A3A5C; margin-bottom:6px;",
            icon("car-burst"), " Accidentes de tráfico"),
          tags$p(style = "font-size:0.79rem; color:#555; margin:0;",
            "341 muertes en 2015, el 17% de las muertes por lesión.",
            " Cifra elevada en relación con la densidad poblacional del estado."
          )
        ),
        # Fila 2 — alineadas desde la izquierda, mismo ancho fijo
        tags$div(class = "subcausa-card",
          style = "border-top:3px solid #1A3A5C;",
          tags$p(style = "font-size:0.82rem; font-weight:700; color:#1A3A5C; margin-bottom:6px;",
            icon("child"), " Abuso y negligencia infantil"),
          tags$p(style = "font-size:0.79rem; color:#555; margin:0;",
            "Responsable del 26% de las muertes por lesión en menores de 5 años en 2015."
          )
        ),
        tags$div(class = "subcausa-card",
          style = "border-top:3px solid #1A3A5C;",
          tags$p(style = "font-size:0.82rem; font-weight:700; color:#1A3A5C; margin-bottom:6px;",
            icon("house-crack"), " Violencia de pareja"),
          tags$p(style = "font-size:0.79rem; color:#555; margin:0;",
            "Factor de riesgo documentado en el perfil epidemiológico del estado,",
            " con impacto indirecto en la mortalidad por lesiones."
          )
        )
      ),
      tags$div(
        style = "margin-top:18px; background:#1A3A5C; border-radius:6px; padding:16px 20px; color:#fff;",
        tags$p(style = "font-size:0.83rem; font-weight:700; margin-bottom:6px; color:#fff;",
          icon("circle-info"), " Estos factores conforman un patrón estructural de vulnerabilidad"
        ),
        tags$p(style = "font-size:0.79rem; color:#cdd8e3; margin:0; line-height:1.6;",
          "No son independientes: se refuerzan mutuamente en un contexto de pobreza rural,",
          " bajo acceso a tratamiento, factores conductuales y alta concentración de prescripción de opioides.",
          " Su resolución requiere intervenciones territoriales focalizadas que aborden los determinantes",
          " sociales, económicos y de acceso a servicios de salud específicos de West Virginia."
        )
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("chart-bar"),
              " 9.1 — Comparación de muertes: 1999 vs 2017 por causa"),
      status = "navy", solidHeader = TRUE,
      plotlyOutput(ns("plot_wv_barras"), height = "360px")
    ),


    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("chart-line"),
              " Comparación Interactiva: West Virginia vs otro Estado"),
      status = "navy", solidHeader = TRUE,
      fluidRow(
        column(5, selectInput(ns("estado_comp"), "Estado a comparar:",
                              choices = NULL, selected = "Virginia")),
        column(4, selectInput(ns("causa_comp"), "Causa:",
                              choices = NULL, selected = "All causes"))
      ),
      plotlyOutput(ns("plot_comp_lineas"), height = "340px"),
      tags$div(class = "nota-analitica",
        icon("circle-info"),
        " WV en ", tags$strong(style = "color:#1A3A5C;", "azul marino"),
        " — estado comparado en ",
        tags$strong(style = "color:#85C1E9;", "azul claro"), "."
      )
    ),

    # ── ARIMA ─────────────────────────────────────────────────────────────────
    tags$div(class = "section-header", "Modelo Predictivo ARIMA — West Virginia (2018–2022)"),

    tags$style(HTML("
      .arima-boxes .small-box { height: 100px; display: flex; flex-direction: column; justify-content: center; }
      .arima-boxes .inner { flex: 1; }
    ")),
    fluidRow(
      class = "arima-boxes",
      valueBoxOutput(ns("vb_arima_total"), width = 4),
      valueBoxOutput(ns("vb_arima_acc"),   width = 4),
      valueBoxOutput(ns("vb_ljung"),       width = 4)
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("chart-line"), " Proyeccion ARIMA — Tasa ajustada total (All causes)"),
      status = "navy", solidHeader = TRUE,
      plotlyOutput(ns("plot_arima_total"), height = "380px"),
      tags$div(class = "nota-analitica",
        icon("circle-info"), tags$strong(" Interpretacion: "),
        "La tasa total de West Virginia se proyecta estable alrededor de 957 por 100,000 hab.
         El estado mejora gradualmente pero sin cerrar la brecha con la media nacional.
         Bandas: IC 80% (oscuro) e IC 95% (claro)."
      ),
      tags$div(class = "texto-academico", style = "margin-top:10px; color:#333;",
        "El modelo ARIMA proyecta una continuación de la tendencia observada entre 1999 y 2017,",
        " a un ritmo moderado y con intervalos de confianza amplios,",
        " resultado esperado dado el tamaño reducido de la serie (19 observaciones anuales).",
        tags$strong(" West Virginia mejora gradualmente, pero sin converger con la media nacional,"),
        " lo que sugiere que la reducción proyectada no alcanzará para cerrar la brecha estructural",
        " en el horizonte analizado."
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("chart-line"), " Proyeccion ARIMA — Unintentional Injuries"),
      status = "navy", solidHeader = TRUE,
      plotlyOutput(ns("plot_arima_acc"), height = "380px"),
      tags$div(class = "nota-analitica",
        icon("triangle-exclamation"), tags$strong(" Hallazgo clave: "),
        "El modelo proyecta una continuacion del crecimiento acelerado desde 2014,
         superando 120 por 100,000 hacia 2022 si persisten las condiciones estructurales
         vinculadas a la epidemia de opioides. Es la proyeccion con mayores implicaciones
         de politica publica."
      ),
      tags$div(class = "texto-academico", style = "margin-top:10px; color:#333;",
        tags$strong("Esta es la proyección con mayores implicaciones de política pública."),
        " El modelo captura la aceleración estructural iniciada en 2014,",
        " vinculada directamente a la epidemia de sobredosis de opioides documentada por el WVDHHR,",
        " y la proyecta hacia 2018-2022.",
        " Si las condiciones estructurales persisten sin intervención focalizada,",
        " la tasa de lesiones no intencionales en West Virginia continuará creciendo,",
        tags$strong(" consolidando la brecha ya identificada respecto al promedio nacional"),
        " y al resto de los estados del Clúster 3.",
        tags$br(),
        tags$strong("Validación: "), "La prueba de Ljung-Box (p-value > 0.05) confirma que los residuos",
        " son independientes, es decir, el modelo capturó toda la estructura de la serie.",
        " Las proyecciones deben leerse como indicadores de dirección de tendencia,",
        " con mayor confiabilidad en el corto plazo."
      )
    )
  )
}

tab_westvirginiaServer <- function(id, datos_us, datos_estados) {
  moduleServer(id, function(input, output, session) {

    col_causa   <- "cause_name"
    col_estado  <- "state"
    col_tasa    <- "age_adjusted_death_rate"
    col_muertes <- "deaths"
    col_year    <- "year"

    observe({
      req(datos_estados)
      estados_disp <- datos_estados[[col_estado]] %>% unique() %>% sort()
      estados_disp <- estados_disp[estados_disp != "West Virginia"]
      updateSelectInput(session, "estado_comp",
        choices  = estados_disp,
        selected = if ("Virginia" %in% estados_disp) "Virginia"
                   else if ("California" %in% estados_disp) "California"
                   else estados_disp[1]
      )
      causas_disp <- datos_estados[[col_causa]] %>% unique() %>% sort()
      updateSelectInput(session, "causa_comp",
        choices  = causas_disp,
        selected = if ("All causes" %in% causas_disp) "All causes" else causas_disp[1]
      )
    })

    # ── Value boxes ───────────────────────────────────────────────────────────
    output$vb_tasa_wv <- renderValueBox({
      tasa <- datos_estados %>%
        filter(.data[[col_estado]] == "West Virginia",
               .data[[col_year]]   == 2017,
               .data[[col_causa]]  == "All causes") %>%
        pull(all_of(col_tasa))
      bs4ValueBox(
        value    = if (length(tasa) > 0 && !is.na(tasa[1])) round(as.numeric(tasa[1]), 1) else "N/D",
        subtitle = "Tasa ajustada WV en 2017 (por 100k)",
        icon = icon("heart-pulse"), color = "navy"
      )
    })

    output$vb_ranking_wv <- renderValueBox({
      ranking_df <- datos_estados %>%
        filter(.data[[col_year]] == 2017, .data[[col_causa]] == "All causes",
               !is.na(.data[[col_tasa]])) %>%
        mutate(tasa_num = as.numeric(.data[[col_tasa]])) %>%
        arrange(desc(tasa_num)) %>%
        mutate(rank = row_number())
      rank_wv <- ranking_df %>%
        filter(.data[[col_estado]] == "West Virginia") %>%
        pull(rank)
      bs4ValueBox(
        value    = if (length(rank_wv) > 0) paste0("#", rank_wv[1]) else "N/D",
        subtitle = paste0("Ranking nacional (de ", nrow(ranking_df), " estados)"),
        icon = icon("trophy"), color = "navy"
      )
    })

    output$vb_causa1_wv <- renderValueBox({
      top_causa <- datos_estados %>%
        filter(.data[[col_estado]] == "West Virginia",
               .data[[col_year]]   == 2017,
               .data[[col_causa]]  != "All causes",
               !is.na(.data[[col_muertes]])) %>%
        mutate(m = as.numeric(.data[[col_muertes]])) %>%
        slice_max(m, n = 1, with_ties = FALSE) %>%
        pull(all_of(col_causa))
      bs4ValueBox(
        value    = if (length(top_causa) > 0) top_causa[1] else "N/D",
        subtitle = "Causa #1 en WV por muertes (2017)",
        icon = icon("star"), color = "navy"
      )
    })

    # ── plot_wv_lineas ────────────────────────────────────────────────────────
    output$plot_wv_lineas <- renderPlotly({
      datos_wv <- datos_estados %>%
        filter(state == "West Virginia",
               cause_name != "All causes",
               !is.na(age_adjusted_death_rate)) %>%
        mutate(
          tasa_ajustada = as.numeric(age_adjusted_death_rate),
          anio          = as.integer(year),
          destacar      = ifelse(cause_name == "Unintentional injuries",
                                 "Unintentional injuries", "Otras causas")
        ) %>%
        filter(!is.na(tasa_ajustada))

      if (nrow(datos_wv) == 0) {
        return(plotly_empty() %>% plotly::layout(title = list(text = "Sin datos disponibles")))
      }

      otras  <- datos_wv %>% filter(destacar == "Otras causas")
      destac <- datos_wv %>% filter(destacar == "Unintentional injuries")

      p <- plot_ly()

      # Otras causas — todas en azul claro, una sola entrada en leyenda
      causas_otras <- unique(otras$cause_name)
      for (i in seq_along(causas_otras)) {
        df_c <- otras %>% filter(cause_name == causas_otras[i]) %>% arrange(anio)
        p <- p %>%
          add_lines(data = df_c, x = ~anio, y = ~tasa_ajustada,
                    name = "Otras causas",
                    legendgroup = "otras",
                    showlegend = (i == 1),
                    line = list(color = "#A8DADC", width = 1.2),
                    opacity = 0.6,
                    hovertemplate = paste0("<b>", causas_otras[i],
                                          "</b><br>A\u00f1o: %{x}<br>Tasa: %{y:.1f}<extra></extra>"))
      }

      # Unintentional injuries — destacada en azul marino
      p <- p %>%
        add_lines(data = destac %>% arrange(anio),
                  x = ~anio, y = ~tasa_ajustada,
                  name = "Unintentional injuries",
                  line = list(color = "#1A3A5C", width = 3),
                  hovertemplate = "<b>Unintentional injuries</b><br>A\u00f1o: %{x}<br>Tasa: %{y:.1f}<extra></extra>") %>%
        add_markers(data = destac %>% arrange(anio),
                    x = ~anio, y = ~tasa_ajustada,
                    marker = list(color = "#1A3A5C", size = 6),
                    showlegend = FALSE, hoverinfo = "skip")

      p %>% plotly::layout(
        title  = list(text = "West Virginia \u2014 Tendencias por causa (1999-2017)",
                      font = list(size = 13, color = "#1a3a5c")),
        xaxis  = list(title = "A\u00f1o", tickmode = "linear", dtick = 2),
        yaxis  = list(title = "Tasa ajustada (por 100,000 hab.)"),
        legend = list(orientation = "h", x = 0, y = -0.15, font = list(size = 10)),
        plot_bgcolor  = "rgba(0,0,0,0)",
        paper_bgcolor = "rgba(0,0,0,0)",
        font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
      )
    })

    # ── plot_wv_barras ────────────────────────────────────────────────────────
    output$plot_wv_barras <- renderPlotly({
      comparacion <- datos_us %>%
        filter(anio %in% c(1999, 2017), causa != "All causes", !is.na(muertes)) %>%
        select(anio, causa, muertes)

      if (nrow(comparacion) == 0) {
        return(plotly_empty() %>% plotly::layout(title = list(text = "Sin datos disponibles")))
      }

      orden <- comparacion %>%
        filter(anio == 2017) %>%
        arrange(muertes) %>%
        pull(causa)
      if (length(orden) == 0) orden <- unique(comparacion$causa)

      d1999 <- comparacion %>% filter(anio == 1999) %>%
        mutate(causa = factor(causa, levels = orden))
      d2017 <- comparacion %>% filter(anio == 2017) %>%
        mutate(causa = factor(causa, levels = orden))

      plot_ly() %>%
        add_bars(data = d1999, x = ~muertes, y = ~causa, orientation = "h",
                 name = "1999", marker = list(color = "#457B9D"),
                 hovertemplate = "<b>%{y}</b><br>1999: %{x:,}<extra></extra>") %>%
        add_bars(data = d2017, x = ~muertes, y = ~causa, orientation = "h",
                 name = "2017", marker = list(color = "#ADD8E6"),
                 hovertemplate = "<b>%{y}</b><br>2017: %{x:,}<extra></extra>") %>%
        plotly::layout(
          barmode = "group",
          title   = list(text = "Comparación del número de muertes (1999 vs 2017)",
                         font = list(size = 13, color = "#1a3a5c")),
          xaxis   = list(title = "Número de muertes"),
          yaxis   = list(title = ""),
          legend  = list(orientation = "h", x = 0.1, y = 1.08),
          plot_bgcolor  = "rgba(0,0,0,0)",
          paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
        )
    })

        # ── plot_comp_lineas ──────────────────────────────────────────────────────
    output$plot_comp_lineas <- renderPlotly({
      req(datos_estados, input$estado_comp, input$causa_comp)

      df <- datos_estados %>%
        filter(.data[[col_estado]] %in% c("West Virginia", input$estado_comp),
               .data[[col_causa]]  == input$causa_comp) %>%
        mutate(
          tasa_j  = as.numeric(.data[[col_tasa]]),
          year_j  = as.integer(.data[[col_year]]),
          state_j = as.character(.data[[col_estado]])
        ) %>%
        filter(!is.na(tasa_j))

      if (nrow(df) == 0) {
        return(plotly_empty() %>%
                 plotly::layout(title = list(text = paste0("Sin datos para ", input$causa_comp))))
      }

      estados_presentes <- unique(df$state_j)
      cols_comp <- setNames(
        c("#1A3A5C", "#85C1E9")[seq_along(
          intersect(c("West Virginia", input$estado_comp), estados_presentes))],
        intersect(c("West Virginia", input$estado_comp), estados_presentes)
      )

      p <- plot_ly()
      for (est in names(cols_comp)) {
        df_e <- df %>% filter(state_j == est) %>% arrange(year_j)
        p <- p %>%
          add_lines(data = df_e, x = ~year_j, y = ~tasa_j,
                    name = est,
                    line = list(color = cols_comp[[est]], width = 2.5),
                    hovertemplate = paste0("<b>", est, "</b><br>Año: %{x}<br>Tasa: %{y:.1f}<extra></extra>")) %>%
          add_markers(data = df_e, x = ~year_j, y = ~tasa_j,
                      marker = list(color = cols_comp[[est]], size = 5),
                      showlegend = FALSE, hoverinfo = "skip")
      }

      p %>% plotly::layout(
        title  = list(text = paste0(input$causa_comp,
                                    " \u2014 West Virginia vs ", input$estado_comp),
                      font = list(size = 12, color = "#1a3a5c")),
        xaxis  = list(title = "Año", tickmode = "linear", dtick = 2),
        yaxis  = list(title = "Tasa ajustada (por 100,000 hab.)"),
        legend = list(orientation = "h", x = 0, y = -0.15),
        plot_bgcolor  = "rgba(0,0,0,0)",
        paper_bgcolor = "rgba(0,0,0,0)",
        font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
      )
    })

    # ── ARIMA reactivo ────────────────────────────────────────────────────────
    arima_data <- reactive({
      req(datos_estados)
      library(forecast)
      library(tseries)

      # Serie 1: All causes WV
      serie_total <- datos_estados %>%
        filter(state == "West Virginia", cause_name == "All causes",
               !is.na(age_adjusted_death_rate)) %>%
        arrange(year) %>%
        pull(age_adjusted_death_rate) %>%
        as.numeric()
      ts_total <- ts(serie_total, start = 1999, frequency = 1)

      # Serie 2: Unintentional injuries WV
      serie_acc <- datos_estados %>%
        filter(state == "West Virginia", cause_name == "Unintentional injuries",
               !is.na(age_adjusted_death_rate)) %>%
        arrange(year) %>%
        pull(age_adjusted_death_rate) %>%
        as.numeric()
      ts_acc <- ts(serie_acc, start = 1999, frequency = 1)

      modelo_total <- auto.arima(ts_total, seasonal = FALSE, stepwise = TRUE, ic = "aic")
      modelo_acc   <- auto.arima(ts_acc,   seasonal = FALSE, stepwise = TRUE, ic = "aic")

      fc_total <- forecast(modelo_total, h = 5, level = c(80, 95))
      fc_acc   <- forecast(modelo_acc,   h = 5, level = c(80, 95))

      lb_total <- Box.test(residuals(modelo_total), lag = 4, type = "Ljung-Box")

      list(
        ts_total    = ts_total,   ts_acc    = ts_acc,
        fc_total    = fc_total,   fc_acc    = fc_acc,
        mod_total   = modelo_total, mod_acc = modelo_acc,
        lb_pval     = round(lb_total$p.value, 4),
        serie_total = serie_total, serie_acc = serie_acc
      )
    })

    # Value boxes ARIMA
    output$vb_arima_total <- renderValueBox({
      d <- arima_data()
      bs4ValueBox(
        value    = as.character(d$mod_total),
        subtitle = "Modelo seleccionado — All causes",
        icon = icon("chart-line"), color = "navy"
      )
    })

    output$vb_arima_acc <- renderValueBox({
      d <- arima_data()
      bs4ValueBox(
        value    = as.character(d$mod_acc),
        subtitle = "Modelo seleccionado — Unintentional injuries",
        icon = icon("chart-line"), color = "navy"
      )
    })

    output$vb_ljung <- renderValueBox({
      d <- arima_data()
      bs4ValueBox(
        value    = d$lb_pval,
        subtitle = "Ljung-Box p-value (All causes) — >0.05: residuos independientes",
        icon = icon("check-circle"), color = if (d$lb_pval > 0.05) "navy" else "warning"
      )
    })

    # Plot ARIMA Total
    output$plot_arima_total <- renderPlotly({
      d      <- arima_data()
      fc     <- d$fc_total
      anios_hist <- 1999:2017
      anios_fc   <- 2018:2022

      plot_ly() %>%
        # Historico
        add_lines(x = anios_hist, y = d$serie_total,
                  name = "Historico (1999-2017)",
                  line = list(color = "#1A3A5C", width = 2.5),
                  hovertemplate = "Año: %{x}<br>Tasa: %{y:.1f}<extra></extra>") %>%
        add_markers(x = anios_hist, y = d$serie_total,
                    marker = list(color = "#1A3A5C", size = 5),
                    showlegend = FALSE, hoverinfo = "skip") %>%
        # IC 95%
        add_ribbons(x = anios_fc,
                    ymin = as.numeric(fc$lower[,2]),
                    ymax = as.numeric(fc$upper[,2]),
                    fillcolor = "rgba(133,193,233,0.25)",
                    line = list(color = "transparent"),
                    name = "IC 95%") %>%
        # IC 80%
        add_ribbons(x = anios_fc,
                    ymin = as.numeric(fc$lower[,1]),
                    ymax = as.numeric(fc$upper[,1]),
                    fillcolor = "rgba(133,193,233,0.45)",
                    line = list(color = "transparent"),
                    name = "IC 80%") %>%
        # Proyeccion
        add_lines(x = anios_fc, y = as.numeric(fc$mean),
                  name = "Proyeccion (2018-2022)",
                  line = list(color = "#457B9D", width = 2.5, dash = "dash"),
                  hovertemplate = "Año: %{x}<br>Proyeccion: %{y:.1f}<extra></extra>") %>%
        add_markers(x = anios_fc, y = as.numeric(fc$mean),
                    marker = list(color = "#457B9D", size = 6, symbol = "triangle-up"),
                    showlegend = FALSE, hoverinfo = "skip") %>%
        plotly::layout(
          title  = list(text = "Proyeccion ARIMA — Tasa ajustada total WV (2018-2022)",
                        font = list(size = 12, color = "#1a3a5c")),
          xaxis  = list(title = "Año", tickmode = "linear", dtick = 2),
          yaxis  = list(title = "Tasa por 100,000 hab."),
          shapes = list(list(type = "line", x0 = 2017.5, x1 = 2017.5,
                             y0 = 0, y1 = 1, yref = "paper",
                             line = list(color = "gray", dash = "dot", width = 1.5))),
          legend = list(orientation = "h", x = 0, y = -0.15),
          plot_bgcolor  = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
        )
    })

    # Plot ARIMA Unintentional injuries
    output$plot_arima_acc <- renderPlotly({
      d      <- arima_data()
      fc     <- d$fc_acc
      anios_hist <- 1999:2017
      anios_fc   <- 2018:2022

      plot_ly() %>%
        add_lines(x = anios_hist, y = d$serie_acc,
                  name = "Historico (1999-2017)",
                  line = list(color = "#1A3A5C", width = 2.5),
                  hovertemplate = "Año: %{x}<br>Tasa: %{y:.1f}<extra></extra>") %>%
        add_markers(x = anios_hist, y = d$serie_acc,
                    marker = list(color = "#1A3A5C", size = 5),
                    showlegend = FALSE, hoverinfo = "skip") %>%
        add_ribbons(x = anios_fc,
                    ymin = as.numeric(fc$lower[,2]),
                    ymax = as.numeric(fc$upper[,2]),
                    fillcolor = "rgba(133,193,233,0.25)",
                    line = list(color = "transparent"),
                    name = "IC 95%") %>%
        add_ribbons(x = anios_fc,
                    ymin = as.numeric(fc$lower[,1]),
                    ymax = as.numeric(fc$upper[,1]),
                    fillcolor = "rgba(133,193,233,0.45)",
                    line = list(color = "transparent"),
                    name = "IC 80%") %>%
        add_lines(x = anios_fc, y = as.numeric(fc$mean),
                  name = "Proyeccion (2018-2022)",
                  line = list(color = "#457B9D", width = 2.5, dash = "dash"),
                  hovertemplate = "Año: %{x}<br>Proyeccion: %{y:.1f}<extra></extra>") %>%
        add_markers(x = anios_fc, y = as.numeric(fc$mean),
                    marker = list(color = "#457B9D", size = 6, symbol = "triangle-up"),
                    showlegend = FALSE, hoverinfo = "skip") %>%
        plotly::layout(
          title  = list(text = "Proyeccion ARIMA — Unintentional Injuries WV (2018-2022)",
                        font = list(size = 12, color = "#1a3a5c")),
          xaxis  = list(title = "Año", tickmode = "linear", dtick = 2),
          yaxis  = list(title = "Tasa por 100,000 hab."),
          shapes = list(list(type = "line", x0 = 2017.5, x1 = 2017.5,
                             y0 = 0, y1 = 1, yref = "paper",
                             line = list(color = "gray", dash = "dot", width = 1.5))),
          legend = list(orientation = "h", x = 0, y = -0.15),
          plot_bgcolor  = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
        )
    })

  })
}

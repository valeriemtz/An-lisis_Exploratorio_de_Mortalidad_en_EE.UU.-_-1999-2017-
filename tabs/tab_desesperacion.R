# tab_desesperacion.R — plot_ly() nativo (ggplotly)

tab_desesperacionUI <- function(id) {
  ns <- NS(id)

  NAVY <- "#1A3A5C"

  tagList(
    tags$style(HTML(paste0("
      .desp-nota { border-left:4px solid ", NAVY, " !important; padding-left:8px; color:#333; }
    "))),

    tags$div(class = "section-header",
      style = paste0("background:", NAVY, "; color:#fff; padding:8px 14px;
                      border-radius:6px; margin-bottom:10px; font-weight:700;"),
      'Análisis Específico: La Crisis de las "Muertes por Desesperación"'
    ),

    bs4Card(
      width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
      headerBorder = FALSE,
      title = tags$span(style = "color:#fff;",
                        icon("triangle-exclamation"), " Contexto: Deaths of Despair"),
      tags$div(class = "texto-academico",
        "El término ", tags$strong("'muertes por desesperación' (deaths of despair)"),
        ", acuñado por Case y Deaton, agrupa suicidios, sobredosis y alcoholismo
         como causas ligadas al deterioro social y económico. En este análisis,
         ", tags$strong("Suicide"), " y ",
        tags$strong("Unintentional injuries"),
        " muestran una tendencia ascendente sostenida durante 1999-2017,
         con una aceleración visible desde 2014."
      )
    ),

    fluidRow(
      column(7,
        bs4Card(
          width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          title = tags$span(style = "color:#fff;", icon("chart-line"),
                  " Tendencias: Suicide vs Unintentional Injuries"),
          plotlyOutput(ns("plot_tendencias"), height = "360px")
        )
      ),
      column(5,
        bs4Card(
          width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          title = tags$span(style = "color:#fff;",
                            icon("chart-bar"), " Comparación 1999 vs 2017"),
          plotlyOutput(ns("plot_comp"), height = "360px")
        )
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
      headerBorder = FALSE,
      title = tags$span(style = "color:#fff;", icon("chart-area"),
              " Magnitud Relativa: Deaths of Despair vs Enfermedades Crónicas Líderes"),
      plotlyOutput(ns("plot_area"), height = "380px"),
      tags$div(class = "desp-nota",
        icon("lightbulb"), tags$strong(" Interpretación: "),
        "Aunque Heart disease y Cancer dominan en términos absolutos, Suicide y
         Unintentional injuries son las únicas causas con tendencia ",
        tags$strong("consistentemente ascendente"), " en el período (1999-2017)."
      )
    )
  )
}

tab_desesperacionServer <- function(id, datos_us, datos_estados) {
  moduleServer(id, function(input, output, session) {

    datos_nacional_mod <- reactive({
      datos_us %>%
        filter(causa != "All causes") %>%
        group_by(anio, causa) %>%
        summarise(
          muertes       = sum(muertes,       na.rm = TRUE),
          tasa_ajustada = mean(tasa_ajustada, na.rm = TRUE),
          .groups = "drop"
        )
    })

    # ── plot_tendencias ───────────────────────────────────────────────────────
    output$plot_tendencias <- renderPlotly({
      causas_desp <- c("Suicide", "Unintentional injuries")
      df <- datos_nacional_mod() %>%
        filter(causa %in% causas_desp) %>%
        mutate(anio = as.integer(anio))

      if (nrow(df) == 0) {
        return(plotly_empty() %>%
                 plotly::layout(title = list(text = "Sin datos para Suicide / Unintentional injuries")))
      }

      cols_desp <- c("Suicide" = "#1A3A5C", "Unintentional injuries" = "#4A7C8E")

      p <- plot_ly()
      for (cau in causas_desp) {
        df_c <- df %>% filter(causa == cau)
        # Línea de tendencia
        if (nrow(df_c) > 1) {
          fit    <- lm(muertes ~ anio, data = df_c)
          df_c$fit <- predict(fit)
          p <- p %>% add_lines(
            data = df_c, x = ~anio, y = ~fit,
            line = list(color = cols_desp[[cau]], dash = "dash", width = 1),
            name = paste0(cau, " (tendencia)"), showlegend = FALSE,
            hoverinfo = "skip"
          )
        }
        p <- p %>%
          add_lines(
            data = df_c, x = ~anio, y = ~muertes,
            name = cau,
            line = list(color = cols_desp[[cau]], width = 2.5),
            hovertemplate = paste0("<b>", cau, "</b><br>Año: %{x}<br>Muertes: %{y:,}<extra></extra>")
          ) %>%
          add_markers(
            data = df_c, x = ~anio, y = ~muertes,
            marker = list(color = cols_desp[[cau]], size = 6),
            showlegend = FALSE, hoverinfo = "skip"
          )
      }

      p %>% add_segments(
        x = 2014, xend = 2014, y = 0, yend = Inf,
        line = list(color = "gray", dash = "dot", width = 1),
        name = "2014", showlegend = FALSE, hoverinfo = "skip"
      ) %>%
        plotly::layout(
          title  = list(text = "Evolución de las 'Muertes por Desesperación' (1999-2017)",
                        font = list(size = 13, color = "#1a3a5c")),
          xaxis  = list(title = "Año", tickmode = "linear", dtick = 1),
          yaxis  = list(title = "Número de muertes"),
          legend = list(orientation = "h", x = 0, y = -0.2),
          plot_bgcolor  = "rgba(0,0,0,0)",
          paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
        )
    })

    # ── plot_comp ─────────────────────────────────────────────────────────────
    output$plot_comp <- renderPlotly({
      df <- datos_nacional_mod() %>%
        filter(causa %in% c("Suicide", "Unintentional injuries"),
               anio %in% c(1999, 2017),
               !is.na(muertes))

      if (nrow(df) == 0) {
        return(plotly_empty() %>%
                 plotly::layout(title = list(text = "Sin datos para 1999 o 2017")))
      }

      d1999 <- df %>% filter(anio == 1999)
      d2017 <- df %>% filter(anio == 2017)

      plot_ly() %>%
        add_bars(data = d1999, x = ~causa, y = ~muertes,
                 name = "1999", marker = list(color = "#1A3A5C"),
                 hovertemplate = "<b>%{x}</b><br>1999: %{y:,}<extra></extra>") %>%
        add_bars(data = d2017, x = ~causa, y = ~muertes,
                 name = "2017", marker = list(color = "#2E86C1"),
                 hovertemplate = "<b>%{x}</b><br>2017: %{y:,}<extra></extra>") %>%
        plotly::layout(
          barmode = "group",
          xaxis   = list(title = ""),
          yaxis   = list(title = "Número de muertes"),
          legend  = list(orientation = "h", x = 0.1, y = 1.1),
          plot_bgcolor  = "rgba(0,0,0,0)",
          paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
        )
    })

    # ── plot_area ─────────────────────────────────────────────────────────────
    output$plot_area <- renderPlotly({
      causas_area <- c("Heart disease", "Cancer",
                       "Suicide", "Unintentional injuries")
      df <- datos_nacional_mod() %>%
        filter(causa %in% causas_area, !is.na(muertes)) %>%
        mutate(anio = as.integer(anio))

      if (nrow(df) == 0) {
        return(plotly_empty() %>%
                 plotly::layout(title = list(text = "Sin datos disponibles")))
      }

      col_area <- c(
        "Heart disease"          = "#1A3A5C",  # navy
        "Cancer"                 = "#2E86C1",  # azul medio
        "Suicide"                = "#8B4513",  # terracota oscuro
        "Unintentional injuries" = "#4A7C8E"   # gris azulado
      )

      p <- plot_ly()
      for (cau in causas_area) {
        df_c <- df %>% filter(causa == cau) %>% arrange(anio)
        p <- p %>% add_trace(
          data = df_c, x = ~anio, y = ~muertes,
          type = "scatter", mode = "lines",
          fill = "tozeroy", fillcolor = paste0(col_area[[cau]], "20"),
          line = list(color = col_area[[cau]], width = 2),
          name = cau,
          hovertemplate = paste0("<b>", cau, "</b><br>Año: %{x}<br>Muertes: %{y:,}<extra></extra>")
        )
      }

      p %>% plotly::layout(
        xaxis  = list(title = "Año", tickmode = "linear", dtick = 2),
        yaxis  = list(title = "Número de muertes"),
        legend = list(orientation = "h", x = 0, y = -0.2,
                      font = list(size = 9)),
        plot_bgcolor  = "rgba(0,0,0,0)",
        paper_bgcolor = "rgba(0,0,0,0)",
        font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
      )
    })
  })
}

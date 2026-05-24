# tab_ranking.R 

tab_rankingUI <- function(id) {
  ns <- NS(id)
  NAVY <- "#1A3A5C"
  tagList(
    tags$style(HTML(paste0("
      .rank-ctrl .irs-bar, .rank-ctrl .irs-bar-edge { background:", NAVY, " !important; border-color:", NAVY, " !important; }
      .rank-ctrl .irs-handle                         { border-color:", NAVY, " !important; }
      .rank-ctrl .irs-single                         { background:", NAVY, " !important; }
      .rank-ctrl label, .rank-ctrl .control-label    { color:", NAVY, " !important; font-weight:600; }
      .rank-nota { border-left:4px solid ", NAVY, " !important; padding-left:8px; color:#333; }
    "))),

    tags$div(class = "section-header",
      style = paste0("background:", NAVY, "; color:#fff; padding:8px 14px;
                      border-radius:6px; margin-bottom:10px; font-weight:700;"),
      "Análisis de Ranking: Cambios en la Posición de las Causas"
    ),

    fluidRow(
      column(4,
        bs4Card(
          width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          title = tags$span(style = "color:#fff;", icon("sliders"), " Año Seleccionado"),
          tags$div(class = "rank-ctrl",
            sliderInput(ns("ano_rank"), label = "Año:",
              min = 1999, max = 2017, value = 2017, step = 1, sep = "",
              animate = animationOptions(interval = 800, loop = FALSE)
            )
          ),
          tags$div(class = "rank-nota", style = "margin-top:8px;",
            icon("circle-info"),
            " Presiona ▶ para animar la evolución del ranking."
          )
        )
      ),
      column(8,
        bs4Card(
          width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          title = tags$span(style = "color:#fff;", icon("list-ol"), " Ranking de causas por año"),
          plotlyOutput(ns("plot_ranking"), height = "380px")
        )
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
      headerBorder = FALSE,
      title = tags$span(style = "color:#fff;", icon("table"),
              " Tabla de Cambios en el Ranking (1999 vs 2017)"),
      DTOutput(ns("tabla_ranking")),
      tags$div(class = "rank-nota",
        icon("chart-bar"), tags$strong(" Nota analítica: "),
        "Heart disease y Cancer se mantuvieron #1 y #2 durante todo el período.
         Unintentional injuries subió del puesto 5 al 3 (+73.7%) y Alzheimer
         del 8 al 6 (+172.6%), mientras Stroke bajó del 3 al 5 (-12.5%)."
      )
    )
  )
}

tab_rankingServer <- function(id, datos_us, datos_estados) {
  moduleServer(id, function(input, output, session) {

    # FIX: construir datos_nacional dentro del módulo
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

    ranking_anual <- reactive({
      datos_nacional_mod() %>%   # FIX
        group_by(anio) %>%
        mutate(rank = rank(-muertes, ties.method = "min")) %>%
        ungroup()
    })

    output$plot_ranking <- renderPlotly({
      req(ranking_anual(), input$ano_rank)

      df <- ranking_anual() %>%
        filter(anio == input$ano_rank) %>%
        arrange(muertes) %>%
        mutate(
          causa     = factor(causa, levels = causa),
          color_pos = "#2471A3"
        )

      if (nrow(df) == 0) {
        return(plotly_empty() %>%
                 plotly::layout(title = list(text = "Sin datos para el año seleccionado")))
      }

      # FIX v3: plot_ly nativo (ggplotly rompe con ggplot2 4.0.0)
      plot_ly(df,
              x = ~muertes, y = ~causa,
              type = "bar", orientation = "h",
              marker = list(color = ~color_pos),
              hovertemplate = ~paste0("<b>#", rank, " — ", causa,
                                      "</b><br>Muertes: ",
                                      format(muertes, big.mark = ","),
                                      "<extra></extra>")
      ) %>%
        plotly::layout(
          title  = list(text = paste("Ranking de mortalidad —", input$ano_rank),
                        font = list(color = "#1a3a5c", size = 13)),
          xaxis  = list(title = "Número de muertes"),
          yaxis  = list(title = ""),
          plot_bgcolor  = "rgba(0,0,0,0)",
          paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11),
          showlegend = FALSE
        )
    })

    output$tabla_ranking <- renderDT({
      req(ranking_anual())

      rank_1999 <- ranking_anual() %>%
        filter(anio == 1999) %>%
        select(causa, rank_1999 = rank, muertes_1999 = muertes)

      rank_2017 <- ranking_anual() %>%
        filter(anio == 2017) %>%
        select(causa, rank_2017 = rank, muertes_2017 = muertes)

      cambios_ranking <- inner_join(rank_1999, rank_2017, by = "causa") %>%
        mutate(
          cambio_rank = rank_2017 - rank_1999,
          pct_cambio  = round(
            (muertes_2017 - muertes_1999) / muertes_1999 * 100, 1),
          cambio_formateado = case_when(
            cambio_rank < 0 ~ paste0("\u25b2 ", abs(cambio_rank)),
            cambio_rank > 0 ~ paste0("\u25bc ", cambio_rank),
            TRUE             ~ "="
          ),
          dir_cambio = case_when(
            cambio_rank < 0 ~ "up",
            cambio_rank > 0 ~ "down",
            TRUE             ~ "same"
          ),
          dir_pct = case_when(
            pct_cambio > 0 ~ "up",
            pct_cambio < 0 ~ "down",
            TRUE            ~ "same"
          )
        ) %>%
        arrange(desc(abs(cambio_rank)), rank_1999)

      # FIX: styleEqual falla cuando vals_cambio/vals_pct tienen valores duplicados
      # (ej. "=" aparece 5 veces). Solución: embeber HTML con colores inline.
      col_cambio <- ifelse(cambios_ranking$dir_cambio == "up",   "#1e8449",
                    ifelse(cambios_ranking$dir_cambio == "down", "#e74c3c",
                                                                  "#1A3A5C"))
      col_pct    <- ifelse(cambios_ranking$dir_pct == "up",   "#e74c3c",
                    ifelse(cambios_ranking$dir_pct == "down", "#1e8449",
                                                               "#1A3A5C"))
      bold_cambio <- cambios_ranking$cambio_rank != 0
      bold_pct    <- abs(cambios_ranking$pct_cambio) > 10

      tabla_dt <- cambios_ranking %>%
        mutate(
          Cambio_html = paste0(
            "<span style='color:", col_cambio,
            "; font-weight:", ifelse(bold_cambio, "bold", "normal"), "'>",
            cambio_formateado, "</span>"
          ),
          Pct_html = paste0(
            "<span style='color:", col_pct,
            "; font-weight:", ifelse(bold_pct, "bold", "normal"), "'>",
            pct_cambio, "%</span>"
          )
        ) %>%
        select(
          "Causa"         = causa,
          "Rank 1999"     = rank_1999,
          "Rank 2017"     = rank_2017,
          "Cambio"        = Cambio_html,
          "Variacion_pct" = Pct_html
        )

      datatable(tabla_dt,
        options  = list(dom = 't', pageLength = 15,
                        scrollX = TRUE, ordering = FALSE),
        rownames = FALSE,
        class    = "stripe hover compact",
        escape   = FALSE,
        colnames = c("Causa", "Rank 1999", "Rank 2017",
                     "Cambio", "Variación %")
      ) %>%
        formatStyle("Cambio",       textAlign = "center") %>%
        formatStyle("Variacion_pct", textAlign = "right") %>%
        formatStyle("Rank 2017",    fontWeight = "bold", color = "#1a3a5c")
    })
  })
}

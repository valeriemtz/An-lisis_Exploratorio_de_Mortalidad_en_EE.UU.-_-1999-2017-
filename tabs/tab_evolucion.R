# tab_evolucion.R — 

tab_evolucionUI <- function(id) {
  ns <- NS(id)
  NAVY <- "#1A3A5C"
  tagList(
    tags$style(HTML(paste0("
      .evol-ctrl label, .evol-ctrl .control-label { color:", NAVY, " !important; font-weight:600; }
      .evol-ctrl .irs-bar, .evol-ctrl .irs-bar-edge { background:", NAVY, " !important; border-color:", NAVY, " !important; }
      .evol-ctrl .irs-single { background:", NAVY, " !important; }
      .evol-nota { border-left:4px solid ", NAVY, " !important; padding-left:8px; color:#333; }
    "))),

    tags$div(class = "section-header",
      "Evolución de la Tasa Ajustada de Mortalidad Anual"
    ),

    # ── Fila 1: Evolución tasa ajustada — ancho completo ────────────────────────
    fluidRow(
      column(12,
        bs4Card(
          width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          title = tags$span(style = "color:#fff;", icon("chart-line"),
                  " Evolución de la tasa ajustada de mortalidad anual"),
          plotlyOutput(ns("plot_allcauses"), height = "280px")
        )
      )
    ),

    # ── Fila 2: Controles | Tendencias + Cascada ────────────────────────────────
    fluidRow(
      column(3,
        bs4Card(
          width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          title = tags$span(style = "color:#fff;", icon("sliders"), " Controles"),
          tags$div(class = "evol-ctrl",
            tags$label("Seleccionar causas:",
                       style = paste0("font-weight:600; font-size:0.88rem; color:", NAVY, ";")),
            checkboxGroupInput(
              ns("causas_sel"), label = NULL,
              choices  = NULL,
              selected = c("Heart disease", "Cancer", "Stroke")
            ),
            tags$hr(style = paste0("border-color:", NAVY, ";")),
            radioButtons(
              ns("metrica"), label = "Métrica:",
              choices  = c("Tasa ajustada"     = "tasa_ajustada",
                           "Muertes absolutas" = "muertes"),
              selected = "tasa_ajustada"
            ),
            tags$hr(style = paste0("border-color:", NAVY, ";")),
            fluidRow(
              column(6, actionButton(ns("sel_todas"),   "Todas",
                class = "btn btn-sm", width = "100%",
                style = paste0("background:", NAVY, "; color:#fff; border-color:", NAVY, ";"))),
              column(6, actionButton(ns("sel_ninguna"), "Ninguna",
                class = "btn btn-sm btn-outline-secondary", width = "100%"))
            ),
            tags$hr(style = paste0("border-color:", NAVY, ";")),
            tags$label("Rango cascada:",
                       style = paste0("font-weight:600; font-size:0.88rem; color:", NAVY, ";")),
            fluidRow(
              column(6, selectInput(ns("anio_ini"), "Desde:", choices = NULL)),
              column(6, selectInput(ns("anio_fin"), "Hasta:", choices = NULL))
            )
          )
        )
      ),

      column(9,
        bs4Card(
          width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          title = tags$span(style = "color:#fff;", icon("chart-line"),
                            " Tendencias temporales por causa"),
          plotlyOutput(ns("plot_lineas"), height = "360px")
        ),
        bs4Card(
          width = 12, collapsible = FALSE, status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          title = tags$span(style = "color:#fff;", icon("chart-bar"),
                  textOutput(ns("titulo_cascada"), inline = TRUE)),
          plotlyOutput(ns("plot_cascada_causas"), height = "480px"),
          tags$div(class = "evol-nota",
            icon("lightbulb"), tags$strong(" Interpretación:"),
            " Cada barra muestra el cambio en muertes absolutas de la causa
              entre 1999 y 2017. Barras azul oscuro indican un aumento;
              azul claro una reducci\u00f3n."
          )
        )
      )
    )
  )
}

tab_evolucionServer <- function(id, datos_us, datos_estados) {
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

    observe({
      causas_disp <- sort(unique(datos_nacional_mod()$causa))
      updateCheckboxGroupInput(session, "causas_sel",
        choices  = causas_disp,
        selected = intersect(c("Heart disease", "Cancer", "Stroke"), causas_disp)
      )
    })

    observeEvent(input$sel_todas, {
      updateCheckboxGroupInput(session, "causas_sel",
        selected = sort(unique(datos_nacional_mod()$causa)))
    })
    observeEvent(input$sel_ninguna, {
      updateCheckboxGroupInput(session, "causas_sel", selected = character(0))
    })

    # ── Poblar selectInputs de año para la cascada ───────────────────────────────
    observe({
      anios_disp <- sort(unique(datos_us$anio))
      updateSelectInput(session, "anio_ini",
        choices  = anios_disp,
        selected = min(anios_disp)
      )
      updateSelectInput(session, "anio_fin",
        choices  = anios_disp,
        selected = max(anios_disp)
      )
    })

    output$titulo_cascada <- renderText({
      req(input$anio_ini, input$anio_fin)
      paste0("Cascada de muertes absolutas ", input$anio_ini,
             " → ", input$anio_fin, " (por causa)")
    })

    # ── plot_allcauses ────────────────────────────────────────────────────────
    output$plot_allcauses <- renderPlotly({
      df <- datos_us %>%
        filter(causa == "All causes") %>%
        arrange(anio)

      if (nrow(df) == 0) {
        return(plotly_empty() %>%
                 plotly::layout(title = list(text = "Sin datos para 'All causes'")))
      }

      fit    <- lm(tasa_ajustada ~ anio, data = df)
      df$fit <- predict(fit, df)

      plot_ly(df, x = ~anio) %>%
        add_lines(y = ~fit, line = list(color = "#4A7C8E", dash = "dash", width = 1.5),
                  name = "Tendencia", hoverinfo = "skip") %>%
        add_lines(y = ~tasa_ajustada, line = list(color = "#1A3A5C", width = 2),
                  name = "Tasa ajustada",
                  hovertemplate = "Año: %{x}<br>Tasa: %{y:.1f}<extra></extra>") %>%
        add_markers(y = ~tasa_ajustada, marker = list(color = "#2471A3", size = 6),
                    name = "Punto", showlegend = FALSE,
                    hovertemplate = "Año: %{x}<br>Tasa: %{y:.1f}<extra></extra>") %>%
        plotly::layout(
          xaxis = list(title = "Año", tickmode = "linear", dtick = 2),
          yaxis = list(title = "Tasa ajustada (por 100,000 hab.)"),
          plot_bgcolor  = "rgba(0,0,0,0)",
          paper_bgcolor = "rgba(0,0,0,0)",
          legend = list(orientation = "h", x = 0, y = 1.1),
          font   = list(family = "Segoe UI, Arial, sans-serif", size = 11)
        )
    })

    # ── plot_lineas ───────────────────────────────────────────────────────────
    datos_filtrados <- reactive({
      req(length(input$causas_sel) > 0, input$metrica)
      datos_nacional_mod() %>%
        filter(causa %in% input$causas_sel) %>%
        select(anio, causa, valor = all_of(input$metrica)) %>%
        filter(!is.na(valor))
    })

    output$plot_lineas <- renderPlotly({
      df <- datos_filtrados()
      req(nrow(df) > 0)

      etiqueta_y <- if (input$metrica == "tasa_ajustada")
        "Tasa por 100,000 hab." else "Muertes absolutas"

      causas_plot <- sort(unique(df$causa))
      cols_base   <- c(
        "#1A3A5C",  # navy
        "#2E86C1",  # azul medio
        "#1A7A5E",  # verde pizarra
        "#8B4513",  # terracota oscuro
        "#5B5EA6",  # violeta apagado
        "#B5883A",  # ocre dorado
        "#3D7A6B",  # verde grisáceo
        "#7B3F6E",  # borgoña suave
        "#4A7C8E",  # gris azulado
        "#6B6B6B"   # gris medio
      )
      pal_plot    <- setNames(cols_base[seq_len(length(causas_plot))], causas_plot)

      p <- plot_ly()
      for (cau in causas_plot) {
        df_c <- df %>% filter(causa == cau)
        p <- p %>% add_lines(
          data = df_c, x = ~anio, y = ~valor,
          name = cau,
          line = list(color = pal_plot[[cau]], width = 2),
          hovertemplate = paste0("<b>", cau, "</b><br>Año: %{x}<br>",
                                 etiqueta_y, ": %{y:,.1f}<extra></extra>")
        ) %>% add_markers(
          data = df_c, x = ~anio, y = ~valor,
          name = cau, showlegend = FALSE,
          marker = list(color = pal_plot[[cau]], size = 5),
          hovertemplate = paste0("<b>", cau, "</b><br>Año: %{x}<br>",
                                 etiqueta_y, ": %{y:,.1f}<extra></extra>")
        )
      }
      p %>% plotly::layout(
        xaxis = list(title = "Año", tickmode = "linear", dtick = 2),
        yaxis = list(title = etiqueta_y),
        legend = list(orientation = "v", font = list(size = 9)),
        plot_bgcolor  = "rgba(0,0,0,0)",
        paper_bgcolor = "rgba(0,0,0,0)",
        font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
      )
    })

    # ── plot_cascada_causas — Cascada de muertes absolutas por causa 1999→2017 ──
    output$plot_cascada_causas <- renderPlotly({
      req(input$anio_ini, input$anio_fin)

      a_ini    <- as.integer(input$anio_ini)
      a_fin    <- as.integer(input$anio_fin)
      col_ini  <- paste0("y", a_ini)
      col_fin2 <- paste0("y", a_fin)

      datos_us_fix <- datos_us %>%
        mutate(muertes = if (is.character(muertes))
                           as.numeric(gsub("\\.", "", gsub(",", ".", muertes)))
                         else muertes)

      causas_top10 <- c(
        "Heart disease", "Cancer", "Unintentional injuries",
        "CLRD", "Stroke", "Alzheimer's disease",
        "Diabetes", "Influenza and pneumonia",
        "Kidney disease", "Suicide"
      )

      df_wide <- datos_us_fix %>%
        filter(causa %in% causas_top10, anio %in% c(a_ini, a_fin)) %>%
        group_by(anio, causa) %>%
        summarise(muertes = sum(muertes, na.rm = TRUE), .groups = "drop") %>%
        tidyr::pivot_wider(names_from = anio, values_from = muertes,
                           names_prefix = "y") %>%
        mutate(delta = round(.data[[col_fin2]] - .data[[col_ini]], 0)) %>%
        arrange(delta)  # mayor caída primero → cascada baja hacia la derecha

      if (nrow(df_wide) == 0) {
        return(plotly_empty() %>%
          plotly::layout(title = list(text = "Sin datos suficientes")))
      }

      fmt_n <- function(x) formatC(round(x), format = "d", big.mark = ",")

      # ── Construcción de la cascada acumulada ─────────────────────────────────
      # Estructura: [Total 1999] | [delta causa1] ... [delta causa10] | [Total 2017]
      val_inicio <- sum(df_wide[[col_ini]],  na.rm = TRUE)
      val_fin    <- sum(df_wide[[col_fin2]], na.rm = TRUE)
      deltas     <- df_wide$delta
      n_causas   <- nrow(df_wide)

      acum     <- val_inicio + cumsum(deltas)
      labels_x <- c(paste0("Total ", a_ini), df_wide$causa, paste0("Total ", a_fin))
      m        <- length(labels_x)

      base   <- numeric(m)
      altura <- numeric(m)

      # Barra inicial: sólida desde 0
      base[1]   <- 0
      altura[1] <- val_inicio

      # Barras flotantes intermedias
      for (i in seq_len(n_causas)) {
        val_prev <- if (i == 1) val_inicio else acum[i - 1]
        d        <- deltas[i]
        if (d >= 0) {
          base[i + 1]   <- val_prev
          altura[i + 1] <- d
        } else {
          base[i + 1]   <- val_prev + d
          altura[i + 1] <- abs(d)
        }
      }

      # Barra final: sólida desde 0
      base[m]   <- 0
      altura[m] <- val_fin

      # ── Colores ──────────────────────────────────────────────────────────────
      col_total <- "#1A3A5C"  # navy        — Total 1999
      col_aum   <- "#2E86C1"  # azul medio  — delta positivo (aumento)
      col_dis   <- "#4A7C8E"  # gris azulado — delta negativo (disminución)
      col_fin   <- "#154360"  # azul oscuro — Total 2017

      bar_colors    <- character(m)
      bar_colors[1] <- col_total
      bar_colors[m] <- col_fin
      for (i in seq_len(n_causas)) {
        bar_colors[i + 1] <- if (deltas[i] >= 0) col_aum else col_dis
      }

      # ── Etiquetas sobre las barras ────────────────────────────────────────────
      etiq    <- character(m)
      etiq[1] <- fmt_n(val_inicio)
      etiq[m] <- fmt_n(val_fin)
      for (i in seq_len(n_causas)) {
        sgn       <- if (deltas[i] >= 0) "+" else ""
        etiq[i+1] <- paste0(sgn, fmt_n(deltas[i]))
      }

      # ── Hover ─────────────────────────────────────────────────────────────────
      hover    <- character(m)
      hover[1] <- paste0("<b>Total ", a_ini, "</b><br>Suma 10 causas: ", fmt_n(val_inicio))
      hover[m] <- paste0("<b>Total ", a_fin, "</b><br>Suma 10 causas: ", fmt_n(val_fin))
      for (i in seq_len(n_causas)) {
        sgn        <- if (deltas[i] >= 0) "+" else ""
        hover[i+1] <- paste0(
          "<b>", df_wide$causa[i], "</b><br>",
          fmt_n(df_wide[[col_ini]][i]), " \u2192 ", fmt_n(df_wide[[col_fin2]][i]), "<br>",
          "Cambio: ", sgn, fmt_n(deltas[i])
        )
      }

      # ── Rango eje Y ajustado al contenido ────────────────────────────────────
      todos_vals <- c(val_inicio, acum, val_fin)
      y_min <- floor(min(todos_vals) * 0.97)
      y_max <- ceiling(max(todos_vals) * 1.05)

      # ── Conectores entre barras (líneas de unión) ─────────────────────────────
      niveles_union <- c(val_inicio, acum)
      shapes_list <- lapply(seq_len(n_causas), function(i) {
        list(
          type    = "line",
          x0      = i - 0.45,   # borde derecho de la barra i (0-index en plotly = i)
          x1      = i + 0.45,   # borde izquierdo de la barra i+1
          y0      = niveles_union[i],
          y1      = niveles_union[i],
          xref    = "x", yref = "y",
          line    = list(color = "rgba(100,100,100,0.45)", width = 1, dash = "dot")
        )
      })

      plot_ly() %>%
        # Barras base invisibles (flotantes)
        add_bars(
          x = labels_x, y = base,
          showlegend = FALSE,
          marker     = list(color = "rgba(0,0,0,0)", line = list(width = 0)),
          hoverinfo  = "skip"
        ) %>%
        # Barras visibles
        add_bars(
          x            = labels_x,
          y            = altura,
          marker       = list(color = bar_colors,
                              line  = list(color = "white", width = 1)),
          text         = etiq,
          textposition = "outside",
          textfont     = list(size = 10, color = "#1a3a5c"),
          hovertext    = hover,
          hoverinfo    = "text",
          showlegend   = FALSE
        ) %>%
        # Leyenda manual
        add_bars(x = NA_character_, y = NA_real_, name = "Increase",
                 marker = list(color = col_aum), showlegend = TRUE) %>%
        add_bars(x = NA_character_, y = NA_real_, name = "Decrease",
                 marker = list(color = col_dis), showlegend = TRUE) %>%
        add_bars(x = NA_character_, y = NA_real_, name = "Total",
                 marker = list(color = col_fin), showlegend = TRUE) %>%
        plotly::layout(
          barmode = "stack",
          shapes  = shapes_list,
          title   = list(
            text = paste0("Cascada de muertes por causa \u2014 ", a_ini, " vs ", a_fin),
            font = list(size = 13, color = "#1a3a5c")
          ),
          xaxis = list(
            title     = "",
            tickangle = -35,
            tickfont  = list(size = 10),
            showgrid  = FALSE,
            zeroline  = FALSE
          ),
          yaxis = list(
            title      = "Muertes absolutas",
            range      = list(y_min, y_max),
            showgrid   = TRUE,
            gridcolor  = "rgba(180,180,180,0.3)",
            zeroline   = FALSE,
            tickformat = ","
          ),
          legend = list(
            orientation = "h", x = 0.3, y = 1.12,
            font = list(size = 11)
          ),
          plot_bgcolor  = "rgba(0,0,0,0)",
          paper_bgcolor = "rgba(0,0,0,0)",
          font   = list(family = "Segoe UI, Arial, sans-serif", size = 11),
          margin = list(l = 60, r = 20, t = 70, b = 120)
        )
    })
  })
}

# tab_geografico.R — datos, datos_nacional, datos_limpios - parámetros del módulo

CAUSAS_GEO_DEFAULT <- c(
  "All causes", "Alzheimer's disease", "CLRD", "Cancer", "Diabetes",
  "Heart disease", "Influenza and pneumonia", "Kidney disease",
  "Stroke", "Suicide", "Unintentional injuries"
)


# ── Paleta navy centralizada ──────────────────────────────────────────────────
NAVY        <- "#1A3A5C"   # encabezados, texto y controles
NAVY_LIGHT  <- "#2471A3"   # azul medio para acentos
CTRL_STYLE  <- paste0(
  "background-color:", NAVY, ";",
  "color:#FFFFFF;",
  "border-radius:6px;",
  "padding:10px 12px;"
)
NOTE_STYLE  <- paste0("border-left:4px solid ", NAVY, " !important; padding-left:8px;")
# ─────────────────────────────────────────────────────────────────────────────

tab_geograficoUI <- function(id) {
  ns <- NS(id)
  tagList(
    # CSS global: sliders, selects y labels en navy
    tags$style(HTML(paste0("
      .geo-ctrl .selectize-input,
      .geo-ctrl .selectize-dropdown  { border-color:", NAVY, " !important; }
      .geo-ctrl .irs-bar,
      .geo-ctrl .irs-bar-edge        { background:", NAVY, " !important;
                                        border-color:", NAVY, " !important; }
      .geo-ctrl .irs-handle          { border-color:", NAVY, " !important; }
      .geo-ctrl .irs-single          { background:", NAVY, " !important; }
      .geo-ctrl label                { color:", NAVY, " !important;
                                        font-weight:600; }
      .geo-ctrl .control-label       { color:", NAVY, " !important;
                                        font-weight:600; }
      .geo-nota                      { border-left:4px solid ", NAVY, " !important;
                                        padding-left:8px; color:#333; }
    "))),

    tags$div(class = "section-header",
             style = paste0("background:", NAVY, "; color:#fff; padding:8px 14px;
                             border-radius:6px; margin-bottom:10px; font-weight:700;"),
             "Análisis Geográfico: Disparidades por Estado"),

    tags$div(class = "texto-academico", style = "margin-bottom:14px;",
      "Las disparidades geográficas no son aleatorias: los estados del Sur
       muestran tasas ajustadas persistentemente más altas."
    ),

    fluidRow(
      # ── Panel de controles 1 ─────────────────────────────────────────────
      column(3,
        bs4Card(
          width = 12, collapsible = FALSE,
          title = tags$span(style = paste0("color:#fff;"),
                            icon("sliders-h"), " Controles del Mapa"),
          status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          tags$div(class = "geo-ctrl",
            selectInput(ns("causa_geo"), "Causa de muerte:",
                        choices = CAUSAS_GEO_DEFAULT, selected = "All causes"),
            sliderInput(ns("ano_mapa"), "Año:",
              min = 1999, max = 2017, value = 2017, step = 1, sep = "",
              animate = animationOptions(interval = 900, loop = FALSE))
          ),
          tags$hr(style = paste0("border-color:", NAVY, ";")),
          valueBoxOutput(ns("vb_max_estado"), width = 12),
          tags$br(),
          valueBoxOutput(ns("vb_min_estado"), width = 12)
        )
      ),
      # ── Mapa 1 ──────────────────────────────────────────────────────────
      column(9,
        bs4Card(
          width = 12, collapsible = FALSE,
          title = tags$span(style = "color:#fff;",
                            icon("map"), " Mapa Coroplético — Tasa Ajustada por Estado"),
          status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          leafletOutput(ns("mapa_geo"), height = "520px"),
          tags$div(class = "geo-nota",
            icon("circle-info"),
            " Usa el slider lateral para explorar año a año (1999-2017)."
          )
        )
      )
    ),

    fluidRow(
      # ── Panel de controles 2 ─────────────────────────────────────────────
      column(3,
        bs4Card(
          width = 12, collapsible = FALSE,
          title = tags$span(style = "color:#fff;",
                            icon("sliders-h"), " Controles — N° de Muertes"),
          status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          tags$div(class = "geo-ctrl",
            selectInput(ns("causa_geo2"), "Causa de muerte:",
                        choices = CAUSAS_GEO_DEFAULT, selected = "All causes"),
            sliderInput(ns("ano_mapa2"), "Año:",
              min = 1999, max = 2017, value = 2017, step = 1, sep = "",
              animate = animationOptions(interval = 900, loop = FALSE))
          ),
          tags$hr(style = paste0("border-color:", NAVY, ";")),
          valueBoxOutput(ns("vb_max_estado2"), width = 12),
          tags$br(),
          valueBoxOutput(ns("vb_min_estado2"), width = 12)
        )
      ),
      # ── Mapa 2 ──────────────────────────────────────────────────────────
      column(9,
        bs4Card(
          width = 12, collapsible = FALSE,
          title = tags$span(style = "color:#fff;",
                            icon("map"), " Número de muertes por estado de 1999 hasta 2017"),
          status = "navy", solidHeader = TRUE,
          headerBorder = FALSE,
          leafletOutput(ns("mapa_geo2"), height = "520px"),
          tags$div(class = "geo-nota",
            icon("circle-info"),
            " Número absoluto de muertes por estado. Usa el slider para explorar 1999-2017."
          )
        )
      )
    ),

    # ── Top 10 estados — BUBBLE CHART ────────────────────────────────────────
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(style = "color:#fff;",
                        icon("circle-dot"), " Top 10 Estados — Tasa Ajustada vs Muertes Absolutas"),
      status = "navy", solidHeader = TRUE,
      headerBorder = FALSE,
      tags$div(class = "geo-ctrl",
        fluidRow(
          column(4, selectInput(ns("causa_top10"), "Causa:",
                                choices = CAUSAS_GEO_DEFAULT, selected = "All causes")),
          column(4, sliderInput(ns("ano_top10"), "Año:",
                                min = 1999, max = 2017, value = 2017, step = 1, sep = ""))
        )
      ),
      plotlyOutput(ns("plot_top10"), height = "420px"),
      tags$div(class = "geo-nota",
        icon("circle-info"),
        tags$strong(" Cómo leer este gráfico: "),
        "Cada burbuja es un estado del Top 15 por mayor tasa ajustada. El eje X muestra
         la tasa ajustada por 100,000 hab., el eje Y indica la posición en el ranking (1 = mayor tasa), y el ",
        tags$strong("tamaño de la burbuja"),
        " refleja la tasa ajustada — a mayor tasa, más grande y más oscura la burbuja.
         Estados como West Virginia o Mississippi lideran consistentemente el ranking."
      )
    ),

    # ── Acumulado ────────────────────────────────────────────────────────────
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(style = "color:#fff;", icon("chart-bar"),
              " Top 10 Causas de Muerte en EE.UU. — Total Acumulado (1999–2017)"),
      status = "navy", solidHeader = TRUE,
      headerBorder = FALSE,
      plotlyOutput(ns("plot_acumulado"), height = "380px"),
      tags$div(class = "geo-nota",
        icon("circle-info"), " Total acumulado de muertes por causa (nivel nacional, 1999-2017).")
    ),

    # ── Evolución tasas ──────────────────────────────────────────────────────
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(style = "color:#fff;", icon("chart-line"),
              " Evolución de las Tasas de Mortalidad Ajustadas por Edad (1999–2017)"),
      status = "navy", solidHeader = TRUE,
      headerBorder = FALSE,
      plotlyOutput(ns("plot_evol_tasas"), height = "420px"),
      tags$div(class = "geo-nota",
        icon("circle-info"),
        " Promedio nacional para las 10 causas principales (1999-2017).")
    )
  )
}

tab_geograficoServer <- function(id, datos_us, datos_estados) {
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

    observe({
      req(datos_estados)
      req("cause_name" %in% names(datos_estados))
      causas_real <- sort(unique(datos_estados[["cause_name"]]))
      req(length(causas_real) > 0)
      sel <- if ("All causes" %in% causas_real) "All causes" else causas_real[1]
      updateSelectInput(session, "causa_geo",   choices = causas_real, selected = sel)
      updateSelectInput(session, "causa_top10", choices = causas_real, selected = sel)
    })

    estados_sf <- reactive({ estados_sf_global })

    datos_geo_ano <- reactive({
      req(input$causa_geo, nzchar(input$causa_geo), input$ano_mapa)
      datos_estados %>%
        filter(
          cause_name == input$causa_geo,
          year       == as.integer(input$ano_mapa)
        ) %>%
        mutate(
          tasa  = as.numeric(age_adjusted_death_rate),
          state = str_trim(state)
        ) %>%
        select(state, tasa)
    })

    output$vb_max_estado <- renderValueBox({
      df <- req(datos_geo_ano()) %>% filter(!is.na(tasa)) %>%
        slice_max(tasa, n = 1, with_ties = FALSE)
      bs4ValueBox(
        value    = if (nrow(df) > 0) round(df$tasa[1], 1) else "N/D",
        subtitle = if (nrow(df) > 0) paste("Mayor tasa:", df$state[1]) else "Mayor tasa",
        icon  = icon("arrow-up"), color = "danger"
      )
    })

    output$vb_min_estado <- renderValueBox({
      df <- req(datos_geo_ano()) %>% filter(!is.na(tasa)) %>%
        slice_min(tasa, n = 1, with_ties = FALSE)
      bs4ValueBox(
        value    = if (nrow(df) > 0) round(df$tasa[1], 1) else "N/D",
        subtitle = if (nrow(df) > 0) paste("Menor tasa:", df$state[1]) else "Menor tasa",
        icon  = icon("arrow-down"), color = "success"
      )
    })

    output$mapa_geo <- renderLeaflet({
      geo <- estados_sf()
      df  <- datos_geo_ano()
      req(geo)

      mapa_data <- geo %>%
        left_join(
          if (!is.null(df) && nrow(df) > 0) df else data.frame(state=character(), tasa=numeric()),
          by = c("NAME" = "state")
        )

      vals_ok <- mapa_data$tasa[!is.na(mapa_data$tasa)]

      if (length(vals_ok) == 0) {
        return(
          leaflet(mapa_data) %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(-98, 38, zoom = 4) %>%
            addPolygons(weight = 1.2, color = "#1A3A5C",
                        fillColor = "#D6E4F0", fillOpacity = 0.7, label = ~NAME)
        )
      }

      pal <- colorNumeric(palette = brewer.pal(7, "Blues"),
                          domain = range(vals_ok), na.color = "#f0f0f0")

      leaflet(mapa_data) %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        setView(lng = -98, lat = 38, zoom = 4) %>%
        addPolygons(
          fillColor   = ~pal(tasa), weight = 1.2, color = "#1A3A5C",
          fillOpacity = 0.85,
          label       = ~paste0(NAME, " \u2013 ",
            ifelse(is.na(tasa), "Sin dato", paste0(round(tasa, 1), " por 100,000"))),
          highlightOptions = highlightOptions(
            weight = 3, color = "#0A1F3D", fillOpacity = 1, bringToFront = TRUE)
        ) %>%
        addLegend(pal = pal, values = vals_ok,
                  title = "Tasa ajustada<br>por 100,000",
                  position = "bottomright", labFormat = labelFormat(digits = 0))
    })

    # --- Mapa 2: Muertes absolutas por estado ---
    observe({
      req(datos_estados)
      causas_real <- sort(unique(datos_estados[["cause_name"]]))
      req(length(causas_real) > 0)
      sel <- if ("All causes" %in% causas_real) "All causes" else causas_real[1]
      updateSelectInput(session, "causa_geo2", choices = causas_real, selected = sel)
    })

    datos_geo_ano2 <- reactive({
      req(input$causa_geo2, nzchar(input$causa_geo2), input$ano_mapa2)
      datos_estados %>%
        filter(
          cause_name == input$causa_geo2,
          year       == as.integer(input$ano_mapa2)
        ) %>%
        mutate(
          muertes_abs = as.numeric(deaths),
          state       = str_trim(state)
        ) %>%
        select(state, muertes_abs)
    })

    output$vb_max_estado2 <- renderValueBox({
      df <- req(datos_geo_ano2()) %>% filter(!is.na(muertes_abs)) %>%
        slice_max(muertes_abs, n = 1, with_ties = FALSE)
      bs4ValueBox(
        value    = if (nrow(df) > 0) format(df$muertes_abs[1], big.mark = ",") else "N/D",
        subtitle = if (nrow(df) > 0) paste("Mayor número:", df$state[1]) else "Mayor número",
        icon = icon("arrow-up"), color = "danger"
      )
    })

    output$vb_min_estado2 <- renderValueBox({
      df <- req(datos_geo_ano2()) %>% filter(!is.na(muertes_abs)) %>%
        slice_min(muertes_abs, n = 1, with_ties = FALSE)
      bs4ValueBox(
        value    = if (nrow(df) > 0) format(df$muertes_abs[1], big.mark = ",") else "N/D",
        subtitle = if (nrow(df) > 0) paste("Menor número:", df$state[1]) else "Menor número",
        icon = icon("arrow-down"), color = "success"
      )
    })

    output$mapa_geo2 <- renderLeaflet({
      geo  <- estados_sf()
      df   <- datos_geo_ano2()
      req(geo)

      mapa_data2 <- geo %>%
        left_join(
          if (!is.null(df) && nrow(df) > 0) df
          else data.frame(state = character(), muertes_abs = numeric()),
          by = c("NAME" = "state")
        )

      vals_ok2 <- mapa_data2$muertes_abs[!is.na(mapa_data2$muertes_abs)]

      if (length(vals_ok2) == 0) {
        return(
          leaflet(mapa_data2) %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(-98, 38, zoom = 4) %>%
            addPolygons(weight = 1.2, color = "#1A3A5C",
                        fillColor = "#D6E4F0", fillOpacity = 0.7, label = ~NAME)
        )
      }

      pal2 <- colorNumeric(palette = brewer.pal(7, "Blues"),
                           domain = range(vals_ok2), na.color = "#f0f0f0")

      leaflet(mapa_data2) %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        setView(lng = -98, lat = 38, zoom = 4) %>%
        addPolygons(
          fillColor   = ~pal2(muertes_abs), weight = 1.2, color = "#1A3A5C",
          fillOpacity = 0.85,
          label       = ~paste0(NAME, " – ",
            ifelse(is.na(muertes_abs), "Sin dato",
                   paste0(format(muertes_abs, big.mark = ","), " muertes"))),
          highlightOptions = highlightOptions(
            weight = 3, color = "#0A1F3D", fillOpacity = 1, bringToFront = TRUE)
        ) %>%
        addLegend(pal = pal2, values = vals_ok2,
                  title = "Número de<br>muertes",
                  position = "bottomright",
                  labFormat = labelFormat(big.mark = ",", digits = 0))
    })

    # ── plot_top10 — BUBBLE CHART: Tasa ajustada vs Muertes absolutas ─────────
    output$plot_top10 <- renderPlotly({
      req(input$causa_top10, nzchar(input$causa_top10), input$ano_top10)

      df <- datos_estados %>%
        filter(cause_name == input$causa_top10,
               year == as.integer(input$ano_top10)) %>%
        mutate(tasa    = as.numeric(age_adjusted_death_rate),
               muertes = as.numeric(deaths),
               state   = str_trim(state)) %>%
        filter(!is.na(tasa), !is.na(muertes)) %>%
        arrange(desc(tasa)) %>%
        slice_head(n = 15) %>%
        mutate(state = case_when(
          state == "West Virginia" ~ "W. Virginia",
          TRUE ~ state
        ))

      if (nrow(df) == 0) {
        return(plotly_empty() %>%
                 plotly::layout(title = list(text = "Sin datos para el año seleccionado")))
      }

      # Paleta: puesto 1 más oscuro → puesto 15 más claro
      pal_burbujas <- colorRampPalette(c("#1A3A5C", "#AED6F1"))(nrow(df))

      # Ranking como eje Y — multiplicado x2 para dar espacio físico entre burbujas
      df <- df %>% arrange(desc(tasa)) %>%
        mutate(
          ranking     = row_number(),
          ranking_y   = row_number() * 2.5   # posición real en el eje: 2.5, 5, 7.5 ... 37.5
        )

      # Tamaño normalizado [20, 55] px de diámetro
      t_min <- min(df$tasa, na.rm = TRUE)
      t_max <- max(df$tasa, na.rm = TRUE)
      if (t_max == t_min) {
        df$bubble_size <- rep(35, nrow(df))
      } else {
        df$bubble_size <- 20 + ((df$tasa - t_min) / (t_max - t_min)) * 35
      }

      plot_ly(df,
        x    = ~tasa,
        y    = ~ranking_y,
        size = ~bubble_size,
        text = ~state,
        type = "scatter",
        mode = "markers+text",
        textposition = ifelse(df$ranking <= 4, "middle right", "top center"),
        textfont = list(size = 9, color = "#1A3A5C"),
        marker = list(
          color    = pal_burbujas,
          sizemode = "diameter",
          sizeref  = 1,
          sizemin  = 10,
          opacity  = 0.82,
          line     = list(color = "white", width = 1.8)
        ),
        hovertemplate = ~paste0(
          "<b>#", ranking, " — ", state, "</b><br>",
          "Tasa ajustada: ", round(tasa, 1), " por 100,000",
          "<extra></extra>"
        )
      ) %>%
        plotly::layout(
          title = list(
            text = paste0("Top 15 estados — Mayor tasa ajustada: ", input$ano_top10),
            font = list(color = "#1a3a5c", size = 13)
          ),
          xaxis = list(
            title     = "Tasa ajustada por 100,000 habitantes",
            titlefont = list(color = "#1A3A5C"),
            tickfont  = list(color = "#1A3A5C"),
            showgrid  = TRUE,
            gridcolor = "rgba(180,180,180,0.3)",
            range     = list(
              min(df$tasa, na.rm = TRUE) * 0.97,
              max(df$tasa, na.rm = TRUE) * 1.15
            )
          ),
          yaxis = list(
            title      = "Posición en el ranking",
            titlefont  = list(color = "#1A3A5C", size = 10),
            tickfont   = list(color = "#1A3A5C", size = 9),
            # Ticks personalizados: mostrar 1-15 aunque internamente sean 2,4,6..30
            tickmode   = "array",
            tickvals   = df$ranking_y,
            ticktext   = as.character(df$ranking),
            range      = list(40, 0),   # 0 arriba deja espacio para burbuja del puesto 1
            showgrid   = TRUE,
            gridcolor  = "rgba(180,180,180,0.3)"
          ),
          plot_bgcolor  = "rgba(0,0,0,0)",
          paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11),
          showlegend = FALSE,
          margin = list(t = 60, b = 55, l = 70, r = 80)
        )
    })

    output$plot_acumulado <- renderPlotly({
      df_acum <- datos_us %>%
        filter(causa != "All causes") %>%
        group_by(causa) %>%
        summarise(total_muertes = sum(muertes, na.rm = TRUE), .groups = "drop") %>%
        arrange(desc(total_muertes)) %>%
        slice_head(n = 10) %>%
        mutate(
          causa = reorder(causa, total_muertes),
          color_grupo = "#2471A3"
        )

      plot_ly(df_acum,
              x = ~total_muertes, y = ~causa,
              type = "bar", orientation = "h",
              marker = list(color = ~color_grupo),
              hovertemplate = ~paste0("<b>", causa, "</b><br>Total: ",
                                      format(total_muertes, big.mark = ","),
                                      "<extra></extra>"),
              text = ~format(total_muertes, big.mark = ","),
              textposition = "outside"
      ) %>%
        plotly::layout(
          title  = list(text = "Top 10 Causas de Muerte en EE.UU. — Total Acumulado (1999–2017)",
                        font = list(color = "#1a3a5c", size = 13),
                        x = 0.5, xanchor = "center"),
          margin = list(t = 60),
          xaxis    = list(title = "Total de muertes acumuladas",
                       titlefont = list(color = "#1A3A5C"),
                       tickfont  = list(color = "#1A3A5C")),
          yaxis    = list(title = "",
                       tickfont = list(color = "#1A3A5C")),
          plot_bgcolor  = "rgba(0,0,0,0)",
          paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11, color = "#1A3A5C"),
          showlegend = FALSE
        )
    })

    output$plot_evol_tasas <- renderPlotly({
      df_evol <- datos_nacional_mod() %>% filter(!is.na(tasa_ajustada))

      cols_base <- c(
        "Heart disease"           = "#1A3A5C",
        "Cancer"                  = "#2E86C1",
        "Stroke"                  = "#1A7A5E",
        "CLRD"                    = "#8B4513",
        "Unintentional injuries"  = "#5B5EA6",
        "Diabetes"                = "#B5883A",
        "Alzheimer's disease"     = "#3D7A6B",
        "Influenza and pneumonia" = "#7B3F6E",
        "Kidney disease"          = "#4A7C8E",
        "Suicide"                 = "#6B6B6B"
      )

      causas_evol <- sort(unique(df_evol$causa))
      p_evol <- plot_ly()
      for (cau in causas_evol) {
        df_c <- df_evol %>% filter(causa == cau) %>% arrange(anio)
        col_c <- if (cau %in% names(cols_base)) cols_base[[cau]] else "#1A3A5C"
        p_evol <- p_evol %>%
          add_lines(data = df_c, x = ~anio, y = ~tasa_ajustada,
                    name = cau,
                    line = list(color = col_c, width = 2.2),
                    hovertemplate = paste0("<b>", cau, "</b><br>Año: %{x}<br>",
                                          "Tasa: %{y:.1f} por 100,000<extra></extra>")) %>%
          add_markers(data = df_c, x = ~anio, y = ~tasa_ajustada,
                      marker = list(color = col_c, size = 5),
                      showlegend = FALSE, hoverinfo = "skip")
      }
      p_evol %>% plotly::layout(
        title  = list(text = "Evolución de las tasas de mortalidad ajustadas por edad<br><sub>Promedio nacional 1999-2017</sub>",
                      font = list(color = "#1A3A5C", size = 13)),
        xaxis  = list(title = "Año", tickmode = "linear", dtick = 2,
                      titlefont = list(color = "#1A3A5C"),
                      tickfont  = list(color = "#1A3A5C")),
        yaxis  = list(title = "Tasa por 100,000 habitantes",
                      titlefont = list(color = "#1A3A5C"),
                      tickfont  = list(color = "#1A3A5C")),
        legend = list(orientation = "v", font = list(size = 9, color = "#1A3A5C")),
        plot_bgcolor  = "rgba(0,0,0,0)",
        paper_bgcolor = "rgba(0,0,0,0)",
        font = list(family = "Segoe UI, Arial, sans-serif", size = 11, color = "#1A3A5C")
      )
    })
  })
}

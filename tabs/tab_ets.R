# ============================================================
# tabs/tab_ets.R
# Sección 13 del exploratorio
# Modelo ETS — West Virginia · Unintentional Injuries
# ============================================================

tab_etsUI <- function(id) {
  ns <- NS(id)

  tagList(

    # ── CSS paleta navy/azul (compartido) ───────────────────
    tags$head(
      tags$style(HTML("
        .mod-header {
          border-radius: 14px;
          padding: 22px 28px;
          margin-bottom: 20px;
          box-shadow: 0 4px 20px rgba(29,53,87,0.15);
          position: relative;
          overflow: hidden;
        }
        .mod-header::before {
          content: '';
          position: absolute;
          top: -40px; right: -40px;
          width: 180px; height: 180px;
          background: rgba(255,255,255,0.05);
          border-radius: 50%;
        }
        .mod-header::after {
          content: '';
          position: absolute;
          bottom: -30px; right: 60px;
          width: 100px; height: 100px;
          background: rgba(255,255,255,0.07);
          border-radius: 50%;
        }
        .mod-badge {
          display: inline-block;
          background: rgba(255,255,255,0.13);
          border: 1px solid rgba(255,255,255,0.22);
          font-size: 0.7rem;
          font-weight: 700;
          letter-spacing: 1.3px;
          text-transform: uppercase;
          padding: 3px 10px;
          border-radius: 20px;
          margin-bottom: 9px;
          color: #a8d8f0;
        }
        .mod-header h3 {
          margin: 0 0 5px;
          color: #ffffff;
          font-weight: 800;
          font-size: 1.18rem;
        }
        .mod-header p {
          margin: 0;
          color: rgba(255,255,255,0.72);
          font-size: 0.855rem;
          line-height: 1.5;
          max-width: 760px;
        }
        .kpi-bar {
          display: flex;
          gap: 0;
          margin-bottom: 18px;
          border-radius: 12px;
          overflow: hidden;
          box-shadow: 0 2px 10px rgba(0,0,0,0.07);
          border: 1px solid #e2e8f2;
        }
        .kpi-bar .kpi-cell {
          flex: 1;
          background: #ffffff;
          border-right: 1px solid #e2e8f2;
          padding: 14px 12px;
          text-align: center;
        }
        .kpi-bar .kpi-cell:last-child { border-right: none; }
        .kpi-bar .kpi-label {
          font-size: 0.72rem;
          font-weight: 700;
          letter-spacing: 0.8px;
          text-transform: uppercase;
          color: #8a97aa;
          margin: 0 0 4px;
        }
        .mod-card {
          background: #ffffff;
          border: 1px solid #e2e8f2;
          border-radius: 12px;
          box-shadow: 0 1px 8px rgba(0,0,0,0.05);
          padding: 18px;
          margin-bottom: 18px;
        }
        .mod-card-title {
          font-size: 0.92rem;
          font-weight: 700;
          color: #1D3557;
          margin: 0 0 14px;
          display: flex;
          align-items: center;
          gap: 8px;
          padding-bottom: 10px;
          border-bottom: 2px solid #f0f4fa;
        }
        .card-icon {
          width: 28px; height: 28px;
          border-radius: 7px;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          font-size: 0.8rem;
          flex-shrink: 0;
        }
        .mod-nota {
          background: #f4f7fb;
          border-left: 3px solid #457B9D;
          border-radius: 0 6px 6px 0;
          padding: 8px 12px;
          font-size: 0.8rem;
          color: #4a5568;
          margin-top: 12px;
        }
        .mod-warning {
          background: #fffbeb;
          border: 1px solid #f6d860;
          border-left: 4px solid #d97706;
          border-radius: 8px;
          padding: 11px 15px;
          margin-bottom: 16px;
          font-size: 0.82rem;
          color: #7c5a00;
          line-height: 1.5;
        }
      "))
    ),

    # ── Encabezado ──────────────────────────────────────────
    tags$div(
      class = "mod-header",
      style = "background: linear-gradient(135deg, #0f2340 0%, #1D3557 60%, #2a4a72 100%);",
      tags$span(class = "mod-badge", "Modelo 2 · Suavizamiento Exponencial"),
      tags$h3(icon("chart-line"), " ETS (Error, Trend, Seasonality)"),
      tags$p(
        "Suavizamiento exponencial con selección automática por AICc.",
        " Aplicado a Unintentional Injuries – West Virginia (1999–2017). Sección 13."
      )
    ),

    # ── KPIs ────────────────────────────────────────────────
    tags$div(
      class = "kpi-bar",
      tags$div(class = "kpi-cell",
        tags$p(class = "kpi-label", "Especificación"),
        uiOutput(ns("kpi_spec"))
      ),
      tags$div(class = "kpi-cell",
        tags$p(class = "kpi-label", "AICc"),
        uiOutput(ns("kpi_aicc"))
      ),
      tags$div(class = "kpi-cell",
        tags$p(class = "kpi-label", "RMSE (muestra)"),
        uiOutput(ns("kpi_rmse"))
      ),
      tags$div(class = "kpi-cell",
        tags$p(class = "kpi-label", "Ljung-Box p-valor"),
        uiOutput(ns("kpi_ljung"))
      )
    ),

    # ── 13.1 Residuos ───────────────────────────────────────
    fluidRow(
      column(6,
        tags$div(class = "mod-card",
          tags$div(class = "mod-card-title",
            tags$span(class = "card-icon",
              style = "background:#e8f0fb; color:#1D3557;", icon("microscope")),
            "13.1 · Diagnóstico de residuos — ETS"
          ),
          plotlyOutput(ns("plot_resid"), height = "260px"),
          tags$div(class = "mod-nota",
            icon("circle-info"), tags$strong(" Interpretación: "),
            "Residuos deben comportarse como ruido blanco (p > 0.05 en Ljung-Box)."
          )
        )
      ),
      column(6,
        tags$div(class = "mod-card",
          tags$div(class = "mod-card-title",
            tags$span(class = "card-icon",
              style = "background:#e8f0fb; color:#1D3557;", icon("chart-bar")),
            "13.1 · Distribución de residuos — ETS"
          ),
          plotlyOutput(ns("plot_resid_hist"), height = "260px"),
          tags$div(
            style = "visibility:hidden; pointer-events:none;",
            tags$div(class = "mod-nota",
              icon("circle-info"), tags$strong(" Interpretación: "),
              "Residuos deben comportarse como ruido blanco (p > 0.05 en Ljung-Box)."
            )
          )
        )
      )
    ),

    # ── 13.2 Proyección ─────────────────────────────────────
    tags$div(class = "mod-card",
      tags$div(class = "mod-card-title",
        tags$span(class = "card-icon",
          style = "background:#e8f0fb; color:#1D3557;", icon("chart-line")),
        "13.2 · Proyección ETS — Unintentional Injuries (2018–2022)"
      ),
      plotlyOutput(ns("plot_forecast"), height = "380px"),
      tags$div(class = "mod-nota",
        icon("circle-info"), tags$strong(" Interpretación: "),
        "ETS(M,A,N) proyecta crecimiento sostenido desde ~88 hasta ~98 por 100,000 hab. en 2022.",
        " Los IC se amplían por la incertidumbre acumulada en series cortas con tendencia fuerte."
      )
    ),

    # ── 13.3 Tabla ──────────────────────────────────────────
    tags$div(class = "mod-card",
      tags$div(class = "mod-card-title",
        tags$span(class = "card-icon",
          style = "background:#e8f0fb; color:#1D3557;", icon("table")),
        "13.3 · Tabla de valores proyectados — ETS"
      ),
      DTOutput(ns("tbl_forecast")),
      tags$p(style = "font-size:0.74rem; color:#8a97aa; margin-top:10px;",
             "IC 80% e IC 95%: intervalos de confianza. ETS(M,A,N) tiene error multiplicativo,
             lo que amplía los IC proporcionalmente a la magnitud de la serie.")
    )

  )
}

# ── SERVER ────────────────────────────────────────────────────────────────────
tab_etsServer <- function(id, ts_wv_acc, serie_wv_acc) {
  moduleServer(id, function(input, output, session) {

    modelo_ets <- reactive({
      ets(ts_wv_acc())
    })

    fc_ets <- reactive({
      forecast(modelo_ets(), h = 5, level = c(80, 95))
    })

    lb_ets <- reactive({
      Box.test(residuals(modelo_ets()), lag = 4, type = "Ljung-Box")
    })

    # KPIs
    output$kpi_spec <- renderUI({
      tags$p(style = "font-size:1.1rem; font-weight:800; color:#1D3557; margin:2px 0; font-family:monospace;",
             modelo_ets()$method)
    })

    output$kpi_aicc <- renderUI({
      tags$p(style = "font-size:1.2rem; font-weight:800; color:#1A3A5C; margin:2px 0;",
             round(modelo_ets()$aicc, 2))
    })

    output$kpi_rmse <- renderUI({
      acc <- accuracy(modelo_ets())
      tags$p(style = "font-size:1.2rem; font-weight:800; color:#1A3A5C; margin:2px 0;",
             round(acc[, "RMSE"], 2))
    })

    output$kpi_ljung <- renderUI({
      lb   <- lb_ets()
      pval <- round(lb$p.value, 4)
      col  <- if (pval > 0.05) "#1e8449" else "#e74c3c"
      tags$div(
        tags$p(style = paste0("font-size:1.1rem; font-weight:800; color:", col, "; margin:2px 0;"),
               if (pval > 0.05) "✅ Ruido blanco" else "⚠️ Estructura"),
        tags$p(style = "font-size:0.78rem; color:#888; margin:0;", paste0("p = ", pval))
      )
    })

    # Residuos
    output$plot_resid <- renderPlotly({
      res_ <- as.numeric(residuals(modelo_ets()))
      anio_vec <- 1999:(1999 + length(res_) - 1)
      df_ <- data.frame(anio = anio_vec, residuo = res_)
      plot_ly() %>%
        add_segments(data = df_, x = ~anio, xend = ~anio, y = 0, yend = ~residuo,
                     line = list(color = "#457B9D", width = 2), name = "Residuo") %>%
        add_markers(data = df_, x = ~anio, y = ~residuo,
                    marker = list(color = "#1D3557", size = 5), showlegend = FALSE) %>%
        add_lines(x = range(anio_vec), y = c(0, 0),
                  line = list(color = "#333", dash = "dot", width = 1), showlegend = FALSE) %>%
        plotly::layout(
          xaxis = list(title = "Año", tickmode = "linear", dtick = 2),
          yaxis = list(title = "Residuo"),
          plot_bgcolor = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
        )
    })

    output$plot_resid_hist <- renderPlotly({
      res_ <- as.numeric(residuals(modelo_ets()))
      plot_ly(x = res_, type = "histogram", nbinsx = 8,
              marker = list(color = "#457B9D", line = list(color = "#1D3557", width = 1)),
              name = "Residuos") %>%
        plotly::layout(
          xaxis = list(title = "Residuo"),
          yaxis = list(title = "Frecuencia"),
          plot_bgcolor = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
        )
    })

    # Forecast
    output$plot_forecast <- renderPlotly({
      fc      <- fc_ets()
      serie   <- serie_wv_acc()
      df_hist <- data.frame(anio = 1999:2017, valor = serie)
      df_fc   <- data.frame(
        anio     = 2018:2022,
        estimado = as.numeric(fc$mean),
        lo80     = as.numeric(fc$lower[, 1]),
        hi80     = as.numeric(fc$upper[, 1]),
        lo95     = as.numeric(fc$lower[, 2]),
        hi95     = as.numeric(fc$upper[, 2])
      )

      plot_ly() %>%
        add_ribbons(data = df_fc, x = ~anio, ymin = ~lo95, ymax = ~hi95,
                    fillcolor = "rgba(69,123,157,0.15)",
                    line = list(color = "transparent"), name = "IC 95%") %>%
        add_ribbons(data = df_fc, x = ~anio, ymin = ~lo80, ymax = ~hi80,
                    fillcolor = "rgba(69,123,157,0.35)",
                    line = list(color = "transparent"), name = "IC 80%") %>%
        add_lines(data = df_hist, x = ~anio, y = ~valor,
                  name = "Histórico (1999–2017)",
                  line = list(color = "#1D3557", width = 2.5)) %>%
        add_markers(data = df_hist, x = ~anio, y = ~valor,
                    marker = list(color = "#1D3557", size = 5), showlegend = FALSE) %>%
        add_lines(data = df_fc, x = ~anio, y = ~estimado,
                  name = "Proyección ETS",
                  line = list(color = "#457B9D", width = 2.5, dash = "dash")) %>%
        add_markers(data = df_fc, x = ~anio, y = ~estimado,
                    marker = list(color = "#457B9D", size = 7, symbol = "triangle-up"),
                    showlegend = FALSE) %>%
        plotly::layout(
          title  = list(text = "<b>Proyección ETS — Unintentional Injuries · West Virginia</b>",
                        font = list(size = 13, color = "#1D3557")),
          xaxis  = list(title = "Año", tickmode = "linear", dtick = 2),
          yaxis  = list(title = "Tasa por 100,000 hab."),
          shapes = list(list(
            type = "line", x0 = 2017.5, x1 = 2017.5, y0 = 0, y1 = 1, yref = "paper",
            line = list(color = "#333", dash = "dot", width = 1.5)
          )),
          legend        = list(orientation = "h", x = 0, y = -0.15),
          hovermode     = "x unified",
          plot_bgcolor  = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
        )
    })

    # Tabla
    output$tbl_forecast <- renderDT({
      fc <- fc_ets()
      df <- tibble(
        Año          = 2018:2022,
        Estimado     = round(as.numeric(fc$mean),         1),
        `Lo 80%`     = round(as.numeric(fc$lower[, 1]),   1),
        `Hi 80%`     = round(as.numeric(fc$upper[, 1]),   1),
        `Lo 95%`     = round(as.numeric(fc$lower[, 2]),   1),
        `Hi 95%`     = round(as.numeric(fc$upper[, 2]),   1)
      )
      datatable(df, options = list(dom = "t", paging = FALSE, searching = FALSE),
                rownames = FALSE) %>%
        formatStyle("Estimado", fontWeight = "bold", color = "#1D3557") %>%
        formatStyle(c("Lo 80%", "Hi 80%"), color = "#457B9D") %>%
        formatStyle(c("Lo 95%", "Hi 95%"), color = "#888")
    })

  })
}

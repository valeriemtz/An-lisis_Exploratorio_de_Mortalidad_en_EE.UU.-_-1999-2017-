# ============================================================
# tabs/tab_regresion.R
# Sección 14 del exploratorio
# Modelo Regresión Lineal — West Virginia · Unintentional Injuries
# ============================================================

tab_regresionUI <- function(id) {
  ns <- NS(id)

  tagList(

    # ── Encabezado Regresión ─────────────────────────────────
    tags$div(
      class = "mod-header",
      style = "background: linear-gradient(135deg, #0f2340 0%, #1D3557 60%, #2a4a72 100%);",
      tags$span(class = "mod-badge", "Modelo 3 · Benchmark OLS"),
      tags$h3(icon("chart-line"), " Regresión Lineal con Tendencia Temporal"),
      tags$p(
        "Benchmark OLS: ŷₜ = β₀ + β₁·t + εₜ. Aplicado a Unintentional Injuries – West Virginia (1999–2017).",
        " Función del modelo de referencia mínimo. Sección 14."
      )
    ),

    # ── KPIs ────────────────────────────────────────────────
    tags$div(
      class = "kpi-bar",
      tags$div(class = "kpi-cell",
        tags$p(class = "kpi-label", "R²"),
        uiOutput(ns("kpi_r2"))
      ),
      tags$div(class = "kpi-cell",
        tags$p(class = "kpi-label", "β₁ (pendiente/año)"),
        uiOutput(ns("kpi_beta"))
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

    # ── 14.1 Residuos ───────────────────────────────────────
    fluidRow(
      column(6,
        tags$div(class = "mod-card",
          tags$div(class = "mod-card-title",
            tags$span(class = "card-icon",
              style = "background:#e8f0fb; color:#1D3557;", icon("microscope")),
            "14.1 · ACF de residuos — Regresión Lineal"
          ),
          plotlyOutput(ns("plot_acf_resid"), height = "260px"),
          tags$div(class = "mod-nota",
            icon("circle-info"), tags$strong(" Interpretación: "),
            "Barras que superen las bandas de confianza (±1.96/√n) indican autocorrelación residual."
          )
        )
      ),
      column(6,
        tags$div(class = "mod-card",
          tags$div(class = "mod-card-title",
            tags$span(class = "card-icon",
              style = "background:#e8f0fb; color:#1D3557;", icon("chart-bar")),
            "14.1 · Distribución de residuos — OLS"
          ),
          plotlyOutput(ns("plot_resid_hist"), height = "260px"),
          tags$div(
            style = "visibility:hidden; pointer-events:none;",
            tags$div(class = "mod-nota",
              icon("circle-info"), tags$strong(" Interpretación: "),
              "Barras que superen las bandas de confianza (±1.96/√n) indican autocorrelación residual."
            )
          )
        )
      )
    ),

    # ── 14.2 Proyección ─────────────────────────────────────
    tags$div(class = "mod-card",
      tags$div(class = "mod-card-title",
        tags$span(class = "card-icon",
          style = "background:#e8f0fb; color:#1D3557;", icon("chart-line")),
        "14.2 · Proyección Regresión Lineal — Unintentional Injuries (2018–2022)"
      ),
      plotlyOutput(ns("plot_forecast"), height = "380px"),
      tags$div(class = "mod-nota",
        icon("circle-info"), tags$strong(" Nota: "),
        "Las proyecciones puntuales convergen con ETS (~88–99 por 100,000) porque ambos modelos capturan la misma tendencia lineal.",
        " Sin embargo, los IC subestiman la incertidumbre real al no incorporar dependencia temporal."
      )
    ),

    # ── 14.3 Tabla ──────────────────────────────────────────
    tags$div(class = "mod-card",
      tags$div(class = "mod-card-title",
        tags$span(class = "card-icon",
          style = "background:#e8f0fb; color:#1D3557;", icon("table")),
        "14.3 · Tabla de valores proyectados — Regresión Lineal"
      ),
      DTOutput(ns("tbl_forecast")),
      tags$p(style = "font-size:0.74rem; color:#8a97aa; margin-top:10px;",
             "Intervalos de predicción OLS al 80% y 95%. Válidos solo bajo supuesto de errores independientes (no cumplido para series I(1)).")
    )

  )
}

# ── SERVER ────────────────────────────────────────────────────────────────────
tab_regresionServer <- function(id, ts_wv_acc, serie_wv_acc) {
  moduleServer(id, function(input, output, session) {

    modelo_lm <- reactive({
      s <- serie_wv_acc()
      t <- seq_along(s)
      lm(s ~ t)
    })

    resid_lm <- reactive({ residuals(modelo_lm()) })

    lb_lm <- reactive({
      res_ts <- ts(resid_lm(), start = 1999, frequency = 1)
      Box.test(res_ts, lag = 4, type = "Ljung-Box")
    })

    # KPIs
    output$kpi_r2 <- renderUI({
      r2 <- round(summary(modelo_lm())$r.squared, 3)
      tags$p(style = "font-size:1.2rem; font-weight:800; color:#1A3A5C; margin:2px 0;",
             paste0(r2 * 100, "%"))
    })

    output$kpi_beta <- renderUI({
      beta <- round(coef(modelo_lm())[2], 3)
      tags$p(style = "font-size:1.2rem; font-weight:800; color:#457B9D; margin:2px 0;",
             paste0("+", beta, " pts/año"))
    })

    output$kpi_rmse <- renderUI({
      rmse <- round(sqrt(mean(resid_lm()^2)), 2)
      tags$p(style = "font-size:1.2rem; font-weight:800; color:#1A3A5C; margin:2px 0;", rmse)
    })

    output$kpi_ljung <- renderUI({
      lb   <- lb_lm()
      pval <- round(lb$p.value, 4)
      col  <- if (pval > 0.05) "#1e8449" else "#e74c3c"
      tags$div(
        tags$p(style = paste0("font-size:1.1rem; font-weight:800; color:", col, "; margin:2px 0;"),
               if (pval > 0.05) "✅ Ruido blanco" else "⚠️ Autocorrelación"),
        tags$p(style = "font-size:0.78rem; color:#888; margin:0;", paste0("p = ", pval))
      )
    })

    # ACF residuos
    output$plot_acf_resid <- renderPlotly({
      res_ts <- ts(resid_lm(), start = 1999, frequency = 1)
      n   <- length(res_ts)
      lm_ <- min(8L, n - 2L)
      obj <- acf(res_ts, lag.max = lm_, plot = FALSE)
      df_ <- data.frame(lag = as.numeric(obj$lag), val = as.numeric(obj$acf))
      ic  <- qnorm(0.975) / sqrt(n)

      plot_ly() %>%
        add_segments(data = df_, x = ~lag, xend = ~lag, y = 0, yend = ~val,
                     line = list(color = "#1D3557", width = 3), name = "ACF") %>%
        add_markers(data = df_, x = ~lag, y = ~val,
                    marker = list(color = "#1D3557", size = 6), showlegend = FALSE) %>%
        add_lines(x = range(df_$lag), y = c(ic, ic),
                  line = list(color = "#457B9D", dash = "dash", width = 1.2), name = "IC 95%") %>%
        add_lines(x = range(df_$lag), y = c(-ic, -ic),
                  line = list(color = "#457B9D", dash = "dash", width = 1.2), showlegend = FALSE) %>%
        plotly::layout(
          xaxis = list(title = "Rezago", tickmode = "linear", dtick = 1),
          yaxis = list(title = "Autocorrelación", range = c(-1.1, 1.1)),
          plot_bgcolor = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)",
          font = list(family = "Segoe UI, Arial, sans-serif", size = 11),
          legend = list(orientation = "h", y = -0.2)
        )
    })

    output$plot_resid_hist <- renderPlotly({
      res_ <- resid_lm()
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
      serie   <- serie_wv_acc()
      mod     <- modelo_lm()
      n       <- length(serie)
      t_proj  <- data.frame(t = (n + 1):(n + 5))
      names(t_proj) <- all.vars(formula(mod))[2]  # nombre real de la variable t

      # Reconstruir datos para predict con el nombre correcto
      t_hist  <- seq_along(serie)
      df_mod  <- data.frame(y = serie, t = t_hist)
      mod2    <- lm(y ~ t, data = df_mod)
      t_new   <- data.frame(t = (n + 1):(n + 5))
      ic95    <- predict(mod2, newdata = t_new, interval = "prediction", level = 0.95)
      ic80    <- predict(mod2, newdata = t_new, interval = "prediction", level = 0.80)

      df_hist <- data.frame(anio = 1999:2017, valor = serie)
      df_fc   <- data.frame(
        anio     = 2018:2022,
        estimado = ic95[, "fit"],
        lo80     = ic80[, "lwr"],
        hi80     = ic80[, "upr"],
        lo95     = ic95[, "lwr"],
        hi95     = ic95[, "upr"]
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
                  name = "Proyección OLS",
                  line = list(color = "#457B9D", width = 2.5, dash = "dash")) %>%
        add_markers(data = df_fc, x = ~anio, y = ~estimado,
                    marker = list(color = "#457B9D", size = 7, symbol = "triangle-up"),
                    showlegend = FALSE) %>%
        plotly::layout(
          title  = list(text = "<b>Proyección Regresión Lineal — Unintentional Injuries · West Virginia</b>",
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
      serie  <- serie_wv_acc()
      n      <- length(serie)
      df_mod <- data.frame(y = serie, t = seq_along(serie))
      mod2   <- lm(y ~ t, data = df_mod)
      t_new  <- data.frame(t = (n + 1):(n + 5))
      ic95   <- predict(mod2, newdata = t_new, interval = "prediction", level = 0.95)
      ic80   <- predict(mod2, newdata = t_new, interval = "prediction", level = 0.80)

      df <- tibble(
        Año       = 2018:2022,
        Estimado  = round(ic95[, "fit"],  1),
        `Lo 80%`  = round(ic80[, "lwr"],  1),
        `Hi 80%`  = round(ic80[, "upr"],  1),
        `Lo 95%`  = round(ic95[, "lwr"],  1),
        `Hi 95%`  = round(ic95[, "upr"],  1)
      )
      datatable(df, options = list(dom = "t", paging = FALSE, searching = FALSE),
                rownames = FALSE) %>%
        formatStyle("Estimado", fontWeight = "bold", color = "#1D3557") %>%
        formatStyle(c("Lo 80%", "Hi 80%"), color = "#457B9D") %>%
        formatStyle(c("Lo 95%", "Hi 95%"), color = "#888")
    })

  })
}

# ============================================================
# tabs/tab_comparacion.R
# Secciones 15–16 del exploratorio
# Comparación y selección del modelo — West Virginia
# ============================================================

tab_comparacionUI <- function(id) {
  ns <- NS(id)

  tagList(

    # Encabezado principal estilo mod-header con banner ganador integrado
    uiOutput(ns("banner_ganador")),

    # 15.1 Tabla AIC
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("trophy"), " 15.1 · Criterios de información — AIC / AICc / BIC"),
      status = "navy", solidHeader = TRUE,
      tags$p(style = "font-size:0.81rem; color:#666; margin-bottom:8px;",
             "Menor AICc = mejor modelo. Con n = 19, AICc es el criterio apropiado (corrige sobreparametrización en muestras pequeñas).",
             " Diferencias > 7 pts constituyen evidencia fuerte contra el modelo mayor (Burnham & Anderson, 2002)."),
      DTOutput(ns("tbl_aic"))
    ),

    # 15.2 Ljung-Box comparativo
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("check-circle"), " 15.2 · Diagnóstico comparativo de residuos — Ljung-Box"),
      status = "navy", solidHeader = TRUE,
      tags$p(style = "font-size:0.81rem; color:#666; margin-bottom:8px;",
             "H₀: residuos independientes. p > 0.05 → ruido blanco (condición necesaria de validez)."),
      DTOutput(ns("tbl_ljung"))
    ),

    # 15.3 tsCV
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("rotate"), " 15.3 · Validación cruzada de series de tiempo (tsCV)"),
      status = "navy", solidHeader = TRUE,
      tags$p(style = "font-size:0.81rem; color:#666; margin-bottom:8px;",
             "Error de predicción fuera de muestra con ventanas de entrenamiento expandidas.",
             " Horizontes h = 1 (precisión inmediata) y h = 3 (proyección a mediano plazo)."),
      DTOutput(ns("tbl_cv")),
      tags$div(class = "nota-analitica",
        icon("circle-info"), tags$strong(" Nota: "),
        "La Regresión Lineal obtiene el menor RMSE en tsCV, pero sus IC son inválidos para series I(1) (no estacionaria).",
        " Entre los modelos válidos, las diferencias de RMSE son marginales (< 0.4 pts)."
      )
    ),

    # 15.4 Gráfico comparativo
    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("chart-line"), " 15.4 · Gráfico comparativo de proyecciones — Unintentional Injuries"),
      status = "navy", solidHeader = TRUE,
      plotlyOutput(ns("plot_comparacion"), height = "420px"),
      tags$div(class = "nota-analitica",
        icon("circle-info"), tags$strong(" Interpretación: "),
        "Línea negra: serie histórica 1999–2017. Líneas discontinuas: proyecciones 2018–2022 de cada modelo.",
        " ARIMA(0,1,0) with drift y ETS convergen; Holt amortiguado proyecta crecimiento decelerado."
      )
    ),

    # 16. Modelo Predictivo Óptimo
    tags$div(
      style = "margin-top: 10px;",

      # ── Encabezado mod-header igual al ETS/Regresión ─────────────────────────
      tags$div(
        class = "mod-header",
        style = "background: linear-gradient(135deg, #0f2340 0%, #1D3557 60%, #2a4a72 100%);",
        tags$span(class = "mod-badge", "Sección 16 · Modelo Predictivo Óptimo"),
        tags$h3(icon("scale-balanced"), " ARIMA(0,1,0) with drift — Selección y Justificación"),
        tags$p(
          "Comparación por AICc, diagnóstico de residuos y validez estadística.",
          " Aplicado a Unintentional Injuries – West Virginia (1999–2017). Sección 16."
        )
      ),

      # ── Cuerpo estructurado ───────────────────────────────────────────────────
      tags$div(
        style = paste0(
          "background:#f8f9fb;",
          "border: 1px solid #dee2e6;",
          "border-top: none;",
          "border-radius: 0 0 10px 10px;",
          "padding: 24px 24px 20px 24px;"
        ),

        # ── Grid de criterios de decisión ─────────────────────────────────────
        tags$div(
          style = "display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:16px;",

          # Criterio 1: AICc
          tags$div(
            style = paste0("background:#fff; border-radius:8px; padding:16px 18px;",
                           "box-shadow:0 1px 4px rgba(0,0,0,0.06);",
                           "border-top:3px solid #1A3A5C;"),
            tags$p(style = "margin:0 0 6px; font-size:0.72rem; font-weight:700;
                            text-transform:uppercase; letter-spacing:0.8px; color:#1A3A5C;",
                   "① Criterio de selección — AICc"),
            tags$p(style = "margin:0; font-size:0.85rem; line-height:1.6; color:#333;",
              "Con n = 19 observaciones, el AICc penaliza la complejidad ajustada por tamaño muestral.",
              " El ARIMA obtuvo el valor más bajo con un único parámetro, logrando el mejor",
              " equilibrio entre ajuste y parsimonia."
            )
          ),

          # Criterio 2: Comparación modelos
          tags$div(
            style = paste0("background:#fff; border-radius:8px; padding:16px 18px;",
                           "box-shadow:0 1px 4px rgba(0,0,0,0.06);",
                           "border-top:3px solid #457B9D;"),
            tags$p(style = "margin:0 0 6px; font-size:0.72rem; font-weight:700;
                            text-transform:uppercase; letter-spacing:0.8px; color:#457B9D;",
                   "② Comparación con modelos rivales"),
            tags$p(style = "margin:0; font-size:0.85rem; line-height:1.6; color:#333;",
              "ETS(M,A,N): ΔAICc = 7.41 — evidencia fuerte en contra (Burnham & Anderson, 2002).",
              " Holt lineal: ΔAICc = 11.65. Holt amortiguado: ΔAICc = 17.96.",
              " Ninguno supera al ARIMA en parsimonia."
            )
          ),

          # Criterio 3: Validez residuos
          tags$div(
            style = paste0("background:#fff; border-radius:8px; padding:16px 18px;",
                           "box-shadow:0 1px 4px rgba(0,0,0,0.06);",
                           "border-top:3px solid #1e8449;"),
            tags$p(style = "margin:0 0 6px; font-size:0.72rem; font-weight:700;
                            text-transform:uppercase; letter-spacing:0.8px; color:#1e8449;",
                   "③ Validez estadística — Residuos"),
            tags$p(style = "margin:0; font-size:0.85rem; line-height:1.6; color:#333;",
              "Ljung-Box: Q* = 6.39, p = 0.172 — sin autocorrelación significativa.",
              " La diferenciación I(1) elimina la raíz unitaria (ADF confirmado).",
              " El drift β = 3.24 pts/año captura el crecimiento desde 2014 (sección 9.1.1)."
            )
          ),

          # Criterio 4: Exclusión regresión
          tags$div(
            style = paste0("background:#fff; border-radius:8px; padding:16px 18px;",
                           "box-shadow:0 1px 4px rgba(0,0,0,0.06);",
                           "border-top:3px solid #c0392b;"),
            tags$p(style = "margin:0 0 6px; font-size:0.72rem; font-weight:700;
                            text-transform:uppercase; letter-spacing:0.8px; color:#c0392b;",
                   "④ Exclusión — Regresión Lineal"),
            tags$p(style = "margin:0; font-size:0.85rem; line-height:1.6; color:#333;",
              "Descartada por razones metodológicas: serie no estacionaria (ADF: p = 0.511).",
              " OLS sobre series I(1) produce intervalos de predicción inválidos",
              " (Granger & Newbold, 1974), no por rendimiento sino por supuesto violado."
            )
          )
        ),

        # ── Conclusión proyectiva ─────────────────────────────────────────────
        tags$div(
          style = paste0(
            "background: #eef4fb;",
            "border-left: 4px solid #1A3A5C;",
            "border-radius: 0 6px 6px 0;",
            "padding: 12px 18px;",
            "font-size: 0.85rem; line-height: 1.65; color: #1A3A5C;"
          ),
          tags$strong("Proyección: "),
          "El modelo sugiere que la tasa de Unintentional Injuries en West Virginia continuará",
          " aumentando hacia 2022, profundizando la brecha con el promedio nacional (sección 9.3)",
          " y reforzando la necesidad de intervención prioritaria en salud pública."
        )
      )
    )
  )
}

# ── SERVER ────────────────────────────────────────────────────────────────────
tab_comparacionServer <- function(id, ts_wv_acc, serie_wv_acc) {
  moduleServer(id, function(input, output, session) {

    # ── Modelos ─────────────────────────────────────────────────────────────
    modelos <- reactive({
      ts_ <- ts_wv_acc()
      list(
        arima  = auto.arima(ts_, stepwise = FALSE, approximation = FALSE, trace = FALSE),
        ets    = ets(ts_),
        holt   = ets(ts_, model = "AAN"),
        holtd  = ets(ts_, model = "AAN", damped = TRUE)
      )
    })

    # Banner ganador — mod-header con KPI chips integrados
    output$banner_ganador <- renderUI({
      mod    <- modelos()$arima
      aicc_v <- round(mod$aicc, 2)
      bic_v  <- round(BIC(mod), 2)
      drift_v <- round(mod$coef[1], 3)

      # Chip helper — paleta neutra, valores en blanco
      chip <- function(label, value) {
        tags$div(
          style = paste0(
            "background:rgba(255,255,255,0.10); border:1px solid rgba(255,255,255,0.20);",
            "border-radius:6px; padding:8px 14px; min-width:100px; text-align:center;"
          ),
          tags$div(style = "font-size:0.62rem; text-transform:uppercase; letter-spacing:0.8px;
                             color:rgba(255,255,255,0.6); margin-bottom:3px;", label),
          tags$div(style = "font-size:1.1rem; font-weight:800; color:#fff; font-family:monospace;",
                   value)
        )
      }

      tags$div(
        class = "mod-header",
        style = "background:linear-gradient(135deg,#0f2340 0%,#1D3557 60%,#2a4a72 100%);
                 margin-bottom:16px;",

        tags$span(class = "mod-badge",
                  "Comparación de Modelos y Selección Final — Secciones 15–16"),

        tags$div(
          style = "display:flex; align-items:center; gap:24px; flex-wrap:wrap;",

          # Lado izquierdo: título + subtítulo
          tags$div(
            style = "flex:1; min-width:260px;",
            tags$h3(
              style = "margin:0 0 6px 0; font-size:1.15rem; font-weight:800; color:#fff;",
              tags$span(style = "margin-right:8px;", "🏆"),
              tags$span(style = "font-family:monospace;", as.character(mod))
            ),
            tags$p(
              style = "margin:0; font-size:0.80rem; color:rgba(255,255,255,0.72); line-height:1.5;",
              "Evaluación sistemática de ARIMA, ETS, Holt, Holt amortiguado, Naive y Regresión Lineal",
              " mediante criterios de información, diagnóstico de residuos y validación cruzada."
            )
          ),

          # Chips KPI — todos en blanco, sin arcoíris
          tags$div(
            style = "display:flex; gap:8px; flex-wrap:wrap; align-items:center;",
            chip("AICc",        as.character(aicc_v)),
            chip("BIC",         as.character(bic_v)),
            chip("Ljung-Box p", "0.172"),
            chip("Drift \u03b2", paste0("+", drift_v, " pts/a\u00f1o"))
          )
        )
      )
    })

    # 15.1 Tabla AIC
    output$tbl_aic <- renderDT({
      m <- modelos()
      df <- data.frame(
        Modelo      = c("ARIMA(0,1,0) with drift",
                        paste0("ETS – ", m$ets$method),
                        "Holt lineal – ETS(A,A,N)",
                        "Holt amortiguado – ETS(A,Ad,N)"),
        Parámetros  = c(1, length(m$ets$par), length(m$holt$par), length(m$holtd$par)),
        AIC         = round(c(AIC(m$arima), AIC(m$ets), AIC(m$holt), AIC(m$holtd)), 2),
        AICc        = round(c(m$arima$aicc, m$ets$aicc, m$holt$aicc, m$holtd$aicc), 2),
        BIC         = round(c(BIC(m$arima), BIC(m$ets), BIC(m$holt), BIC(m$holtd)), 2),
        check.names = FALSE
      )
      mejor <- which.min(df$AICc)
      datatable(df, options = list(dom = "t", paging = FALSE, searching = FALSE,
                                   order = list(list(3, "asc"))),
                rownames = FALSE) %>%
        formatStyle("AICc", fontWeight = "bold") %>%
        formatStyle("Modelo",
          target     = "row",
          fontWeight = styleEqual(df$Modelo[mejor], "bold"),
          background = styleEqual(df$Modelo[mejor], "#eaf4fb"))
    })

    # 15.2 Ljung-Box
    output$tbl_ljung <- renderDT({
      m    <- modelos()
      ts_  <- ts_wv_acc()
      s_   <- serie_wv_acc()
      t_   <- seq_along(s_)
      df_m <- data.frame(y = s_, t = t_)
      lm_  <- lm(y ~ t, data = df_m)

      lb <- function(mod_resid) {
        Box.test(residuals(mod_resid), lag = 4, type = "Ljung-Box")
      }
      lb_lm_res <- ts(residuals(lm_), start = 1999, frequency = 1)
      lb_lm  <- Box.test(lb_lm_res, lag = 4, type = "Ljung-Box")

      resultados <- lapply(list(m$arima, m$ets, m$holt, m$holtd), lb)
      nombres    <- c("ARIMA(0,1,0) with drift",
                      paste0("ETS – ", m$ets$method),
                      "Holt lineal",
                      "Holt amortiguado",
                      "Regresión lineal")

      pvals <- c(sapply(resultados, function(x) round(x$p.value, 4)),
                 round(lb_lm$p.value, 4))
      qvals <- c(sapply(resultados, function(x) round(x$statistic, 3)),
                 round(lb_lm$statistic, 3))

      df <- data.frame(
        Modelo      = nombres,
        `Q*`        = qvals,
        `p-valor`   = pvals,
        Diagnóstico = ifelse(pvals > 0.05, "✅ Ruido blanco", "⚠️ Autocorrelación"),
        check.names = FALSE
      )
      filas_ok <- which(df$`p-valor` > 0.05)
      datatable(df, options = list(dom = "t", paging = FALSE, searching = FALSE),
                rownames = FALSE) %>%
        formatStyle("Diagnóstico",
          color = styleEqual(c("✅ Ruido blanco", "⚠️ Autocorrelación"),
                             c("#1e8449", "#e74c3c"))) %>%
        formatStyle("Modelo",
          target     = "row",
          background = styleEqual(df$Modelo[filas_ok],
                                  rep("#f0fff4", length(filas_ok))))
    })

    # 15.3 tsCV
    output$tbl_cv <- renderDT({
      withProgress(message = "Calculando validación cruzada…", value = 0.5, {
        ts_ <- ts_wv_acc()
        s_  <- serie_wv_acc()

        f_arima  <- function(y, h) forecast(auto.arima(y, stepwise = TRUE, approximation = TRUE), h = h)
        f_ets    <- function(y, h) forecast(ets(y), h = h)
        f_holt   <- function(y, h) holt(y, h = h)
        f_holtd  <- function(y, h) holt(y, h = h, damped = TRUE)
        f_naive  <- function(y, h) rwf(y, h = h, drift = TRUE)
        f_lm     <- function(y, h) {
          n_ <- length(y); t_ <- 1:n_
          fit_ <- lm(y ~ t_)
          pred_ <- predict(fit_, newdata = data.frame(t_ = (n_ + 1):(n_ + h)))
          structure(list(mean = ts(pred_, start = tsp(y)[2] + 1 / tsp(y)[3],
                                   frequency = tsp(y)[3])), class = "forecast")
        }

        cv_rmse <- function(e) round(sqrt(mean(e^2, na.rm = TRUE)), 3)
        cv_mae  <- function(e) round(mean(abs(e),   na.rm = TRUE),  3)

        e1_a <- tsCV(ts_, f_arima,  h = 1); e3_a <- tsCV(ts_, f_arima,  h = 3)
        e1_e <- tsCV(ts_, f_ets,    h = 1); e3_e <- tsCV(ts_, f_ets,    h = 3)
        e1_h <- tsCV(ts_, f_holt,   h = 1); e3_h <- tsCV(ts_, f_holt,   h = 3)
        e1_d <- tsCV(ts_, f_holtd,  h = 1); e3_d <- tsCV(ts_, f_holtd,  h = 3)
        e1_n <- tsCV(ts_, f_naive,  h = 1); e3_n <- tsCV(ts_, f_naive,  h = 3)
        e1_l <- tsCV(ts_, f_lm,     h = 1); e3_l <- tsCV(ts_, f_lm,     h = 3)

        m <- modelos()
        nombres <- c("ARIMA(0,1,0) with drift",
                     paste0("ETS – ", m$ets$method),
                     "Holt lineal",
                     "Holt amortiguado",
                     "Naive with drift",
                     "Regresión lineal")

        df <- data.frame(
          Modelo      = nombres,
          `RMSE h=1`  = c(cv_rmse(e1_a), cv_rmse(e1_e), cv_rmse(e1_h),
                           cv_rmse(e1_d), cv_rmse(e1_n), cv_rmse(e1_l)),
          `MAE h=1`   = c(cv_mae(e1_a),  cv_mae(e1_e),  cv_mae(e1_h),
                           cv_mae(e1_d),  cv_mae(e1_n),  cv_mae(e1_l)),
          `RMSE h=3`  = c(cv_rmse(e3_a), cv_rmse(e3_e), cv_rmse(e3_h),
                           cv_rmse(e3_d), cv_rmse(e3_n), cv_rmse(e3_l)),
          `MAE h=3`   = c(cv_mae(e3_a),  cv_mae(e3_e),  cv_mae(e3_h),
                           cv_mae(e3_d),  cv_mae(e3_n),  cv_mae(e3_l)),
          check.names = FALSE
        )

        mejor_h1 <- which.min(df$`RMSE h=1`)
        datatable(df, options = list(dom = "t", paging = FALSE, searching = FALSE),
                  rownames = FALSE) %>%
          formatStyle("RMSE h=1", fontWeight = "bold") %>%
          formatStyle("Modelo",
            target     = "row",
            background = styleEqual(df$Modelo[mejor_h1], "#eaf4fb"),
            fontWeight = styleEqual(df$Modelo[mejor_h1], "bold"))
      })
    })

    # 15.4 Gráfico comparativo
    output$plot_comparacion <- renderPlotly({
      ts_  <- ts_wv_acc()
      s_   <- serie_wv_acc()
      m    <- modelos()

      df_m <- data.frame(y = s_, t = seq_along(s_))
      lm_  <- lm(y ~ t, data = df_m)
      t_new <- data.frame(t = (length(s_) + 1):(length(s_) + 5))

      preds <- list(
        "ARIMA(0,1,0) drift" = as.numeric(forecast(m$arima, h = 5)$mean),
        "ETS"                = as.numeric(forecast(m$ets,   h = 5)$mean),
        "Holt lineal"        = as.numeric(forecast(m$holt,  h = 5)$mean),
        "Holt amortiguado"   = as.numeric(forecast(m$holtd, h = 5)$mean),
        "Naive drift"        = as.numeric(rwf(ts_, h = 5, drift = TRUE)$mean),
        "Reg. lineal"        = as.numeric(predict(lm_, newdata = t_new))
      )

      colores <- c("ARIMA(0,1,0) drift" = "#1D3557",
                   "ETS"                = "#E63946",
                   "Holt lineal"        = "#2A9D8F",
                   "Holt amortiguado"   = "#F4A261",
                   "Naive drift"        = "#9B2226",
                   "Reg. lineal"        = "#6A4C93")

      df_hist <- data.frame(anio = 1999:2017, valor = s_)

      p <- plot_ly() %>%
        add_lines(data = df_hist, x = ~anio, y = ~valor,
                  name = "Histórico", line = list(color = "black", width = 2.5)) %>%
        add_markers(data = df_hist, x = ~anio, y = ~valor,
                    marker = list(color = "black", size = 4), showlegend = FALSE)

      for (nm in names(preds)) {
        df_fc <- data.frame(anio = 2018:2022, valor = preds[[nm]])
        p <- p %>%
          add_lines(data = df_fc, x = ~anio, y = ~valor, name = nm,
                    line = list(color = colores[nm], width = 2, dash = "dash")) %>%
          add_markers(data = df_fc, x = ~anio, y = ~valor, name = nm,
                      marker = list(color = colores[nm], size = 6, symbol = "triangle-up"),
                      showlegend = FALSE)
      }

      p %>% plotly::layout(
        title  = list(text = "<b>Comparación de proyecciones — Unintentional Injuries · West Virginia</b>",
                      font = list(size = 12, color = "#1A3A5C")),
        xaxis  = list(title = "Año", tickmode = "linear", dtick = 2),
        yaxis  = list(title = "Tasa ajustada por 100,000 hab."),
        shapes = list(list(
          type = "line", x0 = 2017.5, x1 = 2017.5, y0 = 0, y1 = 1, yref = "paper",
          line = list(color = "gray", dash = "dot", width = 1.5)
        )),
        legend        = list(orientation = "h", x = 0, y = -0.18, font = list(size = 10)),
        hovermode     = "x unified",
        plot_bgcolor  = "rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)",
        font = list(family = "Segoe UI, Arial, sans-serif", size = 11)
      )
    })

  })
}

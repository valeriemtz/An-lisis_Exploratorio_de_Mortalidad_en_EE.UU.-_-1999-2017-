# ============================================================
# app.R — Archivo principal
# Mortalidad EE.UU. 1999-2017
# Autores: Valerie M. y Luis C. · 2026-03-01
# ============================================================

source("global.R")

# Constante de estilo compartida (usada en tabs ETS, Regresión y Comparación)
# Debe definirse ANTES de los source() de tabs que la usan
kpi_label_style <- "margin:0 0 4px; font-size:0.75rem; color:#666;
                     font-weight:600; text-transform:uppercase; letter-spacing:1px;"

source("tabs/tab_introduccion.R")
source("tabs/tab_contexto.R")
source("tabs/tab_metodologia.R")
source("tabs/tab_evolucion.R")
source("tabs/tab_ranking.R")
source("tabs/tab_desesperacion.R")
source("tabs/tab_geografico.R")
source("tabs/tab_westvirginia.R")
source("tabs/tab_arima_metricas.R")
source("tabs/tab_intro_modelos.R")
source("tabs/tab_ets.R")              
source("tabs/tab_regresion.R")        
source("tabs/tab_comparacion.R")      
source("tabs/tab_limitaciones.R")
source("tabs/tab_conclusiones.R")

# ============================================================
# UI
# ============================================================

ui <- bs4DashPage(
  title      = "Mortalidad EE.UU. 1999-2017",
  freshTheme = NULL,

  header = bs4DashNavbar(
    skin = "dark", status = "white", border = TRUE,
    sidebarIcon = icon("bars"),
    title = bs4DashBrand(
      title = tags$span(
        tags$span(
          style = "font-weight:800; font-size:0.88rem;
                   letter-spacing:0.3px; color:#fff;",
          "Mortalidad EE.UU. 1999\u20132017"
        ),
        tags$br(),
        tags$span(
          class = "autores-subtitulo",
          "Valerie M. & Luis C. \u00b7 2026-03-01"
        )
      ),
      href = "#", color = "primary", image = NULL
    )
  ),

  sidebar = bs4DashSidebar(
    skin = "dark", status = "primary",
    collapsed = FALSE, minified = FALSE,
    bs4SidebarMenu(
      id = "menu_principal",

      bs4SidebarMenuItem("Introducci\u00f3n",    tabName = "introduccion",  icon = icon("house")),
      bs4SidebarMenuItem("Marco Te\u00f3rico",   tabName = "contexto",      icon = icon("book")),
      bs4SidebarMenuItem("Metodolog\u00eda",     tabName = "metodologia",   icon = icon("gear")),

      tags$li(
        class = "nav-header",
        style = "padding:6px 14px; font-size:0.7rem;
                 color:rgba(255,255,255,0.4); letter-spacing:1px;
                 text-transform:uppercase; margin-top:8px;",
        "An\u00e1lisis Exploratorio"
      ),

      bs4SidebarMenuItem("Evoluci\u00f3n de Tasas",       tabName = "evolucion",     icon = icon("chart-line")),
      bs4SidebarMenuItem("Ranking por A\u00f1o",          tabName = "ranking",       icon = icon("list-ol")),
      bs4SidebarMenuItem("Deaths of Despair",              tabName = "desesperacion", icon = icon("triangle-exclamation")),
      bs4SidebarMenuItem("An\u00e1lisis Geogr\u00e1fico", tabName = "geografico",   icon = icon("map")),
      bs4SidebarMenuItem("Caso: West Virginia",            tabName = "westvirginia",  icon = icon("magnifying-glass")),

      bs4SidebarMenuItem("M\u00e9tricas de Modelos", tabName = "arima_metricas", icon = icon("chart-bar")),

      # ── Modelos Adicionales ──────────────────────────────
      tags$li(
        class = "nav-header",
        style = "padding:6px 14px; font-size:0.7rem;
                 color:rgba(255,255,255,0.4); letter-spacing:1px;
                 text-transform:uppercase; margin-top:8px;",
        "Modelos Adicionales"
      ),

      bs4SidebarMenuItem("Modelos Adicionales", tabName = "intro_modelos", icon = icon("layer-group")),

      bs4SidebarMenuItem("Modelo ETS",              tabName = "ets",          icon = icon("wave-square")),
      bs4SidebarMenuItem("Regresi\u00f3n Lineal",  tabName = "regresion",    icon = icon("ruler")),
      bs4SidebarMenuItem("Comparaci\u00f3n",       tabName = "comparacion",  icon = icon("scale-balanced")),

      # ── Cierre ──────────────────────────────────────────
      tags$li(
        class = "nav-header",
        style = "padding:6px 14px; font-size:0.7rem;
                 color:rgba(255,255,255,0.4); letter-spacing:1px;
                 text-transform:uppercase; margin-top:8px;",
        "Cierre"
      ),

      bs4SidebarMenuItem("Limitaciones", tabName = "limitaciones", icon = icon("circle-exclamation")),
      bs4SidebarMenuItem("Conclusiones", tabName = "conclusiones", icon = icon("flag-checkered")),

      tags$li(style = "padding-bottom:16px;")
    )
  ),

  body = bs4DashBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
      tags$style(HTML("
        .content { padding: 20px !important; }
        .tab-content > .tab-pane { padding: 0 !important; }
        .card { background-color: #ffffff !important; }
        .btn:focus { box-shadow: none !important; }
      "))
    ),
    bs4TabItems(
      bs4TabItem(tabName = "introduccion",     tab_introduccionUI("mod_intro")),
      bs4TabItem(tabName = "contexto",         tab_contextoUI("mod_contexto")),
      bs4TabItem(tabName = "metodologia",      tab_metodologiaUI("mod_met")),
      bs4TabItem(tabName = "evolucion",        tab_evolucionUI("mod_evol")),
      bs4TabItem(tabName = "ranking",          tab_rankingUI("mod_rank")),
      bs4TabItem(tabName = "desesperacion",    tab_desesperacionUI("mod_desp")),
      bs4TabItem(tabName = "geografico",       tab_geograficoUI("mod_geo")),
      bs4TabItem(tabName = "westvirginia",     tab_westvirginiaUI("mod_wv")),
      bs4TabItem(tabName = "arima_metricas",   tab_arima_metricasUI("mod_arima_met")),
      bs4TabItem(tabName = "intro_modelos",  tab_intro_modelosUI("mod_intro_mod")),
      bs4TabItem(tabName = "ets",            tab_etsUI("mod_ets")),
      bs4TabItem(tabName = "regresion",      tab_regresionUI("mod_reg")),
      bs4TabItem(tabName = "comparacion",    tab_comparacionUI("mod_comp")),
      bs4TabItem(tabName = "limitaciones",     tab_limitacionesUI("mod_lim")),
      bs4TabItem(tabName = "conclusiones",     tab_conclusionesUI("mod_conc"))
    )
  ),

  footer = bs4DashFooter(
    left = tags$span(
      style = "font-size:0.78rem; color:#888;",
      icon("database"),
      " Fuente: CDC/NCHS/NVSS \u2014 NCHS Leading Causes of Death: United States"
    ),
    right = tags$span(
      style = "font-size:0.78rem; color:#888;",
      "Valerie M. & Luis C. \u00b7 2026"
    )
  )
)

# ============================================================
# SERVER
# ============================================================
server <- function(input, output, session) {
  # ── Series compartidas: Unintentional Injuries WV ────
  serie_wv_acc_r <- reactive({
    datos_estados %>%
      dplyr::filter(state == "West Virginia",
                    cause_name == "Unintentional injuries",
                    !is.na(age_adjusted_death_rate)) %>%
      dplyr::arrange(year) %>%
      dplyr::pull(age_adjusted_death_rate)
  })
  ts_wv_acc_r <- reactive({ ts(serie_wv_acc_r(), start = 1999, frequency = 1) })

  tab_introduccionServer ("mod_intro",       datos_us, datos_estados)
  tab_contextoServer     ("mod_contexto",    datos_us, datos_estados)
  tab_metodologiaServer  ("mod_met",         datos_us, datos_estados)
  tab_evolucionServer    ("mod_evol",        datos_us, datos_estados)
  tab_rankingServer      ("mod_rank",        datos_us, datos_estados)
  tab_desesperacionServer("mod_desp",        datos_us, datos_estados)
  tab_geograficoServer   ("mod_geo",         datos_us, datos_estados)
  tab_westvirginiaServer ("mod_wv",          datos_us, datos_estados)
  tab_arima_metricasServer  ("mod_arima_met",  datos_us, datos_estados)
  tab_intro_modelosServer("mod_intro_mod", parent_session = session)
  tab_etsServer         ("mod_ets",  ts_wv_acc = ts_wv_acc_r, serie_wv_acc = serie_wv_acc_r)
  tab_regresionServer   ("mod_reg",  ts_wv_acc = ts_wv_acc_r, serie_wv_acc = serie_wv_acc_r)
  tab_comparacionServer ("mod_comp", ts_wv_acc = ts_wv_acc_r, serie_wv_acc = serie_wv_acc_r)
  tab_limitacionesServer ("mod_lim",         datos_us, datos_estados)
  tab_conclusionesServer ("mod_conc",        datos_us, datos_estados)
}

shinyApp(ui = ui, server = server)

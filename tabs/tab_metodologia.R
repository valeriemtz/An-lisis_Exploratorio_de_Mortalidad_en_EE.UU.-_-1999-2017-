tab_metodologiaUI <- function(id) {
  ns <- NS(id)

  tagList(
    tags$style(HTML("
      .card-header { background-color: #1A3A5C !important; color: white !important; }
      .met-parrafo { font-size: 0.92rem; color: #333; line-height: 1.7; margin-bottom: 10px; }
      .met-lista   { font-size: 0.91rem; color: #333; line-height: 1.8; padding-left: 18px; }
    ")),

    tags$div(class = "section-header", "Metodologia del Analisis"),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("microscope"), " 3.1 - Dise\u00f1o del Estudio"),
      status = "navy", solidHeader = TRUE,
      tags$p(class = "met-parrafo",
        "El presente estudio corresponde a un ",
        tags$strong("an\u00e1lisis exploratorio de datos (EDA) de corte longitudinal"),
        ", basado en registros administrativos de mortalidad en Estados Unidos
         durante el periodo 1999-2017. El enfoque metodol\u00f3gico combina
         estad\u00edstica descriptiva, an\u00e1lisis de series de tiempo, clustering
         y modelado predictivo, con el objetivo de ",
        tags$strong("examinar c\u00f3mo han evolucionado las principales causas de muerte
         a nivel nacional entre 1999 y 2017"),
        ", identificar las disparidades geogr\u00e1ficas persistentes entre estados,
         visualizar los cambios en el ranking de causas a lo largo del tiempo, y
         profundizar en el caso de West Virginia \u2014 el estado con la tasa de mortalidad
         ajustada m\u00e1s alta del pa\u00eds en 2017 \u2014 mediante un an\u00e1lisis de clustering
         K-Means y un modelo predictivo ARIMA que proyecta su trayectoria hacia 2022."
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("database"), " 3.2 - Fuente de Datos y Preprocesamiento"),
      status = "navy", solidHeader = TRUE,
      tags$p(class = "met-parrafo",
        "Los datos provienen del dataset ",
        tags$em("NCHS - Leading Causes of Death: United States"),
        ", publicado por los Centers for Disease Control and Prevention (CDC).
         El conjunto contiene registros anuales de mortalidad por causa y estado,
         incluyendo la ", tags$strong("tasa ajustada por edad"),
        " (age-adjusted death rate), que estandariza las tasas eliminando el efecto
         de diferencias en la estructura etaria entre poblaciones, permitiendo
         comparaciones validas entre estados y anios."
      ),
      tags$p(class = "met-parrafo",
        "El preprocesamiento incluyo estandarizacion de nombres de variables,
         correccion de formatos numericos inconsistentes (formato europeo con
         punto de miles y coma decimal), conversion de tipos de datos y
         filtrado del periodo 1999-2017."
      ),
      lapply(1:7, function(i) {
        pasos <- c(
          "Lectura del CSV con col_types = col_character() para preservar formato original",
          "Limpieza y estandarizacion de nombres con janitor::clean_names()",
          "Correccion de formatos: gsub() para eliminar puntos de miles y convertir coma decimal a punto",
          "Conversion de tipos: as.numeric() para muertes y tasa ajustada; as.integer() para anio",
          "Filtro temporal: se conservan solo registros con 1999 <= anio <= 2017",
          "Separacion de subconjuntos: datos_us (United States) y datos_estados (50 estados + DC)",
          "Exclusion de 'All causes' en analisis por causa especifica para evitar doble conteo"
        )
        tags$div(class = "pipeline-step",
                 tags$div(class = "step-num", i),
                 tags$span(pasos[i]))
      })
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("chart-bar"), " 3.3 - Estadistica Descriptiva"),
      status = "navy", solidHeader = TRUE,
      tags$p(class = "met-parrafo",
        "Se construyeron ", tags$strong("diagramas de barras comparativos"),
        " para analizar la distribucion porcentual de las causas de muerte entre
         1999 y 2017, y ", tags$strong("graficos de lineas"),
        " para identificar la evolucion temporal de las tasas ajustadas por causa
         a nivel nacional. Estas visualizaciones permiten detectar tendencias,
         cambios en el ranking de causas y variaciones en la carga relativa de
         cada enfermedad a lo largo del periodo."
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("wave-square"), " 3.4 - Analisis de Series de Tiempo"),
      status = "navy", solidHeader = TRUE,
      tags$p(class = "met-parrafo",
        "Se aplicaron las siguientes tecnicas para evaluar el comportamiento
         temporal de las series de mortalidad:"
      ),
      tags$ul(class = "met-lista",
        tags$li(tags$strong("Prueba ADF (Dickey-Fuller Aumentada): "),
          "evalua la estacionariedad de las series. La hipotesis nula establece
           que la serie tiene raiz unitaria (no estacionaria). Un valor p < 0.05
           indica estacionariedad, requisito para aplicar modelos ARIMA."),
        tags$li(tags$strong("ACF y PACF: "),
          "funciones de autocorrelacion y autocorrelacion parcial para identificar
           patrones de dependencia temporal y orientar la seleccion de parametros
           del modelo.")
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("map"), " 3.5 - Analisis Geografico"),
      status = "navy", solidHeader = TRUE,
      tags$p(class = "met-parrafo",
        "Se calcularon tasas ajustadas promedio por estado para identificar
         disparidades territoriales. Se construyeron ",
        tags$strong("mapas coropleticos interactivos"),
        " con leaflet y visualizaciones comparativas de los estados con mayor
         y menor carga de mortalidad, consistente con el gradiente geografico
         documentado en la literatura."
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("circle-nodes"), " 3.6 - Clustering K-Means"),
      status = "navy", solidHeader = TRUE,
      tags$p(class = "met-parrafo",
        "Para identificar grupos de estados con perfiles de mortalidad similares
         se aplico ", tags$strong("K-Means"),
        ", algoritmo de aprendizaje no supervisado que agrupa observaciones
         minimizando la inercia intra-cluster. Las variables de agrupamiento
         fueron las tasas ajustadas por causa en 2017. Los pasos fueron:"
      ),
      tags$ol(class = "met-lista",
        tags$li(tags$strong("Estandarizacion "),
          "de variables (media 0, desviacion estandar 1) para evitar que causas
           con tasas mas altas dominen el agrupamiento."),
        tags$li(tags$strong("Metodo del codo "),
          "para determinar el numero optimo de clusters (k=4), evaluando la
           reduccion de inercia para k = 1 a 10."),
        tags$li(tags$strong("Visualizacion PCA "),
          "para representar en dos dimensiones la separacion entre clusters,
           donde PC1 y PC2 capturan la mayor varianza posible del espacio
           multidimensional original.")
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("brain"), " 3.7 - Modelo Predictivo ARIMA"),
      status = "navy", solidHeader = TRUE,
      tags$p(class = "met-parrafo",
        "Para proyectar tendencias futuras se implemento un modelo ",
        tags$strong("ARIMA(p,d,q)"),
        ", definido por tres parametros: el orden autoregresivo (p), el grado
         de diferenciacion (d) y el orden de media movil (q). La seleccion de
         parametros optimos se realizo mediante el ",
        tags$strong("criterio de informacion de Akaike (AIC)"),
        ". La validacion se realizo mediante analisis de residuos y la ",
        tags$strong("prueba de Ljung-Box"),
        ", cuya hipotesis nula establece independencia de los residuos -
         un p-value > 0.05 confirma que el modelo no dejo estructura sin capturar.
         Las proyecciones cubren el horizonte 2018-2022 para West Virginia."
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("gears"), " 3.8 - Herramientas y Librerias"),
      status = "navy", solidHeader = TRUE,
      tags$p(class = "met-parrafo",
        "El analisis se realizo en ", tags$strong("R (version 4.4.1)"),
        " y RStudio. Los paquetes principales utilizados:"
      ),
      tags$div(
        tags$table(class = "pkg-table",
          tags$thead(tags$tr(tags$th("Paquete"), tags$th("Funcion en el analisis"))),
          tags$tbody(
            tags$tr(tags$td(tags$code("tidyverse")),    tags$td("Manipulacion y visualizacion de datos")),
            tags$tr(tags$td(tags$code("forecast")),     tags$td("Modelos ARIMA y proyecciones")),
            tags$tr(tags$td(tags$code("tseries")),      tags$td("Prueba ADF de estacionariedad")),
            tags$tr(tags$td(tags$code("janitor")),      tags$td("Limpieza y estandarizacion de nombres")),
            tags$tr(tags$td(tags$code("RColorBrewer")), tags$td("Paletas de colores accesibles")),
            tags$tr(tags$td(tags$code("scales")),       tags$td("Formateo de ejes y etiquetas numericas")),
            tags$tr(tags$td(tags$code("leaflet")),      tags$td("Mapas interactivos con zoom y popups")),
            tags$tr(tags$td(tags$code("tigris")),       tags$td("Datos geoespaciales vectoriales de EE.UU.")),
            tags$tr(tags$td(tags$code("sf")),           tags$td("Operaciones con geometrias espaciales")),
            tags$tr(tags$td(tags$code("ggrepel")),      tags$td("Etiquetas sin solapamiento en graficos PCA")),
            tags$tr(tags$td(tags$code("kableExtra")),   tags$td("Tablas formateadas en el informe"))
          )
        )
      )
    ),

    bs4Card(
      width = 12, collapsible = FALSE,
      title = tags$span(icon("table"), " Variables del Dataset"),
      status = "navy", solidHeader = TRUE,
      DTOutput(ns("tabla_vars_met"))
    )
  )
}

tab_metodologiaServer <- function(id, datos_us, datos_estados) {
  moduleServer(id, function(input, output, session) {
    output$tabla_vars_met <- renderDT({
      data.frame(
        "Variable original"  = c("Year", "113 Cause Name", "Cause Name", "State", "Deaths", "Age-adjusted Death Rate"),
        "Nombre en analisis" = c("year", "causa_codigo", "cause_name", "state", "deaths", "age_adjusted_death_rate"),
        "Tipo"               = c("Entero", "Texto", "Texto", "Texto", "Entero", "Decimal"),
        "Descripcion"        = c(
          "Anio del registro",
          "Codigo ICD-10 de la causa",
          "Nombre descriptivo de la causa de muerte",
          "Estado de residencia del fallecido",
          "Numero absoluto de muertes",
          "Tasa de mortalidad ajustada por edad (por 100,000 hab.)"
        ),
        check.names = FALSE
      ) |> datatable(options = list(dom = "t", pageLength = 10, ordering = FALSE),
                     rownames = FALSE, class = "stripe hover")
    })
  })
}

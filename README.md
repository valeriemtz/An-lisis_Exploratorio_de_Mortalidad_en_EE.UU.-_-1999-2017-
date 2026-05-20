# NCHS Shiny Dashboard · Principales Causas de Muerte en Estados Unidos

Dashboard interactivo para el análisis exploratorio de datos de mortalidad en Estados Unidos (1999–2017), desarrollado con R y Shiny. Los datos provienen del **National Center for Health Statistics (NCHS)**, rama estadística del CDC.

🔗 **App desplegada:** https://8nv3b6-valerie-mart0nez.shinyapps.io/app_fix2/

---

## Contexto

Comprender las tendencias de mortalidad a largo plazo es fundamental para la política de salud pública, la investigación académica y la toma de decisiones basada en evidencia. Este dashboard permite explorar cómo han evolucionado las principales causas de muerte en EE.UU. a lo largo de casi dos décadas, identificar disparidades geográficas entre estados y analizar el fenómeno conocido como **Deaths of Despair** — el aumento sostenido de muertes por suicidio y lesiones no intencionales asociadas a la crisis de opioides.

---

## Cómo ejecutar la aplicación localmente

Todos los archivos necesarios se encuentran dentro de la carpeta `app/`. Asegúrate de tener R instalado en tu computador.

**1. (Opcional)** Instala las dependencias ejecutando el archivo de requisitos:

```r
source("requirements.R")
```

**2.** Abre `app.R` en RStudio y haz clic en **Run App**, o desde la consola:

```r
shiny::runApp("app")
```

**3.** Accede al dashboard en tu navegador:

```
http://localhost:3838/
```

> **Nota:** La primera vez que se ejecute, la app descargará automáticamente la geometría de los estados desde `tigris` si no existe el archivo `data/estados_sf.rds`. Esto puede tardar unos segundos.

---

## Estructura del proyecto

```
app/
├── app.R                  # Archivo principal (UI + Server)
├── global.R               # Carga de librerías, limpieza y preparación de datos
├── requirements.R         # Instalación de dependencias
├── data/
│   ├── NCHS_Leading_Causes.csv   # Dataset principal (NCHS/CDC)
│   └── estados_sf.rds            # Geometría de estados (caché tigris)
├── tabs/
│   ├── tab_introduccion.R
│   ├── tab_contexto.R
│   ├── tab_metodologia.R
│   ├── tab_evolucion.R
│   ├── tab_ranking.R
│   ├── tab_desesperacion.R
│   ├── tab_geografico.R
│   ├── tab_westvirginia.R
│   ├── tab_limitaciones.R
│   └── tab_conclusiones.R
└── www/
    └── custom.css         # Estilos personalizados
```

---

## Pestañas del Dashboard

| Pestaña | Contenido |
|---------|-----------|
| **Introducción** | Resumen general y métricas clave del análisis |
| **Marco Teórico** | Fundamentos conceptuales y clasificación ICD-10 |
| **Metodología** | Descripción del dataset, limpieza y decisiones analíticas |
| **Evolución de Tasas** | Series temporales interactivas por causa y estado (1999–2017) |
| **Ranking por Año** | Ranking animado de las 10 causas líderes con slider de año |
| **Deaths of Despair** | Análisis de suicidio y lesiones no intencionales (crisis de opioides) |
| **Análisis Geográfico** | Mapa coroplético interactivo de mortalidad por estado |
| **Caso: West Virginia** | Estudio de caso del estado más afectado por la crisis de opioides |
| **Limitaciones** | Alcance metodológico, advertencias e interpretación de los datos |
| **Conclusiones** | Hallazgos principales e implicaciones de política pública |

---

## Datos

- **Fuente:** National Center for Health Statistics (NCHS) / Centers for Disease Control and Prevention (CDC)
- **Período:** 1999–2017
- **Cobertura:** 50 estados + Distrito de Columbia + total nacional
- **Causas:** 10 principales causas de muerte + All causes (clasificación ICD-10)
- **Métrica:** Tasa de mortalidad ajustada por edad por cada 100,000 habitantes (estandarizada a la población de EE.UU. del año 2000)

---

## Tecnologías utilizadas

- **R** — lenguaje principal
- **Shiny** — framework para aplicaciones web interactivas
- **bs4Dash** — layout y componentes de interfaz (Bootstrap 4)
- **Plotly** — visualizaciones interactivas
- **Leaflet** — mapas interactivos
- **tidyverse** — procesamiento y transformación de datos
- **sf / tigris** — datos geoespaciales de estados
- **forecast** — modelos de series temporales (ARIMA)

---

## Equipo

Este proyecto fue desarrollado por:

- **Valerie Martinez.** — [GitHub](https://github.com/valeriemtz)
- **Luis Cantillo** — [GitHub](https://github.com/cantluis1)

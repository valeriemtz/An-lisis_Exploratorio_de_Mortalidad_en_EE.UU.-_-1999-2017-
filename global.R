# ============================================================
# global.R  — limpieza y preparacion de datos
# ============================================================

library(shiny)
library(bs4Dash)
library(tidyverse)
library(janitor)
library(plotly)
library(leaflet)
library(sf)
library(tigris)
library(viridis)
library(scales)
library(RColorBrewer)
library(DT)
library(htmltools)
library(htmlwidgets)
library(fresh)
library(forecast)
library(tseries)
library(purrr)      # <- AGREGADO: necesario para map_dfr en tabs ARIMA

options(tigris_use_cache = TRUE)
options(dplyr.summarise.inform = FALSE)

COLORES <- list(
  azul_marino = "#1a3a5c",
  azul_medio  = "#2471a3",
  azul_claro  = "#85c1e9",
  rojo        = "#e74c3c",
  naranja     = "#e67e22",
  verde       = "#1e8449",
  morado      = "#7d3c98",
  gris_fondo  = "#f4f6f9",
  gris_texto  = "#4a4a4a",
  blanco      = "#ffffff"
)

# ── Helpers de parseo ──────────────────────────────────────────────────────────
parse_deaths <- function(x) {
  as.numeric(gsub("\\.", "", as.character(x)))
}

parse_rate <- function(x) {
  x <- as.character(x)
  x <- gsub("\\.", "", x)
  x <- gsub(",", ".", x)
  as.numeric(x)
}

# ── Ruta del CSV ───────────────────────────────────────────────────────────────
ruta_csv <- file.path("data", "NCHS_Leading_Causes.csv")

if (!file.exists(ruta_csv)) {
  stop(paste0(
    "No se encontro el CSV en: ", normalizePath(ruta_csv, mustWork = FALSE), "\n",
    "Asegurate de que la carpeta 'data/' este dentro del mismo directorio que app.R."
  ))
}

# ── Lectura del CSV ────────────────────────────────────────────────────────────
datos_raw <- read_csv(
  ruta_csv,
  show_col_types = FALSE,
  col_types      = cols(.default = col_character())
)

cat("CSV leido:", nrow(datos_raw), "filas,", ncol(datos_raw), "columnas\n")
cat("   Columnas:", paste(names(datos_raw), collapse = ", "), "\n")

# ============================================================
# BLOQUE 1: datos — nivel nacional (United States)
# ============================================================
datos <- datos_raw %>%
  clean_names() %>%
  mutate(
    anio          = as.integer(year),
    causa         = cause_name,
    estado        = state,
    muertes       = parse_deaths(deaths),
    tasa_ajustada = parse_rate(age_adjusted_death_rate)
  ) %>%
  filter(
    estado == "United States",
    anio >= 1999,
    anio <= 2017
  ) %>%
  select(anio, causa, muertes, tasa_ajustada)

cat("datos (US):       ", nrow(datos), "filas | NAs muertes:",
    sum(is.na(datos$muertes)), "| NAs tasa:", sum(is.na(datos$tasa_ajustada)), "\n")

# ============================================================
# BLOQUE 2: datos_nacional — US sin "All causes"
# ============================================================
datos_nacional <- datos %>%
  filter(causa != "All causes") %>%
  group_by(anio, causa) %>%
  summarise(
    muertes       = sum(muertes,        na.rm = TRUE),
    tasa_ajustada = mean(tasa_ajustada, na.rm = TRUE),
    .groups = "drop"
  )

cat("datos_nacional:   ", nrow(datos_nacional), "filas\n")

# ============================================================
# BLOQUE 3: datos_limpios — nivel estado (50 estados + DC)
# ============================================================
datos_limpios <- datos_raw %>%
  clean_names() %>%
  mutate(
    year                    = as.integer(year),
    state                   = str_trim(state),
    deaths                  = parse_deaths(deaths),
    age_adjusted_death_rate = parse_rate(age_adjusted_death_rate)
  ) %>%
  filter(
    state != "United States",
    year  >= 1999,
    year  <= 2017
  )

n_estados <- n_distinct(datos_limpios$state)
cat("datos_limpios:    ", nrow(datos_limpios), "filas |", n_estados, "estados\n")

# ── Alias para los módulos ─────────────────────────────────────────────────────
datos_us      <- datos
datos_estados <- datos_limpios

# ── Listas auxiliares ─────────────────────────────────────────────────────────
causas_lista <- datos_nacional %>%
  pull(causa) %>% unique() %>% sort()

total_muertes_acum <- datos %>%
  filter(causa == "All causes") %>%
  summarise(total = sum(muertes, na.rm = TRUE)) %>%
  pull(total)

cat("Causas:", length(causas_lista), "->", paste(causas_lista, collapse = ", "), "\n")
cat("Muertes acumuladas US (All causes):", format(total_muertes_acum, big.mark = ","), "\n")

# ── Constante de estilo compartida entre tabs ─────────────────────────────────
kpi_label_style <- "margin:0 0 4px; font-size:0.75rem; color:#666;
                     font-weight:600; text-transform:uppercase; letter-spacing:1px;"

# ── Pre-carga geometría de estados (tigris) ────────────────────────────────────
ruta_sf <- file.path("data", "estados_sf.rds")

estados_sf_global <- tryCatch({
  if (file.exists(ruta_sf)) {
    cat("Cargando geometria desde cache:", ruta_sf, "\n")
    readRDS(ruta_sf)
  } else {
    message("Descargando geometria de estados desde tigris (una sola vez)...")
    sf_obj <- tigris::states(cb = TRUE, year = 2016) %>%
      dplyr::filter(!STUSPS %in% c("PR", "VI", "GU", "MP", "AS")) %>%
      sf::st_transform(4326)
    saveRDS(sf_obj, ruta_sf)
    cat("Geometria guardada en cache:", ruta_sf, "\n")
    sf_obj
  }
}, error = function(e) {
  warning("No se pudo cargar la geometria de estados: ", e$message,
          "\n   El mapa coroplético no estara disponible.")
  NULL
})

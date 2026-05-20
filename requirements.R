# ============================================================
# requirements.R
# paquetes necesarios para la app
# Mortalidad EE.UU. 1999-2017
# ============================================================

paquetes <- c(
  "shiny",
  "bs4Dash",
  "tidyverse",
  "janitor",
  "plotly",
  "leaflet",
  "sf",
  "tigris",
  "viridis",
  "scales",
  "RColorBrewer",
  "DT",
  "htmltools",
  "here",
  "fresh"
)

# Instalar los que no están presentes
instalar_si_falta <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

invisible(lapply(paquetes, instalar_si_falta))

# tigris necesita configuración para caché
options(tigris_use_cache = TRUE)

cat("✅ Todos los paquetes están listos.\n")

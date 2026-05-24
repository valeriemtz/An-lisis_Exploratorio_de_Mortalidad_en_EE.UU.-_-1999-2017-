# tab_video.R
# Tab: Video — Presentación en YouTube
# Paleta: Navy #1A3A5C

tab_videoUI <- function(id) {
  ns <- NS(id)
  tagList(

    # ── Estilos propios del tab ──────────────────────────────────────────────
    tags$style(HTML("

      /* ── Hero banner ── */
      .video-hero {
        background: linear-gradient(135deg, #1A3A5C 0%, #2471A3 60%, #1A3A5C 100%);
        border-radius: 10px;
        padding: 36px 40px;
        margin-bottom: 24px;
        display: flex;
        align-items: center;
        gap: 28px;
        box-shadow: 0 4px 18px rgba(26,58,92,0.18);
      }
      .video-hero-icon {
        flex-shrink: 0;
        background: rgba(255,255,255,0.12);
        border-radius: 50%;
        width: 72px; height: 72px;
        display: flex; align-items: center; justify-content: center;
      }
      .video-hero-icon i { font-size: 2rem; color: #fff; }
      .video-hero-text h2 {
        color: #fff;
        font-size: 1.45rem;
        font-weight: 800;
        margin: 0 0 6px;
        letter-spacing: 0.3px;
      }
      .video-hero-text p {
        color: rgba(255,255,255,0.78);
        font-size: 0.88rem;
        margin: 0;
        line-height: 1.6;
      }

      /* ── Tarjeta de video ── */
      .video-card-wrapper {
        background: #fff;
        border: 1px solid #dce3ea;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 2px 12px rgba(26,58,92,0.09);
        transition: box-shadow 0.22s;
        margin-bottom: 24px;
      }
      .video-card-wrapper:hover {
        box-shadow: 0 6px 24px rgba(26,58,92,0.18);
      }
      .video-card-header {
        background: #1A3A5C;
        padding: 14px 22px;
        display: flex;
        align-items: center;
        gap: 12px;
      }
      .video-card-header .badge-ep {
        background: rgba(255,255,255,0.15);
        color: #fff;
        font-size: 0.72rem;
        font-weight: 700;
        letter-spacing: 1.2px;
        text-transform: uppercase;
        padding: 3px 10px;
        border-radius: 20px;
      }
      .video-card-header .video-title {
        color: #fff;
        font-size: 0.95rem;
        font-weight: 700;
        margin: 0;
        flex: 1;
      }

      /* ── Iframe ── */
      .video-embed-container {
        position: relative;
        padding-bottom: 56.25%;
        height: 0;
        overflow: hidden;
        background: #0d1117;
      }
      .video-embed-container iframe {
        position: absolute;
        top: 0; left: 0;
        width: 100%; height: 100%;
        border: 0;
      }
    ")),

    # ── Hero banner ─────────────────────────────────────────────────────────
    tags$div(class = "video-hero",
      tags$div(class = "video-hero-icon",
        icon("youtube")
      ),
      tags$div(class = "video-hero-text",
        tags$h2("Presentaci\u00f3n en Video \u2014 YouTube"),
        tags$p(
          "Complemento audiovisual de este dashboard. El video presenta los hallazgos",
          " del an\u00e1lisis de mortalidad 1999-2017 en EE.UU. de forma narrativa y accesible."
        )
      )
    ),

    # ── Tarjeta de video ─────────────────────────────────────────────────────
    tags$div(class = "video-card-wrapper",
      tags$div(class = "video-card-header",
        tags$span(class = "badge-ep", "Video"),
        tags$p(class = "video-title",
          "Mortalidad en EE.UU. 1999-2017: An\u00e1lisis Exploratorio y Modelos Predictivos"
        )
      ),
      tags$div(class = "video-embed-container",
        tags$iframe(
          src             = "https://www.youtube.com/embed/OnQP6wq5YE0",
          title           = "Mortalidad EE.UU. 1999-2017",
          allow           = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
          allowfullscreen = NA
        )
      )
    )

  )
}

tab_videoServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Tab est\u00e1tico \u2014 sin l\u00f3gica de servidor.
  })
}

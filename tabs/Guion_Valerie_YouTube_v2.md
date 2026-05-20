# 🎬 Guion — Valerie | YouTube (~5 minutos)
### Secciones: Métricas ARIMA → ETS → Regresión Lineal → Comparación → Limitaciones → Conclusiones

---

## BLOQUE 1 — Métricas ARIMA (~1 min 20 seg)

### Sub-sección 11.2 — Prueba ADF
*[Pantalla: tab "Métricas de Modelos" → sección 11.2 ADF]*

Luis ya nos mostró que West Virginia es el estado con la trayectoria más extrema del país en lesiones no intencionales. Ahora les explico cómo construimos el modelo que proyecta su comportamiento futuro.

Lo primero antes de modelar una serie de tiempo es verificar si es estacionaria. ¿Por qué importa esto? Porque un modelo ARIMA necesita saber si los datos se mueven alrededor de una media fija o si tienen una tendencia estructural que no desaparece.

Para verificarlo usamos la prueba de Dickey-Fuller Aumentada. La hipótesis nula es que la serie tiene raíz unitaria —es decir, que no es estacionaria. Si el valor-p está por encima de 0.05, no podemos rechazarla.

En la tabla que ven ahora: la serie de *All causes* obtiene un estadístico ADF de 0.06 con valor-p de 0.99 — prácticamente uno. La serie de *Unintentional injuries* obtiene -2.16 con valor-p de 0.51. Las dos series son no estacionarias, tienen tendencia estructural. Eso le dice al algoritmo que va a necesitar diferenciar los datos al menos una vez antes de modelarlos.

---

### Sub-sección 11.3 — ACF y PACF
*[Cambiar a 11.3 ACF/PACF]*

Los correlogramas confirman esto visualmente. La ACF de *Unintentional injuries* muestra autocorrelaciones que decaen de forma gradual —esa es la firma característica de una serie integrada, con memoria larga. El PACF, en cambio, corta de forma abrupta después del lag 1. Esa combinación —ACF que decae lento, PACF que corta rápido— orienta al algoritmo hacia la estructura que debe seleccionar para el modelo. No hay que definirlo a mano: los correlogramas son la evidencia gráfica que justifica los parámetros que viene.

---

### Sub-sección 11.4 — Selección del modelo
*[Cambiar a 11.4 Selección del modelo]*

`auto.arima` corrió una búsqueda exhaustiva —sin aproximaciones, sin atajos— y seleccionó los modelos con el AIC más bajo para cada serie.

Para la tasa total *All causes* eligió **ARIMA(0,1,0)**: sin términos autorregresivos ni de media móvil, solo una diferenciación. Sus métricas: AIC 146.70, AICc —que es el AIC corregido para muestras pequeñas— 146.95, BIC 147.59, sigma² 181.50, RMSE de entrenamiento 13.11, MAPE 1.12%. Un modelo muy parsimonioso que captura la estabilidad relativa de la tasa total.

Para *Unintentional injuries* eligió **ARIMA(0,1,0) with drift**: igual estructura, pero con una constante que captura la pendiente creciente sostenida de esa serie. AIC 129.63, AICc 130.43, BIC 131.41, sigma² 66.61, RMSE 7.72, MAPE 9.38%. El término drift es clave: es lo que le permite al modelo capturar que esta causa no solo fluctúa, sino que sistemáticamente sube cada año —exactamente lo que documenta el informe del WVDHHR que citamos en el análisis exploratorio.

---

### Sub-sección 11.5 y 11.6 — Diagnóstico y proyecciones ARIMA
*[Pantalla: 11.5 Diagnóstico / 11.6 Proyecciones]*

El diagnóstico de residuos confirma que ambos modelos son válidos. La prueba de Ljung-Box da p = 0.67 para *All causes* y p = 0.17 para *Unintentional injuries* — muy por encima de 0.05, lo que indica que los residuos se comportan como ruido blanco: no hay estructura que el modelo haya dejado sin capturar.

Las proyecciones para 2018–2022 muestran dos trayectorias bien distintas. *All causes* se estabiliza alrededor de 957 por 100,000 habitantes — West Virginia sigue mejorando, pero sin cerrar la brecha con el promedio nacional. *Unintentional injuries* continúa su escalada: de 103.5 en 2018 hasta 116.5 en 2022, con intervalos IC 95% que van de 87.5 hasta 152.3. Esa amplitud refleja la incertidumbre natural de proyectar con solo 19 observaciones anuales, pero la dirección es clara.

---

## BLOQUE 2 — Modelo ETS (~45 seg)

*[Pantalla: tab "Modelos Adicionales" → Sección 13 ETS]*

El segundo modelo que implementamos es ETS — Error, Trend, Seasonality. Es un enfoque distinto al de ARIMA: en lugar de modelar diferencias y autocorrelaciones, modela directamente los componentes de nivel, tendencia y estacionalidad con suavizamiento exponencial.

El algoritmo seleccionó automáticamente la especificación **ETS(M,A,N)**: errores multiplicativos, tendencia aditiva, sin componente estacional —lo cual tiene sentido dado que trabajamos con datos anuales. Sus métricas: AICc 137.84, RMSE en muestra 6.57, y la prueba de Ljung-Box arroja p = 0.2259 — residuos de ruido blanco, modelo válido.

Su proyección para *Unintentional injuries* en 2018–2022 va de 88.1 en 2018 hasta 98 en 2022, con intervalos IC 95% entre 69.7 y 118.5. El modelo proyecta crecimiento sostenido, pero más moderado que ARIMA. ¿Por qué? Porque ETS da más peso a los valores recientes pero no tiene el término drift explícito que captura la aceleración estructural desde 2014 que el ARIMA sí modela.

---

## BLOQUE 3 — Regresión Lineal (~40 seg)

*[Pantalla: Sección 14 — Regresión Lineal]*

El tercer modelo es la Regresión Lineal con tendencia temporal — el benchmark más simple, OLS puro. Aquí no hay componentes estocásticos: simplemente ajustamos una recta a los 19 años de datos.

Sus métricas: R² de 81.8% — un ajuste razonablemente bueno —, pendiente de +2.539 puntos por año, RMSE en muestra 6.56, y Ljung-Box con p = 0.3117 — también pasa el diagnóstico.

Su proyección va de 88.8 en 2018 hasta 99 en 2022, con IC 95% entre 72.6 y 116.3. Los estimados puntuales son similares a ETS, pero hay algo importante que señalar: los intervalos de confianza de la regresión son más estrechos, y eso es una señal de alerta, no de precisión. La regresión OLS asume que los errores son independientes —supuesto que no se cumple del todo en series con memoria temporal—, lo que hace que subestime la incertidumbre real. Por eso lo usamos como benchmark, no como modelo principal.

---

## BLOQUE 4 — Comparación: AICc, Ljung-Box y tsCV (~55 seg)

### Sub-sección 15.1 — Criterios de información
*[Pantalla: tab "Comparación" → sección 15.1 AIC/AICc/BIC]*

Ahora la comparación sistemática. Con solo 19 observaciones, la métrica preferida es el AICc — AIC corregido para muestras pequeñas — según el criterio de Burnham y Anderson, que establece que diferencias mayores a 7 puntos constituyen evidencia fuerte a favor del modelo con menor valor.

Los resultados son claros: **ARIMA(0,1,0) with drift** obtiene AICc de 130.43 — el más bajo de todos. ETS(M,A,N): 137.84, diferencia de 7.4 puntos —justo en el umbral de evidencia fuerte. Holt lineal: 142.08. Holt amortiguado: 148.39. Regresión: no comparable directamente al ser un modelo diferente en naturaleza. ARIMA gana en AIC, AICc y BIC.

---

### Sub-sección 15.2 — Diagnóstico comparativo de residuos
*[Cambiar a 15.2 Ljung-Box]*

En diagnóstico de residuos, los cinco modelos pasan Ljung-Box: ARIMA p = 0.17, ETS 0.23, Holt lineal 0.30, Holt amortiguado 0.36, Regresión 0.31 — todos generan residuos de ruido blanco. Que todos pasen es tranquilizador, pero no los iguala. Lo que diferencia a los modelos no es si capturan bien el pasado, sino cómo proyectan fuera de muestra.

---

### Sub-sección 15.3 — Validación cruzada tsCV
*[Cambiar a 15.3 tsCV]*

Para evaluar eso usamos validación cruzada de series de tiempo —tsCV—, que simula proyecciones rodantes entrenando con datos históricos parciales y midiendo el error en períodos no vistos.

En horizonte h=1: ARIMA RMSE 8.95, MAE 7.21. En horizonte h=3 — más relevante para política pública —: ARIMA RMSE 11.70, MAE 9.35. ETS h=3: RMSE 10.19, MAE 8.30. Regresión h=3: RMSE 8.73, MAE 6.30. Ningún modelo domina en todos los horizontes. Pero el criterio de selección no es solo el error de predicción: ARIMA tiene el AICc más bajo, usa solo 1 parámetro efectivo, y — siguiendo a Shah et al. (2019), publicado en JAMA — es el estándar metodológico en epidemiología para series de mortalidad de este tipo. Parsimonia más fundamento metodológico: esa es la razón de la elección.

---

## BLOQUE 5 — Limitaciones (~35 seg)

*[Pantalla: tab "Limitaciones"]*

Antes de concluir, cuatro limitaciones que son parte honesta del análisis.

Primero: trabajamos con 19 observaciones anuales — una serie corta. Eso hace que los intervalos de confianza sean amplios y que las proyecciones deban interpretarse como indicadores de dirección, no como predicciones exactas.

Segundo: los datos son observacionales y agregados. Identificamos correlaciones entre variables — el crecimiento de lesiones, la epidemia de opioides, la geografía —, pero no podemos establecer causalidad desde estos datos.

Tercero: el dataset no tiene desagregación por edad, sexo o raza. Como lo señala Daugherty et al. (2019), esas son dimensiones críticas para entender el impacto diferencial de la crisis de opioides — y en nuestro análisis quedan fuera.

Cuarto: el análisis cierra en 2017. La pandemia de COVID-19 transformó completamente el perfil de mortalidad posterior, especialmente en West Virginia, y eso no está capturado aquí.

---

## BLOQUE 6 — Conclusiones (~55 seg)

*[Pantalla: tab "Conclusiones"]*

El cierre.

Entre 1999 y 2017, el perfil epidemiológico de Estados Unidos cambió de forma medible. Las enfermedades cardíacas bajaron sostenidamente — la transición epidemiológica funcionando. El cáncer se estabilizó. Pero las lesiones no intencionales y el suicidio escalaron de forma alarmante, especialmente a partir de 2014 — lo que la literatura llama las *"muertes por desesperación"*. Y el Alzheimer subió posiciones, impulsado por el envejecimiento poblacional.

Todo esto ocurrió sobre un mapa con disparidades geográficas estructurales. James, Cossman y Wolf (2018) documentaron que las diferencias de mortalidad entre el sur rural y el resto del país persisten hace décadas — y nuestro análisis lo confirma para el período 1999-2017. Los estados del sur y los Apalaches concentran las cargas más altas, y West Virginia encabeza esa lista.

West Virginia cerró 2017 con una tasa ajustada de 957 por 100,000 para *All causes*, y 100.3 por 100,000 en *Unintentional injuries* — partiendo de apenas 42 en 1999. Más que duplicó esa tasa en 18 años. Nuestro modelo ARIMA proyecta que, sin intervención, esa cifra superará 116 por 100,000 hacia 2022 — una trayectoria respaldada por el informe del WVDHHR documentado en el análisis exploratorio.

Los datos son claros. Lo que falta es política pública que responda donde los números más lo exigen: enfoque en los determinantes sociales de la crisis de opioides, refuerzo de la atención geriátrica para el Alzheimer en ascenso, y salud mental como respuesta a las muertes por desesperación.

Gracias.

---

*Duración estimada: ~5 minutos. Todos los números provienen directamente del bookdown y del Shiny.*
*Referencias citadas: Shah et al. (2019) JAMA · Daugherty et al. (2019) MMWR · James, Cossman & Wolf (2018) Demographic Research*

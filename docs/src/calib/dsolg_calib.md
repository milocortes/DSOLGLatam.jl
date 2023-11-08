# [Parametrización y calibración del modelo](@id calib)

El modelo contempla dos tipos de parámetros: aquellos que pueden ser directamente observados en los datos y aquellos que puedes ser estimados de forma indirecta. En el primer grupo de parámetros tenemos variables como las probabilidades de supervivencia y las razones de capital. En el segundo grupo de variables se encuentran aquellas que son estimadas mediante algún procedimiento de calibración. El procedimiento de calibración usualmente consiste en ajustar el valor de los parámetros hasta que una o varias salidas del modelo sean lo suficientemente cercanas a su valor registrado en el mundo real.

## Parámetros exógenos

Cada periodo del modelo corresponde a 5 años en la vida real. Se supone que los hogares inician su vida económica a la edad de 20 años (``j=1``) y enfrentan una esperanza de vida de 100 años, de manera que el ciclo de vida en el modelo cubre ``JJ=16`` periodos. Se define la edad obligatoria de retiro a los 65 años de edad, lo que significa en el modelo que la edad de retiro corresponde a ``JR=10``, de manera que los hogares gastan los últimos 7 periodos como retirados del mercado de trabajo y reciben una pensión.

Dado que estamos considerando que un periodo corresponde a 5 años, algunas tasas anuales deben ser convertidas. Pensando el caso de la tasa de crecimiento de la población, suponiendo una tasa de crecimiento anual de 1 por ciento, la conversión a una tasa compuesta a 5 años sería igual a ``n_p=1.01^5-1 \sim 0.05``.

La razón de capital en el producto es obtenida de directamente de los datos. Se utilizó la información de [PWT 10.01, Penn World Table](https://www.rug.nl/ggdc/productivity/pwt/?lang=en) para el dato de Chile, Costa Rica y México. De este recurso también se obtuvo la razón de ingreso laboral en el producto. El perfil de productividad dada la edad se toma la sugerida por [Fehr y Kindermann (2018)](https://global.oup.com/academic/product/introduction-to-computational-economics-using-fortran-9780198804390?q=Economics%20Using%20Fortran&lang=en&cc=mx), y fue obtenida de la literatura.

El gasto público total como fracción del GDP es obtenido de [PWT 10.01, Penn World Table](https://www.rug.nl/ggdc/productivity/pwt/?lang=en), mientras que la razón deuda pública-GDP fue obtenido de banco de datos de [CEPAL](https://statistics.cepal.org/portal/cepalstat/dashboard.html?theme=2&lang=es).

Para la calibración de los modelos para los tres países, consideramos 2015 como el año base, de manera que todos los parámetros exógenos corresponden a este año.

## Parámetros calibrados

Los parámetros a calibrar correspondientes a la producción fueron el nivel de tecnología ``\Omega`` y la tasa de depreciación ``\delta``. A sugerencia de los autores, se normaliza la tasa de salarios igual a uno, ``w=1``. El parámetro ``\Omega`` fue calibrado numéricamente hasta obtener los valores más cercanos de la tasa de salarios a la unidad. Por su parte, la tasa de depreciación no fue necesario calibrar pues en  [PWT 10.01, Penn World Table](https://www.rug.nl/ggdc/productivity/pwt/?lang=en) se presenta la tasa para los tres países.

El parámetro ``\nu`` representa el trade off de las preferencias individuales con respecto al consumo y al ocio. Entre más grande el valor de ``\nu``, es más atractivo para los hogares consumir bienes y servicios que son pagados en el mercado que consumir tiempo de ocio. El parámetro ``\nu``, por tanto, tiene una influencia importante en la cantidad de horas que un hogar trabaja en el mercado. Se ajusta ``\nu`` a un objetivo de una razón promedio de tiempo de trabajo en el total de tiempo asignado que representa aproximadamente 33 por ciento. Este valor se calcúla para cada país al asumir una asignación máxima de tiempo de trabajo semanal de 110 horas, asi como también 50 semanas laborales por semana. Entonces se relaciona este promedio anual de horas trabajadas por trabajador, el cual está disponible en la  [PWT 10.01, Penn World Table](https://www.rug.nl/ggdc/productivity/pwt/?lang=en) para los países de estudio.

Los siguientes parámetros a calibrar corresponden al proceso de formación y varianza del logaritmo de los ingresos salariales a lo largo del ciclo de vida de los hogares. Estudios empíricos señalan que alrededor de los 25 años la varianza de los ingresos es de 0.3 y que tiende a incrementarse casi linealmente a un valor de 0.9 hasta la edad de 60 años. En modelo presentado aquí, la varianza del logaritmo de las ganancias laborales se determina por dos componentes : mediante procesos exógenos que afectan la productividad laboral de una forma idiosincrática ``\theta`` y ``\eta_j``, como también por las decisiones individuales acerca de cuántas horas de trabajo se oferta en el mercado. Contamos con información acerca de la estructura del proceso de productividad laboral y cómo este podría influir en la varianza del logaritmo de las ganancias laborales. El logaritmo de las ganancias laborales de un individuo se define como

```math
\begin{equation}
  \log{(w_th_jl_j)} = \log{(w_t)} + \log{(e_j)} + \theta + \eta_j + \log{(l_j)}
\end{equation}
```

Los primeros dos componentes son determinístico para cada grupo de edad, de manera que su varianza es igual a cero. La varianza del logaritmo de las ganancias laborales a la edad ``j`` sería

```math
\begin{equation}
  \text{Var}[{\log{(w_th_jl_j)}}] = \text{Var}[\theta] + \text{Var}[\eta_j] + \text{Var}[\log{(l_j)}] + 2 \text{Cov}[\theta,\log{(l_j)}] + 2 \text{Cov}[\eta,\log{(l_j)}]
\end{equation}
```

Para la estrategia de calibración propuesta por los autores, los primeros dos componentes de la varianza son los más interesantes, dado que pueden ser escritos de forma explícita. La condición inicial para el proceso transitorio is ``\eta_1=0``, lo que implica que ``\text{Var}[\eta_1] = 0``. Sabiendo esto,  podemos calcular las varianzas del componente estocástico del logaritmo de la productividad laboral para cada edad potencial j como

```math
\begin{align*}
\text{Var}[\theta] + \text{Var}[\eta_1] &=  \text{Var}[\theta] &= \sigma_\theta^2 \\
\text{Var}[\theta] + \text{Var}[\eta_2] &=  \text{Var}[\theta + \epsilon_2] &= \sigma_\theta^2 + \sigma_\epsilon^2 \\
\text{Var}[\theta] + \text{Var}[\eta_3] &=  \text{Var}[\theta+ \rho\epsilon_2  + \epsilon_3] &= \sigma_\theta^2 + (1+\rho^2)\sigma_\epsilon^2 \\
\text{Var}[\theta] + \text{Var}[\eta_4] &=  \text{Var}[\theta] + \rho^2\epsilon_2  + \rho\epsilon_3 + \epsilon_4 &= \sigma_\theta^2 + (1+\rho^2 + \rho^4)\sigma_\epsilon^2\\
\vdots
\end{align*}
```

La recursión anterior dice mucho acerca de la varianza del logaritmo de la productividad laboral sobre el ciclo de vida. En primer lugar, dado que el componente inicial transitorio es normalizado a cero, la varianza del logaritmo de la productividad laboral a la edad más joven ``j=1`` es únicamente debida a variaciones en el efecto fijo ``\sigma_\theta^2``. En segundo lugar, una varianza que se incrementa fuertemente durante el ciclo de vida indiva una alta autocorrelación del parámetro ``\rho``. Asumiendo que ``\rho=0``, la varianza del logaritmo de la productividad laboral cambiaría de la edad ``j=1`` a la edad ``j=2`` en un factor ``\sigma_\theta^2 +\sigma_\epsilon^2`` y permanecería constante para el resto del ciclo de vida. Con una autocorrelación ``\rho=1``, la varianza de la productividad laboral a la edad ``j`` sería ``\sigma_\theta^2 +(j-1)\sigma_\epsilon^2``, esto es, se incrementaría linealmente con la edad. Dado que en este modelo la varianza del logaritmo de las ganancias laborales es influida tanto por la productividad laboral y las horas trabajadas, los autores eligen un valor de ``\rho=0.98``, lo cual hace que la varianza del logaritmo de la productividad laboral crezca sustancialmente pero no linealmente.

Habiendo seleccionado un valor de ``\rho``, los parámetros restantes del proceso de productividad laboral son las varianza ``\sigma_\theta^2`` y ``\sigma_\epsilon^2``. Los autores calibran dichos valores teniendo como objetivo obtener una varianza igual a 0.3 en el logaritmo de las ganancias laborales al inicio del ciclo económico de agente a la edad de 25 años (``j=2``) y de 0.9 a la edad de 60 años (``j=9``).

Resta parametrizar el esquema del sistema de impuestos y del sistema de pensiones. El gobierno tiene 4 esquemas tributarios a definir con el objetivo de balancear su presupuesto:

1. Definir exógenamente el valor de ``\tau_t^w`` y ``\tau_t^r``, calcular el valor de ``\tau_t^c``.
2. Definir exógenamente el valor de ``\tau_t^c``, calcular el valor de ``\tau_t^w`` y ``\tau_t^r``
3. Definir exógenamente el valor de ``\tau_t^c`` y ``\tau_t^r``, calcular el valor de ``\tau_t^w``.
4. Definir exógenamente el valor de ``\tau_t^c`` y ``\tau_t^w``, calcular el valor de ``\tau_t^r``.

Para las ejecuciones del modelo se definió el esquema 3, es decir, de forma exógena asignamos un valor de la tasa de impuesto al consumo y el modelo calcula las tasas de impuestos al ingreso laboral y de capital. Los valores de la tasa de impuestos al consumo fueron obtenidas de [OECD Tax Database](https://www.oecd.org/tax/tax-policy/tax-database/).

Con respecto al sistema de pensiones, tenemos que definir la tasa de reemplazo ``\kappa``. El valor observado de la tasa de reemplazo para los tres países fue obtenido de [OECD-Founded Pension Indicators-Contributions](https://stats.oecd.org/Index.aspx?DataSetCode=PNNI_NEW).

El valor del factor de descuento intertemporal ``\beta`` fue el mismo que el usado por los autores.
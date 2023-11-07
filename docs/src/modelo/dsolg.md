# [DSOLG](@id dsolg)
## Modelo

El siguiente modelo corresponde al capítulo 11 del libro de [Fehr y Kindermann (2018)](https://global.oup.com/academic/product/introduction-to-computational-economics-using-fortran-9780198804390?q=Economics%20Using%20Fortran&lang=en&cc=mx).

Dicho modelo incorpora a riesgos idiosincráticos en la productividad laboral y decisión endógena de la oferta de laboral de los hogares. El precio de los factores responde a cambios en el comportamiento individual y el gobierno entra como un agente que recolecta ingresos por impuestos para financiar su gasto.

## Demografía
En cada periodo ``t``, la economía está poblada por ``J`` generaciones traslapadas indizadas por ``j = 1, \dots, J``. Se asume que la supervivencia de un periodo al siguiente es estocástica y que ``\psi_j`` es la probabilidad que un agente sobreviva de la edad ``j-1`` a la edad ``j``, condicional a que vive en la edad ``j-1``. La probabilidad incondicional de sobrevivir a la edad ``j`` está dada por ``\Pi_{i=1}^j \psi_i`` con ``\psi_1=1``. Dado que el número de miembros de cada cohorte declina con respecto a la edad, el tamaño del cohorte correspondiente a la edad ``j`` en el periodo ``t`` es

```math
\begin{equation}
  N_{j,t} =  \psi_{j,t}N_{j-1, t-1} \quad \text{con} \quad N_{1,t} = (1+n_{p,t})N_{1,t-1}
\end{equation}
```

En consecuencia, los pesos de los cohortes (las razones relativas de población) se definen como ``m_{1,t}=1`` y ``m_{j,t} = \dfrac{\psi_{j,t}}{1+n_{p,t}}m_{j-1,t-1}``.


La trayectoria de crecimiento balanceado, es decir donde todas las variables agregadas crecen a una misma tasa, se fija a la tasa de crecimiento del cohorte más joven, el cual se mantiene constante en todos los periodos ``n_{p,t}=n_p``. Se normalizan dichas variables agregadas al tiempo ``t`` por el tamaño del cohorte más joven que está viviendo en ese periodo.

## Decisiones de los hogares: preferencias y riesgo en la productividad laboral

Los individuos tienen preferencias sobre consumo ``c_{j,t}`` y ocio ``\mathrm{l}_{j,t}``, además que pagan impuestos sobre el consumo, ingreso así como también un impuesto sobre nómina al sistema de pensiones. Se asume que la asignación de tiempo es igual a 1. Con ``l_{j,t}`` denotando la cantidad de trabajo en horas ofrecido a mercado en el periodo ``t``, tenemos ``\mathrm{l}_{j,t}+l_{j,t} = 1``. La función de utilidad de los hogares se define como  

```math
\begin{equation}
  E\Bigg[ \sum_{j=1}^J\beta^{j-1} \Big(\Pi_{i=1}^j \psi_{i,k} \Big)u(c_{j,s}, 1-l_{j,s}) \Bigg]
\end{equation}
```

donde ``\beta`` denota el factor de descuento de tiempo.

Dado que no hay mercados de rentas vitalicias (annuity markets), el retorno a activos individuales corresponde a la tasa de interés neta. En un marco donde no hay riesgo de longevidad los agentes conocen con certeza en qué momento su vida terminará. Por lo tanto, son capaces de planear perfectamente en qué punto del tiempo quieren consumir todos sus ahorros. En el modelo que aquí se presenta hay incertidumbre de supervivencia, los agentes pueden morir antes que la máxima duración de vida ``J`` y, como consecuencia, dejar una herencia. Denotemos ``b_{j,t}`` como la herencia que un agente en la edad ``j`` recive en el periodo ``t``.

La pregunta que surge es cuánto del total de activos (incluyendo intereses sobre los pagos) de los agentes fallecidos se distribuye en los miembros de los cohortes sobrevivientes. Se define el siguiente esquema de distribución flexible

```math
\Gamma_{j,s} = \dfrac{\omega_{b,j}}{\sum_{i=1}^J\omega_{b,i}m_{i,s}}
```

donde ``\omega_{b,j}`` se especifica exógenamente.

La cantidad de herencia para cada cohorte puede ser calculado mediante la expresión:
```math
\begin{equation}
  b_{j,t} = \Gamma_{j,t}BQ_{t}
\end{equation}
```

donde ``BQ_{t}`` define la herencia agregada en el periodo ``t``, o simplemente la fracción del total de activos que pueden ser atribuidos a quienes fallecieron al final del período anterior (incluidos los intereses).

```math
\begin{equation}
  BQ_t = R_t^n \sum_{j=2}^J a_{j,t} \dfrac{m_{j,t}}{\psi_{j,t}} (1-\psi_{j,t})
\end{equation}
```

El financiamiento al presupuesto del sistema de pensiones pay-as-you-go es igual a:

```math
\begin{equation}
  \tau_t^p w_t L_t = pen_t \times m_{J,t}
\end{equation}
```


La función de utilidad de los hogares está dada por

```math
\begin{equation}
u(c_{j,t}, 1-l_{j,t}) = \dfrac{\big[(c_{j,t})^\nu (1-l_{j,t})^{(1-\nu)} \big]^{(1 - \frac{1}{\gamma})}}{1 - \frac{1}{\gamma}}
\end{equation}
```

La utilidad de consumo y ocio toma la forma de una función Cobb-Douglas con un parámetro ``\nu`` de preferencia entre ocio y consumo. La elasticidad de sustitución intertemporal es constante e igual a ``\gamma``, donde ``\dfrac{1}{\gamma}`` es la aversión al riesgo del hogar.

Los individuos difieren respecto a su productividad laboral ``h_{j,t}``, la cual depende de un perfil (determinístico) de ingresos por edad ``e_j``, un efecto de productividad fijo ``\theta`` que es definido al comienzo del ciclo de vida, y de un componente autoregresivo ``\eta_{j,t}`` que evoluciona en el tiempo y que tiene una estructura autoregresiva de orden 1, de manera que

```math
\begin{equation}
  \eta_j = \rho \eta_{j-1} + \epsilon_j \quad \text{con} \quad \epsilon_j \sim N(0, \sigma_{\epsilon}^2) \quad \text{y} \quad \eta_1=0
\end{equation}
```

Dada esta estructura, la productividad laboral del hogar es

```math
h_j=\begin{cases}
  e_j \exp{\big[\theta+\eta_j\big]} & \text{si }j<j_r\\
  0 & \text{si } j \geq j_r.
\end{cases}
```

A la edad obligatoria de retiro ``j_r``, la productividad laboral cae a cero y lo hogares reciben una pensión ``pen_{j,t}`` igual a la fracción ``\kappa`` (tasa de reemplazo del sistema de pensiones, definida de forma exógena) del ingreso laboral promedio en el periodo ``t``.  

```math
pen_j=\begin{cases}
  0  & \text{si } j<j_r\\
  \kappa_t \dfrac{w_t}{j_r-1} \sum_{j=1}^{j_r-1}e_j, & \text{si } j \geq j_r.
\end{cases}
```


Los hogares maximizan la función de utilidad sujeta a la restricción presupuestaria intertemporal

```math
\begin{equation}
  a_{j+1,s} = (1+r_t^n)a_{j,s} + w_t^nh_{j,s}l_{j,s} + b_{j,s} + pen_{j,s} - p_tc_{j,s}
\end{equation}
```

donde:
* ``a_{j,t}`` son los ahorros-activos del agente en el periodo t,
* ``w_t^n = w_t(1-\tau_t^w-\tau_t^p)`` es la tasa de salario neto, la cual es igual al salario de mercado ``w_t`` menos los impuestos por ingreso laboral ``\tau_t^w`` y el impuesto de nómina para financiar el sistema de pensión ``\tau_t^p``,
* ``r_t^n = r_t(1-\tau_t^r)`` es la tasa de interés neta, que es igual a la tasa de interés de mercado ``r_t`` descontando el impuesto por ingresos de capital ``\tau_t^r``,
* ``p_t = 1+\tau_t^c`` es el precio al consumidor el cual se normaliza a uno y se agregan los impuestos al consumo ``\tau_t^c``.

Se agrega una restricción adicional de no negatividad de los ahorros ``a_{j+1,s} \geq 0``


### El problema de programación dinámica
El problema de optimización de los agentes es el siguiente:

```math
\begin{equation}
\begin{aligned}
V_t(z) = \max_{c,l,a^+} \quad & u(c,1-l) + \beta E\Big[ V_{t+1}(z^+)|\eta\Big]\\
\textrm{s.a.} \quad & a^+ + p_t c = (1+r_t^n)a + w_t^nhl + pen, \quad a^+\geq 0,\quad l \geq 0 \\
  & \text{y} \quad \eta^+ = \rho \eta + \epsilon^+ \quad \text{con} \quad \epsilon^+ \sim N(0.\sigma_{\epsilon}^2),     \\
\end{aligned}
\end{equation}
```

donde ``z = (j, a, \theta, \eta)`` es el vector de variables de estado individuales. Nótese que se colocó un índice de tiempo en la función de valor y en los precios. Esto es necesario para calcular la dinámica de la transición entre dos estados estacionarios. La condición terminal de la función de valor es

```math
\begin{equation}
  V_t(z) = 0 \quad \text{para} \quad z = (J+1,a,\theta,\eta),
\end{equation}
```

que significa que se asume que los agentes no valoran lo que sucede después de la muerte.

Formulamos la solución de problema de los hogares al reconocer que podemos escribir las funciones de horas laborales y de consumo como funciones de ``a^+`` :

```math
\begin{equation}
l = l(a^+)=\min \Bigg\lbrace\max \Bigg[ \nu + \dfrac{1-\nu}{w_t^n h} (a^+ - (1+r_t^n)a -pen),0 \Bigg], 1 \Bigg \rbrace
\end{equation}
```

```math
\begin{equation}
c = c(a^+) = \dfrac{1}{p_t} \Big[  (1+r_t^n)a + w_t^nhl(a^+) + pen -a^+ \Big]
\end{equation}
```

El problema de los hogares se reduce a resolver la condición de primer orden

```math
\begin{equation}
\dfrac{\nu\big[ c(a^+)^\nu (1-l(a^+))^{1-\nu} \big]^{1-\frac{1}{\gamma}}}{p_tc(a^+)}=\beta(1+r_{t+1}^n)\times E\Bigg[ \dfrac{\nu \big[ c_{t+1}(z^+)^\nu (1-l_{t+1}(z^+))^{1-\nu} \big]^{1 - \frac{1}{\gamma}}}{p_{t+1}c_{t+1}(z^+)} \Bigg | \eta \Bigg]
\end{equation}
```
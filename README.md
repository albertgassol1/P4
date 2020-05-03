PAV - P4: reconocimiento y verificación del locutor
===================================================


## Andrea Iturralde - Albert Gassol

<img src="img/unnamed.jpg" width = "200" align="center">

Obtenga su copia del repositorio de la práctica accediendo a [Práctica 4](https://github.com/albino-pav/P4)
y pulsando sobre el botón `Fork` situado en la esquina superior derecha. A continuación, siga las
instrucciones de la [Práctica 2](https://github.com/albino-pav/P2) para crear una rama con el apellido de
los integrantes del grupo de prácticas, dar de alta al resto de integrantes como colaboradores del proyecto
y crear la copias locales del repositorio.

También debe descomprimir, en el directorio `PAV/P4`, el fichero [db_8mu.tgz](https://atenea.upc.edu/pluginfile.php/3145524/mod_assign/introattachment/0/spk_8mu.tgz?forcedownload=1)
con la base de datos oral que se utilizará en la parte experimental de la práctica.

Como entrega deberá realizar un *pull request* con el contenido de su copia del repositorio. Recuerde
que los ficheros entregados deberán estar en condiciones de ser ejecutados con sólo ejecutar:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.sh
  make release
  run_spkid mfcc train test classerr verify verifyerr
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Recuerde que, además de los trabajos indicados en esta parte básica, también deberá realizar un proyecto
de ampliación, del cual deberá subir una memoria explicativa a Atenea y los ficheros correspondientes al
repositorio de la práctica.

A modo de memoria de la parte básica, complete, en este mismo documento y usando el formato *markdown*, los
ejercicios indicados.

## Ejercicios.

### SPTK, Sox y los scripts de extracción de características.

- Analice el script `wav2lp.sh` y explique la misión de los distintos comandos, y sus opciones, involucrados
  en el *pipeline* principal (`sox`, `$X2X`, `$FRAME`, `$WINDOW` y `$LPC`).

  `sox`: Transforma el fichero de entrada WAVE a formato raw (sin cabecera).
  
  `x2x`: Programa de `sptk` permite la conversión entre distintos formatos de datos, convierte la señal de entrada a reales en coma flotante de 32 bits sin cabecera. 
  
  `FRAME`: Divide la señal de entrada en tramas de 240 muestras (30ms) con desplazamientos de 80 muestras (10ms).
  
  `WINDOW`: Ventana de Blackman por defecto. Multiplica cada trama.
  
  `LPC`: Calcula los "lpc_order" (8 en nuestro caso) primeros coeficientes de predicción linial de todas las tramas.


- Explique el procedimiento seguido para obtener un fichero de formato *fmatrix* a partir de los ficheros
  de salida de SPTK (líneas 41 a 47 del script `wav2lp.sh`).

  Obtenemos los coeficientes lpc y los guardamos en los ficheros .lp. Definimos el número de columnas de la matriz como el número de coeficientes lpc. El número de filas es el número de tramas de la señal. Finalmente utilizamos `x2x`  para construir la matriz con el número de filas, el número de columnas y los datos.

  * ¿Por qué es conveniente usar este formato (u otro parecido)?

  Para tener los datos ordenados y poder acceder a ellos fácilmente.

- Escriba el *pipeline* principal usado para calcular los coeficientes cepstrales de predicción lineal
  (LPCC) en su fichero <code>scripts/wav2lpcc.sh</code>:
  
  ```bash
  sox $inputfile -t raw -e signed -b 16 - | $X2X +sf | $FRAME -l 240 -p 80 | $WINDOW -l 240 -L 240 |
	$LPC -l 240 -m $lpc_order | $LPCC -m $lpc_order -M $num_ceps > $base.lpcc
  ```

- Escriba el *pipeline* principal usado para calcular los coeficientes cepstrales en escala Mel (MFCC) en
  su fichero <code>scripts/wav2mfcc.sh</code>:
  
  ```bash
  sox $inputfile -t raw - | $X2X +sf | $FRAME -l 200 -p 40 |
	$MFCC -l 200 -m $mfcc_order -n $num_filters -s $freq > $base.mfcc
  ```

### Extracción de características.

- Inserte una imagen mostrando la dependencia entre los coeficientes 2 y 3 de las tres parametrizaciones
  para una señal de prueba.

  <img src="img/lpcCoefs.png" width = "640" align="center">
<img src="img/lpccCoefs.png" width = "640" align="center">
<img src="img/mfccCoefs.png" width = "640" align="center">  

  + ¿Cuál de ellas le parece que contiene más información?

MFCC y LPCC contienen más información, ya que los coeficientes estan menos correlados entre si.

- Usando el programa <code>pearson</code>, obtenga los coeficientes de correlación normalizada entre los
  parámetros 2 y 3, y rellene la tabla siguiente con los valores obtenidos.

  |                        | LP   | LPCC | MFCC |
  |------------------------|:----:|:----:|:----:|
  | &rho;<sub>x</sub>[2,3] |  -0.826917    |   0.163496   |  0.250076    |
  
  + Compare los resultados de <code>pearson</code> con los obtenidos gráficamente.

Los resultados concuerdan con las gráficas. Los coeficientes de LPCC y MFCC estan menos correlados entre si como indica &rho;<sub>x</sub>[2,3], en las gráficas esto se refleja con una mayor dispersión de los puntos. Los coeficientes LPC están más correlados, esto se refleja en la gráfica con una cierta "linealidad". 

  
- Según la teoría, ¿qué parámetros considera adecuados para el cálculo de los coeficientes LPCC y MFCC?

Número de coeficientes LPCC = 8-10
Número de coeficientes MFCC = 13-15

### Entrenamiento y visualización de los GMM.

Complete el código necesario para entrenar modelos GMM.

- Inserte una gráfica que muestre la función de densidad de probabilidad modelada por el GMM de un locutor
  para sus dos primeros coeficientes de MFCC.
  
- Inserte una gráfica que permita comparar los modelos y poblaciones de dos locutores distintos (la gŕafica
  de la página 20 del enunciado puede servirle de referencia del resultado deseado). Analice la capacidad
  del modelado GMM para diferenciar las señales de uno y otro.

### Reconocimiento del locutor.

Complete el código necesario para realizar reconociminto del locutor y optimice sus parámetros.

- Inserte una tabla con la tasa de error obtenida en el reconocimiento de los locutores de la base de datos
  SPEECON usando su mejor sistema de reconocimiento para los parámetros LP, LPCC y MFCC.

### Verificación del locutor.

Complete el código necesario para realizar verificación del locutor y optimice sus parámetros.

- Inserte una tabla con el *score* obtenido con su mejor sistema de verificación del locutor en la tarea
  de verificación de SPEECON. La tabla debe incluir el umbral óptimo, el número de falsas alarmas y de
  pérdidas, y el score obtenido usando la parametrización que mejor resultado le hubiera dado en la tarea
  de reconocimiento.
 
### Test final y trabajo de ampliación.

- Recuerde adjuntar los ficheros `class_test.log` y `verif_test.log` correspondientes a la evaluación
  *ciega* final.

- Recuerde, también, enviar a Atenea un fichero en formato zip o tgz con la memoria con el trabajo
  realizado como ampliación, así como los ficheros `class_ampl.log` y/o `verif_ampl.log`, obtenidos como
  resultado del mismo.

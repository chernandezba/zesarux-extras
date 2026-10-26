# Prueba de caché de TSConf

El archivo [tsconf_cache_test.tap](tsconf_cache_test.tap) carga un programa BASIC y
78 bytes de código Z80. En la TS-BIOS, selecciona un arranque que llegue a
Spectrum BASIC 48K (banco `48` del bloque de ROM que contenga esa ROM). Inserta
el TAP en ZEsarUX y ejecuta `LOAD ""` si no arranca automáticamente.

El programa realiza dos mediciones consecutivas a 14 MHz: primero escribe
`#02` en `SysConfig` (`#20AF`, caché desactivada) y después `#06` (caché
activada). En cada caso cuenta las iteraciones del mismo bucle en RAM durante
50 cuadros, según el contador `FRAMES` de BASIC. Muestra `SIN CACHE` y
`CON CACHE`; **un número mayor significa que el bucle se ejecutó más veces**
en el mismo tiempo. Al acabar restaura la velocidad de 3,5 MHz.

El test mide sobre todo lecturas repetidas del código y del contador de cuadros
en RAM. La cifra exacta depende de las interrupciones y de la versión de ROM;
compara las dos líneas de una misma ejecución. Si los números salen casi
iguales, comprueba que realmente se cargó en TSConf y no en un Spectrum 48K
normal. Una espera indefinida significa que el contador `FRAMES` no está
avanzando, por ejemplo porque el banco ROM elegido no usa la interrupción
estándar de BASIC.

Para reconstruir el TAP:

```sh
python3 src/tests/build_tsconf_cache_test.py
```

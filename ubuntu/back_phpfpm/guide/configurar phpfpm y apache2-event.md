# Configuracion de phpfpm y apache2 en modo event

## Glosario de terminos

- **Total Ram:** Total de Memoria Ram que posee la maquina

- **Ram de reserva:** Total de memoria Ram que se quiere mantener de resguardo o de backup.

- **Consumido por servicio:** Total de memoria Ram consumida por el servicio.

## Partiendo de haber ejecutado **ps_mem.py**, se debe realizar los siguientes pasos.

### 1.- Calcular la cantidad maxima de Worker (Procesos) de apache2
```
	MaxRequestWorker = (Total Ram - Ram de reserva) / Consumido por servicio
```
### 2.- Calcular el maximo de clientes para php-fpm
```
	maxclients = (Total RAM - ram_de_reserva) / consumido_servicio
```
### 3.- Completar configuracion del archivo "`/etc/apache2/mods-enabled/mpm-event.conf`"(Esto dentro del contenedor, si compartio esta configuracion en el host anfitrion de docker, debe editarlo alli)
```
<IfModule mpm_*_module>
    ServerLimit           (MaxRequestWorker)
    StartServers          (Numero de CPU's)
    MinSpareThreads       25
    MaxSpareThreads       75
    ThreadLimit           64
    ThreadsPerChild       25
    MaxRequestWorkers     (MaxRequestWorker)
    MaxConnectionsPerChild   1000
</IfModule>
```
### 4.- Completar configuracion del archivo "`/etc/php7/etc/php-fpm.d/www.conf`"(Esto dentro del contenedor, si compartio esta configuracion en el host anfitrion de docker, debe editarlo alli)
```
pm = dynamic            
pm.max_children         (maxclients)
pm.start_servers        (Cantidad CPU's * 4)
pm.min_spare_servers    (Cantidad CPU's * 2)
pm.max_spare_servers    (Cantidad CPU's * 4)
pm.max_requests         1000
```
### 5.- Reiniciar el contenedor
```bash
docker restart phpfpm_compile
```
## Realizar test de funcionmiento:
```bash
ab -n 5000 -c 100 http://localhost/
```
**-n:** Número de solicitudes a realizar para la sesión de benchmarking. El valor predeterminado es simplemente realizar una única solicitud que generalmente lleva a resultados de evaluación comparativa no representativos. Es decir cuantas páginas se pedirán.

**-c:** Número de solicitudes múltiples para realizar a la vez. El valor predeterminado es una solicitud a la vez. En otras palabras cuantas peticiones concurrentes.

## Ejemplo

### Resultado ps_mem.py en Servidor con 2CPU y 1Gb RAM
```
	Private  +   Shared  =  RAM used       Program

	 92.0 KiB + 207.5 KiB = 299.5 KiB       sh
	136.0 KiB + 231.5 KiB = 367.5 KiB       apache2ctl
	252.0 KiB + 653.5 KiB = 905.5 KiB       init_service.sh
	752.0 KiB + 1.5   MiB =   2.2 MiB       apache2(2)
	628.0 KiB + 634.5 KiB =   1.2 MiB       bash
	  4.6 MiB +   2.6 MiB =   7.2 MiB       php-fpm
	---------------------------------
	                         11.1 MiB
	=================================
```
**Nota:** Dentro de los parentesis es la cantidad de procesos en ejecución.
### 1.- Calcular la cantidad maxima de Worker (Procesos) de apache2
```
	Consumido por servicio = 2.2 / 2 = 1.1
	MaxRequestWorker = (1024 - 200) / 1.1 = 749,09 (ajustado=720)
```
### 2.- Calcular el maximo de clientes para php-fpm
```
	maxclients = (1024 - 200) / 7.2 = 144,44 (ajustado= 126)
```
### 3.- Completar configuracion del archivo "`/etc/apache2/mods-enabled/mpm-event.conf`"
```
<IfModule mpm_*_module>
    ServerLimit           720
    StartServers          2
    MinSpareThreads       25
    MaxSpareThreads       75
    ThreadLimit           64
    ThreadsPerChild       25
    MaxRequestWorkers     720
    MaxConnectionsPerChild   1000
</IfModule>
```
### 4.- Completar configuracion del archivo "`/etc/php7/etc/php-fpm.d/www.conf`"
```
pm = dynamic            
pm.max_children         126
pm.start_servers        8
pm.min_spare_servers    2
pm.max_spare_servers    8
pm.max_requests         1000
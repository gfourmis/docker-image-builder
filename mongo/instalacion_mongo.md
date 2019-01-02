# Docker Backend Agile Teams (mongo-docker)

Contiene configuración e instalación de mongo 3.6.

## Contenido

1. [Creación de archivos de configuración y almacenamiento (Comando linux)](#id1)
2. [Configuracion mongod.conf](#id2)
3. [Levantar docker mongo sin almacenamiento en anfitrión](#id3)
4. [Levantar docker mongo sin almacenamiento en anfitrión](#id4)
5. [Conexión estandar a la base de datos](#id5)
6. [Comandos útiles en mongo](#id6)
7. [Para realizar backup y restore](#id7)

**Lista general de paquetes instalados:**
- mongo 3.6.9

<div id="id1"></div>

## Creación de archivos de configuración y almacenamiento (Comando linux)

Desde un directorio que se requiera (para este ejemplo /home/)
```bash
mkdir /home/mongo
mkdir /home/mongo/db
touch /home/mongo/mongod.conf
```
<div id="id2"></div>

## Configuracion mongod.conf

```conf
storage:
    dbPath: /data/db
    journal:
        enabled: true

systemLog:
    destination: file
    logAppend: true
    path: "/var/log/mongodb/mongod.log"

net:
    # bindIp: 127.0.0.1
    port: 27017

processManagement:
    fork: false
    timeZoneInfo: /usr/share/zoneinfo
```

<div id="id3"></div>

## Levantar docker mongo sin almacenamiento en anfitrión
**Nota:** Es requerido colocar nombre de usuario y clave para la autenticación con esta base de datos.
```bash
docker run -p 27017:27017 --name mongo-ubuntu \
    -v /path_mongo/mongo/mongod.conf:/etc/mongod.conf \
    -e MONGO_INITDB_ROOT_USERNAME=admin \
    -e MONGO_INITDB_ROOT_PASSWORD=admin \
    -d mongo:3.6.9 \
    --config /etc/mongod.conf
```

<div id="id4"></div>

## Levantar docker mongo con almacenamiento en anfitrión
**Nota:** Es requerido colocar nombre de usuario y clave para la autenticación con esta base de datos.
```
docker run -p 27017:27017 --name mongo-ubuntu \
    -v /path_mongo/mongo/db:/data/db \
    -v /path_mongo/mongo/mongod.conf:/etc/mongod.conf \
    -e MONGO_INITDB_ROOT_USERNAME=admin \
    -e MONGO_INITDB_ROOT_PASSWORD=admin \
    -d mongo:3.6.9 \
    --config /etc/mongod.conf
```

<div id="id5"></div>

## Conexión estandar a la base de datos

```bash
mongo --host ip_host -u username -p password \
    --authenticationDatabase admin
```

<div id="id6"></div>

## Conexión estandar a la base de datos

**Mostrar base de datos**
```bash
show dbs
```
**Mostrar colecciones de la base de datos seleccionada**
```bash
show collections
```
**Autenticación interna**
```bash
db.auth("username","password")
```
**Usar un base de datos**
```bash
use database_name
```
**Crear y asignar rol a usuario en una base de datos**
```bash
db.createUser(
    {
        user:"admin",
        pwd:"admin",
        roles:[
            "readWrite"
        ]
    }
)
```

<div id="id7"></div>

## Para realizar backup y restore

**Comando para backup**
```bash
mongodump   -h "IP_SERVER" \
            --port "PUERTO" \
            -d "BASE_DE_DATOS" \
            -u "USUARIO_RESTORE_O_ESCRITURA" \
            -p "CLAVE_USUARIO" \
            --gzip \
            --out path_store_db/.
```
**Comando para backup**
```bash
mongorestore    -h "IP_SERVER" \
                --port "PUERTO" \
                -d "BASE_DE_DATOS" \
                -u "USUARIO_RESTORE_O_ESCRITURA" \
                -p "CLAVE_USUARIO" \
                --gzip path_store_db/
```

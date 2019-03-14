# Pasos de migración de MongoDB 3.4 a 4.0.6

## **Backup base de datos (v3.4)**
**Se requiere:**
- *Tener el servicio mongodb ejecutandose.*
- *Se debe detener la escritura sobre la base de datos y luego se realiza el backup.*
- *Cliente Mongo para conexión versión 3.4, igual al motor de base de datos.*
- *Tener un directorio donde se va a almacenar el Backup de la base de datos.*
### **1.- Conectarse a base de datos**
**Estructura:**
```bash
    $ mongo --host ip_host --port port \
          -u username -p password \
          --authenticationDatabase admin
```
<details><summary>Ejemplo:</summary>
<p>

```bash
    $ mongo --host gfourmis.com -u admin -p p2p3mcodna \
    --authenticationDatabase admin
```

</p>
</details>

### **2.- Validar que se encuentre sobre la base de datos correcta**
```bash
    > db
```
*Debe indicar la base de datos que se requiere realizar backup. Ver ejemplo.*
<details><summary>Ejemplo:</summary>
<p>

```bash
    > db
    daily
```

</p>
</details>

#### **2.1.- En caso de no ubicarse en la base de datos**
```bash
    > use database
```
<details><summary>Ejemplo:</summary>
<p>

```bash
    > use daily
```

</p>
</details>

### **3.- Bloquear escritura en base de datos**
```bash
    > db.fsyncLock()
```
*MongoDB le notifica que ya bloqueo los procesos de escritura. Ver ejemplo*
<details><summary>Ejemplo:</summary>
<p>

```bash
    > db.fsyncLock()
    {
            "info" : "now locked against writes, use db.fsyncUnlock() to unlock",
            "lockCount" : NumberLong(1),
            "seeAlso" : "http://dochub.mongodb.org/core/fsynccommand",
            "ok" : 1
    }
```

</p>
</details>

#### **4.1- En caso de no poder bloquear la escritura de datos**
Desconectarse de la base de datos previamente, ejecutanto "exit"
```bash
    $ mongo
    > use admin
    > db.auth("username","password")
    > use database
```
*MongoDB le notifica que ya bloqueo los procesos de escritura. Ver ejemplo*
<details><summary>Ejemplo:</summary>
<p>

```bash
    $ mongo
    > use admin
    > db.auth("admin","amdin")
    > use database
```

</p>
</details>

### **4.- Salir de consola para realizar el backup**
```bash
    > exit
```

### **5.- Realizar backup**
*path_store_db es el directorio definido para almecenar el Backup de base de datps*

*Preferible tener creado el directorio "path_store_db" antes de ejecutar el backup*
```bash
    $ mongodump   -h "IP_SERVER" \
                --port "PUERTO" \
                -d "BASE_DE_DATOS" \
                -u "USUARIO_RESTORE_O_ESCRITURA" \
                -p "CLAVE_USUARIO" \
                --gzip \
                --out path_store_db/.
```
<details><summary>Ejemplo:</summary>
<p>

```bash
    $ mongodump   -h gfourmis.com \
                --port 27017 \
                -d daily \
                -u admin \
                -p admin \
                --gzip \
                --out 20191103/.
```

</p>
</details>

### **6.- Validar respaldo**
```bash
   $ cd path_store_db/
   $ ls 
```
<details><summary>Ejemplo:</summary>
<p>

```bash
    $ cd path_store_db/
    $ ls 
    daily
```

</p>
</details>

## **Restore base de datos (v4.0.X)**
**Se requiere:**
- *Tener el servicio docker ejecutandose.*
- *Se debe tener el Backup anteriormente realizado, sobre la maquina anfitrion.*
- *Si se requiere se puede tener un directorio donde se almacenará la base de datos, desde la maquina anfitrion.*

### **1.- Crear archivo de configuración**
```bash
    $ mkdir /path_root/mongo
    $ touch /path_root/mongo/mongod.conf
```
<details><summary>Ejemplo:</summary>
<p>

```bash
    $ mkdir /home/gfourmis/mongo
    $ touch /home/gfourmis/mongo/mongod.conf
```

</p>
</details>

### **2.- Editar archivo de configuración**
```bash
    $ nano /path_root/mongo/mongod.conf
```
<details><summary>Ejemplo:</summary>
<p>

```bash
    $ nano /home/gfourmis/mongo/mongod.conf
```

</p>
</details>

Configuración ejemplo:
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

### **3.- Crear directorio donde se almacenará la base de datos**
Para este paso se puede usar un directorio propio o crear un volumen con docker (se almacena en /var/lib/docker/volumes, por lo que esa partición debe tener espacio suficiente).

**Crear un directorio de forma independiente**
```bash
    $ mkdir /path_root/mongo/db
```
<details><summary>Ejemplo:</summary>
<p>

```bash
    $ mkdir /home/gfourmis/mongo/db
```

</p>
</details>

**Crear un volumen con docker**
```bash
    $ docker volume create volume_name
```
<details><summary>Ejemplo:</summary>
<p>

```bash
    $ docker volume create db_daily
    $ docker volume ls

    DRIVER              VOLUME NAME
    local               app
    local               at-back
    local               at-db
    local               at-db4
    local               at-front
    local               db_daily

```

</p>
</details>

### **4.- Ejecutar docker con MongoDB 4.0**
```bash
    $ docker run -p port_to:port_on --name name_container \
        -v /path_mongo/mongo/mongod.conf:/etc/mongod.conf \
        -v path_backup:/backup \
        -v volume_name:/data/db \
        -e MONGO_INITDB_ROOT_USERNAME=user_admin \
        -e MONGO_INITDB_ROOT_PASSWORD=password_admin \
        -d mongo:4.0 \
        --config /etc/mongod.conf
```
<details><summary>Ejemplo directorio:</summary>
<p>

```bash
    $ docker run -p 27017:27017 --name mongo-daily \
        -v /home/gfourmis/mongo/mongod.conf:/etc/mongod.conf \
        -v /home/gfourmis/mongo/backup:/backup \
        -v /home/gfourmis/mongo/db:/data/db \
        -e MONGO_INITDB_ROOT_USERNAME=admin \
        -e MONGO_INITDB_ROOT_PASSWORD=admin \
        -d mongo:4.0 \
        --config /etc/mongod.conf
    0c6b1a54225167733441b2007f9ae18ae53b00c494b0422228b036754fa97d59
    $ docker ps 
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                      NAMES
    0c6b1a542251        mongo:4.0           "docker-entrypoint.s…"   27 seconds ago      Up 24 seconds       0.0.0.0:27017->27017/tcp   mongo-daily
```

</p>
</details>

<details><summary>Ejemplo Docker:</summary>
<p>

```bash
    $ docker run -p 27017:27017 --name mongo-daily \
        -v /home/gfourmis/mongo/mongod.conf:/etc/mongod.conf \
        -v /home/gfourmis/mongo/backup:/backup \
        -v db_daily:/data/db \
        -e MONGO_INITDB_ROOT_USERNAME=admin \
        -e MONGO_INITDB_ROOT_PASSWORD=admin \
        -d mongo:4.0 \
        --config /etc/mongod.conf
    0c6b1a54225167733441b2007f9ae18ae53b00c494b0422228b036754fa97d59
    $ docker ps 
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                      NAMES
    0c6b1a542251        mongo:4.0           "docker-entrypoint.s…"   27 seconds ago      Up 24 seconds       0.0.0.0:27017->27017/tcp   mongo-daily
```

</p>
</details>

### **4.- Ingresar al contendor**
```bash
    $ docker exec -it name_container /bin/bash
```
<details><summary>Ejemplo:</summary>
<p>

```bash
    $ docker exec -it mongo-daily /bin/bash
    #
```

</p>
</details>

### **5.- Conectarse al MongoDB, crear base de datos y asignar usuarios**
Conectarse a base de datos
```bash
    $ mongo --host ip_host --port port \
          -u username -p password \
          --authenticationDatabase database
```
Crear base de datos
```bash
    $ use database
```
Asignar permisos a base de datos
```bash
    $ db.createUser(
        {
            user:"user",
            pwd:"pwd",
            roles:[
                "permissions"
            ]
        }
    )
```
**Ejemplo completo**
```bash
    $ mongo --host localhost --port 27017 \
          -u admin -p admin \
          --authenticationDatabase admin
    .
    .
    .
    > use daily
    switched to db daily
    > db.createUser(
        {
            user:"admin",
            pwd:"admin",
            roles:[
                "readWrite"
            ]
        }
    )
    Successfully added user: { "user" : "admin", "roles" : [ "readWrite" ] }
    > db.createUser(
        {
            user:"userRestore",
            pwd:"restore",
            roles:[
                { role : 'restore', db : 'admin' }
            ]
        }
    )
    Successfully added user: {
            "user" : "userRestore",
            "roles" : [
                    {
                            "role" : "restore",
                            "db" : "admin"
                    }
            ]
    }
    > db.getUsers()
    [
        {
            "_id" : "daily.admin",
            "user" : "admin",
            "db" : "daily",
            "roles" : [
                    {
                            "role" : "readWrite",
                            "db" : "daily"
                    }
            ],
            "mechanisms" : [
                    "SCRAM-SHA-1",
                    "SCRAM-SHA-256"
            ]
        },
        {
            "_id" : "daily.userRestore",
            "user" : "userRestore",
            "db" : "daily",
            "roles" : [
                    {
                            "role" : "restore",
                            "db" : "admin"
                    }
            ],
            "mechanisms" : [
                    "SCRAM-SHA-1",
                    "SCRAM-SHA-256"
            ]
        }
    ]
    > exit
    bye
```

### **6.- Realizar conexión de la aplicación con la base de datos**
En lo siguiente es realizar pruebas de conectividad.

En .env de la aplicacón Backend, modificar los valores de base de datos para conectarse a la nueva base de datos.
### **7.- Hacer restore de la base de datos**
```bash
    $ mongorestore  -h "IP_SERVER" \
                    --port "PUERTO" \
                    -d "BASE_DE_DATOS" \
                    -u "USUARIO_RESTORE_O_ESCRITURA" \
                    -p "CLAVE_USUARIO" \
                    --drop \
                    --gzip path_store_db/
```
<details><summary>Ejemplo:</summary>
<p>

```bash
    $ mongorestore  -h localhost \
                    --port 27017 \
                    -d daily \
                    -u userRestore \
                    -p restore \
                    --drop \
                    --gzip /backup/20191103/daily/
```

</p>
</details>

### **8.- Realizar pruebas con la aplicación**
En este punto la aplicación debe funcionar como anteriormente lo estaba haciendo.
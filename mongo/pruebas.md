# 1. Instalar cliente MongoDB

Para conectarse a un servidor remoto o local desde ubuntu 16.04.

###### Actualizar repositorios e instalar paquetes necesarios
```bash
apt update && apt install -y apt-transport-https nano
```

## Mongo 4.0
###### Agregar llave
```bash
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
```
###### Agregar repositorio
```bash
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb.list
```
###### Actualizar repositorios
```bash
apt update
```
###### Instalar especificamente el paquete
```bash
apt install -y mongodb-org-shell=4.0.1 mongodb-org-tools=4.0.1
```

## Mongo 3.6.9
###### Agregar llave
```bash
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
```
###### Agregar repositorio
```bash
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
```
###### Actualizar repositorios
```bash
apt update
```
###### Instalar especificamente el paquete
```bash
apt install -y mongodb-org-shell=3.6.9 mongodb-org-tools=3.6.9
```

# 2. Conectarse a servidor MongoDB

###### Normal
```bash
mongo --host IP_SERVER -u USUARIO -p CLAVE_USUARIO --authenticationDatabase BASE_DE_DATOS
```

###### Cluster
```bash
mongo "mongodb+srv://HOST_NAME/DB_NAME" --username USER_NAME
```

Como para el uso de este docker mongo ya el usuario administrador que podrá gestionar la creación de usuarios y asignación de roles y privilegios sobre los mismo, entonces procedemos a crear los usuarios:

    Usamos la base de datos donde queremos agregar usuarios de lectura y escritura
        > use dev-sp1

    Creamos un usuario con el respectivo role sobre la base de datos.
        > db.createUser(
            {
                user:"devUser",
                pwd:"123456",
                roles:[
                    "readWrite"
                ]
            }
        )

        Nota:   - Solo este usuario podrá hacer algo sobre la base de datos.
                - Si este usuario solo es creado para esta base de datos, solo se podrá autenticar sobre este

    Para validar la asignación del usuario
        > db.getUsers()
    
        Nota: debe quedar algo como lo siguiente:
            [
                {
                        "_id" : "dev-sp1.devUser",
                        "user" : "devUser",
                        "db" : "dev-sp1",
                        "roles" : [
                                {
                                        "role" : "readWrite",
                                        "db" : "dev-sp1"
                                }
                        ]
                }
            ]

    Podemos seguir realizando el mismo procedimiento con las distintas base de datos requeridas. Por ejemplo:

        > use prd-sp1
        > db.createUser(
            {
                user:"prdUser",
                pwd:"123456",
                roles:[
                    "readWrite"
                ]
            }
        )

///////////////////////TESTEO DE AUTENTICACION, ROLES Y PERMISOS (NO SALIR DE LA CONSOLA)//////////////////////        

        Se puede cambiar de usuario sin necesidad de salir de la conexión

            >db.auth('devUser','123456')
        
        nota: seguro fallará si seguimos estos mismos pasos. Y esto sucede porque no estamos en la base de datos donde fue asignado este usuario.
            Validamos donde estamos
            >db.getUsers()
            nota: - En el arreglo debe aparecer el anterior usuario, si no aparece es que no se podrá autenticar.
                  - Solo el usuario admin puede ejecutar este comando en las base de datos. (haga la prueba cuando pueda autenticarse con otro usuario)

        Con los siguientes pasos debe permitir realizarlos
            >db.auth('prdUser','123456')
            >show collections
            >db.createCollection("test1")
            >show collections

        Con los siguientes pasos debería tambien fallar por lo del tema del usuario
            >use dev-sp1
            >show collections
            >db.createCollection("test2")

        Pasandose como administrador ("gfAdmin") se puede validar los usuarios
            >use admin
            >db.auth('gfAdmin','123456')
            >db.system.users.find()

            nota: Identicar que en cada documento el atributo "_id" tiene la base de datos concatenado con el usuario:
                admin.gfAdmin
                dev-sp1.devUser
                .
                .
                .

        
        Ahora para autenticarse desde cliente con los usuarios devUser y prdUser

            #### mongo --host IP_SERVER -u USUARIO -p CLAVE_USUARIO --authenticationDatabase BASE_DE_DATOS
            # mongo --host 192.168.1.130 -u devUser -p 123456 --authenticationDatabase admin
            # mongo --host 192.168.1.130 -u prdUser -p 123456 --authenticationDatabase admin

            nota: - Puede que algunos de estos comandos fallen, queda al entendimiento como resolver.
                  - IMPORTANTE despues de autenticarse, igualmente hay que usar "use database"  
        
///////////////////////REALIZACION DE BACKUPS Y RESTORE//////////////////////        
    PARA LOS BACKUPS
        >use admin
        >db.auth('gfAdmin','123456')
        >use dev-sp1
        >db.createUser(
            {
                user:"bkpUser",
                pwd:"123456",
                roles:[
                    { role:"backup", db:"admin" }
                ]
            }
        )
        Despues al usuario se le puede agregar un role
        >db.grantRolesToUser(
            'bkpUser',
            [ { role : 'restore', db : 'admin' }]
        )


        nota: - Esto se puede replicar en cualquier base de datos para realizar los backups y restore
              - Usuarios que tengan permiso de lectura sobre la DB tambien podrán hacer backups
              - Usuarios que tengan permiso de escritura podrán hacer el restore
              - Un comando completo con los roles de backup y restore sería asi:
                >db.createUser(
                    {
                        user:"bkpUser",
                        pwd:"123456",
                        roles:[
                            { role:"backup", db:"admin" },
                            { role:"restore", db:"admin" }
                        ]
                    }
                )
                * Cabe destacar que los roles de backup y restore se les coloca db:"admin", porque no pueden ser asignados a una DB que no sea admin, solo está tiene estos roles. Igualmente es necesario agregarlo a la DB porque sino mongo rechaza la autenticacion al mismo al momento de realizar el respaldo o la recuperación.

    
    BACKUPS Y RESTORE remotos

    Para realizar respaldo
        #####mongodump.exe -h "IP_SERVER" --port "PUERTO" -d "BASE_DE_DATOS" -u "USUARIO_RESTORE_O_ESCRITURA" -p "CLAVE_USUARIO" --gzip --out docker/.
        # mongodump.exe -h "192.168.1.130" --port "27017" -d "dev-sp1" -u "bkpUser" -p "123456" --gzip --out docker/.

    Para realizar restauracion
        #####mongorestore.exe -h "IP_SERVER" --port "PUERTO" -d "BASE_DE_DATOS" -u "USUARIO_RESTORE_O_ESCRITURA" -p "CLAVE_USUARIO" --gzip UBICACION_DIRECTORIO_BACKUP
        # mongorestore.exe -h "192.168.1.130" --port "27017" -d "dev-sp5" -u "bkpUser" -p "123456" --gzip docker/dev-sp1


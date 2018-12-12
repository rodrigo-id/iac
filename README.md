# Despliegue de maquinas virtuales en AWS con [Terraform](https://www.terraform.io/) para realizar pruebas de stress con [Apache JMeter](https://jmeter.apache.org)

Este despliegue, permite crear:
* una maquina virtual master con los siguientes software preinstalados y configurados:
  - [influxdb](www.influxdb.org)
  - [redis](https://redis.io/)
  - [chronograf 1.4.3.0](https://docs.influxdata.com/chronograf/v1.4/)
  - [grafana 5.0.4](https://grafana.com/)
* N cantidad de maquinas virtuales Nodos con [Apache JMeter](https://jmeter.apache.org)

Para poder ocupar  este despliegue, usted debe contar con las credenciales de acceso al AWS y debes ejecutar terraform desde una consola compatible con linux.

Antes de destruir este despliegue se realiza un backup de la base de datos de influxdb con el nombre de: `jmeter-db.tar.gz`

## Configuración

Para establecer las credenciales de acceso se debe seguir el siguiente procedimiento:

* Copiar el archivo `terraform.tfvars.sample` a un nuevo archivo con el nombre `terraform.tfvars`
* Editar el archivo `terraform.tfvars` con los datos de acceso a AWS:
  ```
  access_key = "MYACCESSKEYID"
  secret_key = "MYSECRETACCESSKEY"
  region = "NombreDeRegion"
  master_type = "NombrDeSaborMaster"
  node_type = "NombrDeSaborMaster"
  cantnode = 2
  ```

### Variables

A continuación se describen las variables que pueden ocuparse en el archivo `terraform.tfvars` o en tiempo de ejecución:

* access_key: Access_key para acceder a AWS
* secret_key: Secret_key del usuario de conexion a AWS
* region: Nombre de la Region de AWS donde se realiza el deploy
* master_ami: Nombre de la AMI (imagen) a deployar para el master.
* node_ami: Nombre de la AMI (imagen) de los Nodos a deployar.
* master_type: Nombre del tipo de maquina master.
* node_type: Nombre del tipo de maquina node.
* cantnode: Cantidad de nodos a crear.

## Ver el plan de despliegue

Antes de realizar el despliegue se debe revisar el plan, que muestra todos los recursos y acciones que realizara con los parámetros deseados.
Para ver el plan de despliegue se debe ejecutar el siguiente procedimiento desde la linea de comando:

* Entrar a la carpeta del despliegue:
* Ejecutar los siguientes comandos:
     ``` bash
     terraform init
     terraform plan
     ```

Nota: Si desea cambiar el valor de una variable en tiempo de ejecución debe adicionar al comando `plan` lo siguiente: `-var "varName=value"` <br/>
  ejemplo: `terraform plan -var "srvname='vmname'"`

## Ejecutar el plan de despliegue

Para ejecutar el plan de despliegue se debe ejecutar el siguiente procedimiento desde la linea de comando:

* Entrar a la carpeta del despliegue:
* Ejecutar el siguiente comando: `terraform apply`

La maquina generada 

Nota: Si desea cambiar el valor de una variable en tiempo de ejecución debe adicionar al comando anterior lo siguiente: `-var "varName=value"`<br/>
  ejemplo: `terraform apply -var "srvname='vmname'"`

## Destruir el despliegue

Antes de destruir el despliegue se debe revisar el plan, que consiste en todos los recursos y acciones que realizara con los parámetros deseados con el comando: `terraform plan -destroy`.
Para destruir el plan de despliegue se debe ejecutar el siguiente procedimiento desde la linea de comando:

* Entrar a la carpeta del despliegue:
* Ejecutar el siguiente comando: `terraform destroy`

Nota: Si desea cambiar el valor de una variable en tiempo de ejecución debe adicionar al comando anterior lo siguiente: `-var "varName=value"` <br/>
  ejemplo: `terraform destroy -var "srvname='vmname'"`

## Ingresar al server master

Para ingresar al server master se ejecuta `ssh -i ssh -i jmeter.key ubuntu@ippublica`
# Instrucciones para el laboratorio

Estos son los pasos a seguir para preparar el escenario, así como las modificaciones a la hora de realizar las prácticas de la asignatura RDSV en el laboratorio de redes de la ETSIT-UPM.

Algunos de los pasos indicados aquí requieren de una VM del departamento (RDSV-K8S) y de una OVA sólo disponible en un directorio en red del mismo.

Las instrucciones están específicamente orientadas a explicar a los profesores los cambios que han sido necesarios para que el despliegue funcione en este nuevo entorno.

Se incluye una versión simple (sólo los scripts a ejecutar), cambios propuestos para el escenario (con la intención de agilizar el proceso de preparación del entorno) y una versión más detallada (que podría ayudar en caso de errores).

# Versión simple

- A menos que se indique lo contrario, los scripts están en el directorio base del repositorio.
- Es recomendable ejecutar todos los scripts desde su directorio, ya que algunos tienen direcciones relativas.

1. Preparar el escenario: ejecutar el script "bin-setup-files/rdsv-get-osmlab-2026" en el ordenador del laboratorio. Si alguna de las VM no tiene acceso a internet, asignarle IP estática (error del DHCP de VirtualBox).

2. Instalar el cliente de OSM: ejecutar el script "install-osm-client.sh" en la VM RDSV-K8S.

3. Actualizar las variables de OSM: ejecutar el script "export_variables.sh" en la VM de OSM cuando OSM haya acabado de iniciarse ("kubectl watch pods -n osm" para ver el estado de las pods).

4. Configurar certificados de MicroK8s: ejecutar el script "microk8s-cert-config.sh" en la VM RDSV-K8S.

5. Configurar NBI: El NBI no se configura con el script (puesto que la IP es variable), por lo que hay que hacerlo manualmente. Ejemplo: "OSM_HOSTNAME=nbi.10.0.2.15.nip.io".

6. Configurar el escenario: ejecutar el script "bin-setup-files/rdsv-config-osmlab-NATNetwork" en la VM RDSV-K8S, el cual replaza al script "rdsv-config-osmlab".

# Cambios Propuestos:

1. Asignar IP estática a ambas VMs: de esta forma se puede configurar la variable "OSM_HOSTNAME" con un script, no sería necesario utilizar el script "export_variables.sh" y se evita el problema de asignación de IPs del DHCP de la red NAT. Además, se podrían configurar los certificados de MicroK8S para esa IP y no tener que hacerlo durante la instalación.

2. Guardar una imágen de la VM RDSV-K8S con el cliente de OSM instalado para no tener que instalarlo durante la práctica.

Si se realizan estos cambios, los pasos 2, 3, 4 y 5 se vuelven innecesarios. El script "bin-setup-files/rdsv-config-osmlab-fixed-IP" es una modificación del script "rdsv-config-osmlab" que realiza la configuración del escenario y se puede elegir la IP de la VM de OSM modificando la variable al principio del script. Podría utilizarse si se hacen estos cambios.

# Versión detallada

## 1. Preparar el escenario

Para preparar el escenario se utiliza el script "rdsv-get-osmlab-2026" encontrado en el directorio "bin-setup-files".

Se puede clonar el repositorio entero para este script, pero es el único script que se utilizaría en el ordenador, estando el resto destinados a ejecutarse en una de las 2 VMs.

En las primeras líneas del script se almacena en variables la dirección del repo del laboratorio, así como el nombre de las OVAs y las VMs. Si estos cambiaran en un futuro, sería necesario modificar esa parte del script.

El script cambia la carpeta de virtualbox a una temporal, importa las OVAs en VirtualBox, crea la red NAT con direcciones 10.0.2.0/24 y conecta ambas VMs a ella.

Una vez ejecutado el script, ambas VM deberían tener acceso a internet.

### Problema habitual: Alguna de las VM no tiene acceso a internet

Lo más probable es que el DHCP de VirtualBox no le haya dado una IP, se puede probar a reiniciar el PC (lo cual tiende a llevar demasiado tiempo) o asignar una IP fija. Para comprobar si este es el problema en la VM de OSM, la interfaz de red que se debe comprobar es "enp0s3".

Para asignar la ip 10.0.2.15 a la VM de OSM se puede usar el script "nat-config.sh". En la VM RDSV-K8S es bastante menos frecuente que ocurra, pero habría que asignarle IP estática en caso de que pasara.

Una opción sería añadirle a la VM RDSV-K8S un script similar a "nat-config.sh" con otra IP para evitar este problema. Otra posibilidad es hacer que la VM tenga ip estática por defecto.

También se podría hacer lo mismo con la VM de OSM, configurandole la IP estática y creando la OVA de nuevo.

## 2. Iniciar el escenario

Para iniciar el escenario, una vez iniciada la VM RDSV-K8S se debe instalar el cliente de OSM, lo cual hace de forma automática el script "source install-osm-client.sh". Este paso puede tardar entre 1 y 2 minutos, así que tener el cliente de OSM preinstalado en la VM podría ahorrar tiempo en el despliegue.

En la VM de OSM, una vez se ha iniciado (con el usuario "vboxuser" y la contraseña "changeme"), se puede ejecutar el comando "kubectl watch pods -n osm" para ver si se ha terminado de iniciar OSM. A veces las pods están por duplicado y sólo se inicia una de ellas (la otra se queda en error o apagada). Desconozco la causa de este error, pero no impide el funcionamiento de OSM.

Una vez OSM ha acabado de iniciarse, es recomendable utilizar el script "export_variables.sh" que se encarga de cambiar la IP del NBI si esta fuera distinta a la de la VM e imprime por pantalla la dirección del NBI y la GUI. A la GUI se puede acceder desde la otra VM, pero para acceder desde el ordenador es necesario añadir una entrada a la tabla de "/etc/hosts" que rediriga el tráfico con dirección a la GUI hacia localhost.

## 3. Configurar certificados de MicroK8s

Por defecto la VM RDSV-K8S no tiene permiso para ejecutar los comandos de MicroK8s que se ejecutan en las prácticas (las IPs se añaden de forma estática y según cuál obtenga la VM podría no estar en la lista), por lo que es necesario añadir la IP de esta VM a la lista de autorizadas. Para ello se puede utilizar el script "source microk8s-cert-config.sh" que lo realiza automáticamente.

Este escript tarda pocos segundos en realizar su tarea, por lo que podría ser conveniente hacer que otro script lo ejecute y así no tener dudas de que no habrá problemas en este paso.

## 4. Configurar NBI

En las prácticas de laboratorio, las credenciales de OSM, así como el NBI los configura el script de configuración del escenario. Puesto que la IP de OSM no es fija (lo cual se puede cambiar para facilitar esto), hay que introducir en la variable "OSM_HOSTNAME" la dirección de la NBI (la que muestra el script "export_variables.sh") del apartado 2.

## 5. Cambio en la configuración del escenario

Para configurar el escenario del laboratorio se usa el script "rdsv-config-osmlab" en las prácticas. Este es el script que configuraba la variable "OSM_HOSTNAME", los credenciales de usuario (los cuales no hace falta configurar si se trabaja con la cuenta admin) además de la VIM y las redes de multus. En este repositorio, en el directorio "bin-setup-files" hay un script alternativo llamado "rdsv-config-osmlab-NATNetwork" que ejecuta los scripts "rdsv-config-k8s-vim" y "rdsv-config-multus" que son los que realizan las funciones del script anterior modificando aquellas partes que son diferentes.
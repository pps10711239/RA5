# RA5.4 K3’s & K9’s

## Índice

1. [Introducción](#introducción)
2. [Despliegue K3s Single-Node y Nginx](#2-despliegue-k3s-single-node-y-nginx)
3. [Despliegue K3s HA y Nginx](#3-despliegue-k3s-ha-y-nginx)
4. [Despliegue docker-compose en K3s y validación con K9s](#4-despliegue-docker-compose-en-k3s-y-validación-con-k9s)

## Introducción

En los últimos años, la evolución del desarrollo de software y la creciente complejidad de las aplicaciones modernas han impulsado la necesidad de herramientas potentes y flexibles para la gestión de infraestructura. En este contexto, Kubernetes se ha consolidado como uno de los pilares fundamentales de la computación en la nube, la orquestación de contenedores y el DevOps.
K3s y K9s, como herramientas complementarias, aportan facilidad de uso, escalabilidad y capacidad de gestión a Kubernetes, incluso en entornos con recursos limitados. Este trabajo explorará sus características, arquitecturas y el despliegue de aplicaciones como nginx en estas plataformas.

## 2. Despliegue K3s Single-Node y Nginx

En este apartado se describe el proceso completo para realizar la instalación, configuración y validación de K3s en modo single-node, junto con el despliegue de un servicio nginx con dos réplicas, utilizando K9s para monitorizar el estado de los recursos.

### Instalación y configuración de K3s

1. Se instala K3s en un nodo único con los comandos necesarios para configurar los permisos, la conexión y la validación de los nodos. Se emplea el siguiente comando para comprobar los nodos disponibles:

```bash
sudo kubectl get nodes
```

![Instalación K3s](assets/Captura1.png)

### Despliegue del servicio nginx

2. Se crea y aplica un archivo YAML con la definición del deployment de nginx con dos réplicas. A continuación, se ejecutan los siguientes comandos:

```bash
kubectl apply -f nginx-deploy.yaml
kubectl get pods
kubectl get svc
```

![Despliegue nginx](assets/Captura2.png)

3. Verificamos que los pods están en estado "Running" y que el servicio nginx está accesible a través del puerto asignado.

![Pods nginx](assets/Captura3.png)

### Validación con K9s

4. Utilizando la herramienta K9s, accedemos al clúster y navegamos por los pods y servicios desplegados. Aquí podemos ver información sobre el estado de los pods, el uso de recursos y la IP asignada.

![Validación con K9s](assets/Captura4.png)
![Estado K9s](assets/Captura5.png)

### Prueba de acceso a nginx

5. Finalmente, se verifica el acceso al servicio nginx desde un navegador, usando la IP y el puerto expuestos por el servicio.

![Acceso nginx](assets/Captura5.png)

Con estos pasos, se ha completado la instalación de K3s en modo single-node, el despliegue de nginx con dos réplicas y la validación mediante K9s y acceso web.

## 3. Despliegue K3s HA y Nginx

En este apartado se describe el proceso para la instalación, configuración y validación de un clúster K3s en modo alta disponibilidad (HA) y el despliegue de un servicio nginx con dos réplicas, utilizando K9s para monitorizar el estado del clúster y los recursos.

### Instalación y configuración de K3s en modo HA

1. Se instalan múltiples nodos master que conforman el plano de control del clúster K3s en modo HA. Durante el proceso, se configuran los tokens de autenticación, se establece la comunicación entre los nodos y se despliega el plano de control. Los comandos utilizados permiten unir los nodos al clúster y verificar su estado:

```bash
sudo kubectl get nodes
```

![Instalación K3s HA](assets/Captura6.png)

### Configuración y unión de nodos

2. Los nodos adicionales se añaden al clúster utilizando el token generado en el nodo inicial y el comando de instalación correspondiente. La correcta unión de los nodos se comprueba mediante:

```bash
sudo kubectl get nodes
```

![Unión nodos](assets/Captura7.png)
![Token de unión](assets/Captura8.png)

### Despliegue del servicio nginx en modo HA

3. Se aplica el deployment de nginx y se comprueba que los pods estén en estado "Running" y distribuidos entre los nodos master del clúster. Los comandos utilizados son:

```bash
kubectl apply -f nginx-deploy.yaml
kubectl get pods
```

![Despliegue nginx HA](assets/Captura9.png)
![Estado pods nginx HA](assets/Captura10.png)

### Validación con K9s

4. Con la herramienta K9s se realiza el monitoreo del clúster, validando el estado de los pods, los recursos y las IPs de los nodos.

![Validación con K9s](assets/Captura11.png)

Con estos pasos se completa el despliegue del clúster K3s en modo HA, con el servicio nginx en funcionamiento y monitorizado a través de K9s.

## 4. Despliegue docker-compose en K3s y validación con K9s

En esta sección se describe el proceso para desplegar un servicio docker-compose en K3s y su posterior validación utilizando K9s.

### Preparación y despliegue de docker-compose

1. Se crea el archivo `docker-compose.yml` que define dos servicios nginx expuestos por diferentes puertos:

```yaml
version: "3"
services:
  nginx1:
    image: nginx
    ports:
      - "8081:80"
  nginx2:
    image: nginx
    ports:
      - "8082:80"
```

![docker-compose.yml](assets/Captura12.png)

2. Para desplegar este archivo en K3s, se utiliza la herramienta `kompose`, que convierte los archivos docker-compose en manifiestos de Kubernetes. Los comandos utilizados son los siguientes:

```bash
kompose convert -f docker-compose.yml
kubectl apply -f nginx1-service.yaml
kubectl apply -f nginx2-service.yaml
kubectl apply -f nginx1-deployment.yaml
kubectl apply -f nginx2-deployment.yaml
```

Esto genera los recursos de Kubernetes (services y deployments) y los aplica al clúster.

3. Para verificar que los pods y servicios están correctamente desplegados, se usan los siguientes comandos:

```bash
kubectl get pods
kubectl get svc
```

### Validación con K9s

4. Utilizando K9s se comprueba el estado de los pods y servicios generados a partir del docker-compose. Se observa que ambos pods nginx están en estado "Running" y correctamente distribuidos en el clúster. Además, se pueden observar detalles como IPs asignadas, nodos, uso de CPU y memoria.

![Estado pods docker-compose](assets/Captura13.png)

Con estos pasos, se ha completado el despliegue y la validación del docker-compose en K3s mediante K9s.

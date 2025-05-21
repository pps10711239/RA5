# RA5.2 – IaC: Infrastructure as Code 🛠️🚀

## Índice

1. [Instalación de Terraform](#instalación-de-terraform)
2. [Archivos del proyecto](#archivos-del-proyecto)
3. [Cómo se ejecuta todo esto](#cómo-se-ejecuta-todo-esto)
4. [Pruebas de que funciona](#pruebas-de-que-funciona)

---

## Instalación de Terraform

Para evitar la instalación manual de Terraform, se creó un script en PowerShell: [`instalar_terraform.ps1`](assets/instalar_terraform.ps1).
Este script realiza automáticamente las siguientes acciones:

* Crea una carpeta `C:\Terraform`.
* Descarga Terraform desde la web oficial.
* Extrae el archivo ZIP.
* Añade la ruta de Terraform al PATH del sistema para permitir su uso desde cualquier terminal.

### Proceso de instalación:

![Figura 1. Instalación de Terraform en Windows](assets/Captura1.png)
**Figura 1. Instalación de Terraform en Windows**

---

## Comprobación

Una vez finalizada la instalación, se cerró y volvió a abrir PowerShell para ejecutar:

```bash
terraform -v
```

El resultado confirmó que la versión 1.8.1 de Terraform se instaló correctamente:

![Figura 2. Terraform correctamente instalado](assets/Captura2.png)
**Figura 2. Terraform correctamente instalado**

---

## Archivos del proyecto

### [`main.tf`](assets/main.tf)

Archivo de configuración de Terraform que lanza un `vagrant up` mediante el recurso `null_resource`. Esto inicia la VM y permite que Vagrant y Ansible se encarguen del resto del proceso.

```hcl
resource "null_resource" "provisionar_vm" {
  provisioner "local-exec" {
    command = "vagrant up"
  }
}
```

---

### [`Vagrantfile`](assets/Vagrantfile)

Define una máquina virtual con Ubuntu 22.04, asignándole 2 CPUs, 2 GB de RAM y configurando la ejecución del playbook de Ansible. Además, sincroniza el directorio del proyecto como `/vagrant` en la VM para que Ansible pueda acceder al archivo `servidor.yml`.

```ruby
ansible.playbook = "/vagrant/servidor.yml"
```

---

### [`servidor.yml`](assets/servidor.yml)

Este playbook de Ansible automatiza la configuración de la máquina virtual. Las tareas realizadas son:

* Actualización de paquetes.
* Instalación del servidor Apache.
* Creación del archivo `index.html` con el texto `Ansible rocks`.
* Reinicio del servicio Apache.
* Comprobación del contenido mediante `curl`.

---

## Cómo se ejecuta todo esto

Primero se inicializó Terraform mediante el comando:

```bash
terraform init
```

![Figura 3. Terraform init](assets/Captura3.png)
**Figura 3. Terraform init**

---

A continuación se ejecutó:

```bash
terraform apply
```

Como ya se había aplicado previamente, fue necesario forzar la reprovisión con:

```bash
terraform taint null_resource.provisionar_vm
terraform apply
```

Este proceso reinició correctamente la VM y ejecutó el playbook:

![Figura 4. terraform apply con taint](assets/Captura4.png)
**Figura 4. terraform apply con taint**

---

## Pruebas de que funciona

### 🛠️ El despliegue completo

Se puede observar cómo Ansible llevó a cabo todas las tareas: actualizaciones, instalación de Apache, generación del HTML y verificaciones, sin errores.

![Figura 5. Proceso de provisión con Ansible](assets/Captura5.png)
**Figura 5. Proceso de provisión con Ansible**

---

### ✅ Validación desde dentro de la VM

Se accedió a la máquina mediante `vagrant ssh` y se ejecutó:

```bash
curl http://localhost
```

El resultado devuelto fue:

```bash
Ansible rocks
```

![Figura 6. curl dentro de la VM](assets/Captura6.png)
**Figura 6. curl dentro de la VM**

---

### Verificación desde el playbook

El propio playbook ejecuta un `curl` y muestra el resultado con un `debug`:

```yaml
- name: Mostrar salida del curl
  debug:
    var: resultado.stdout
```

La salida se muestra al final de la ejecución de Ansible:

![Figura 7. Resultado mostrado por Ansible](assets/Captura7.png)
**Figura 7. Resultado mostrado por Ansible**

---

## 🎉 Conclusión

Este proyecto integra Terraform, Vagrant y Ansible para desplegar y configurar una máquina virtual de forma totalmente automatizada.
Se han cumplido todos los pasos del enunciado y se han presentado pruebas de funcionamiento correctas.

Infraestructura como código, automatizada y efectiva 😎

---

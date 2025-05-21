# Ruta de instalación
$installPath = "C:\Terraform"
$zipUrl = "https://releases.hashicorp.com/terraform/1.8.1/terraform_1.8.1_windows_amd64.zip"
$zipPath = "$env:TEMP\terraform.zip"

# Crear carpeta si no existe
if (-Not (Test-Path $installPath)) {
    New-Item -ItemType Directory -Path $installPath | Out-Null
    Write-Host "Carpeta creada: $installPath"
}

# Descargar ZIP
Write-Host "Descargando Terraform..."
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

# Extraer ZIP
Write-Host "Extrayendo..."
Expand-Archive -Path $zipPath -DestinationPath $installPath -Force

# Añadir al PATH si no está
$envPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
if ($envPath -notlike "*$installPath*") {
    Write-Host "Añadiendo al PATH del sistema..."
    [System.Environment]::SetEnvironmentVariable("Path", "$envPath;$installPath", [System.EnvironmentVariableTarget]::Machine)
} else {
    Write-Host "Terraform ya está en el PATH del sistema."
}

# Comprobación final
Write-Host ""
Write-Host "Instalación completada. Cierra y abre PowerShell de nuevo y ejecuta:"
Write-Host "terraform -v"

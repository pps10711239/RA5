resource "null_resource" "provisionar_vm" {
  provisioner "local-exec" {
    command = "vagrant up"
  }
}

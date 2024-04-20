data "template_file" "init" {
  template = "${file("${path.module}/scripts/startup.sh")}"
  vars = {
    RDPUSERPASSWORD = random_password.password.result
  }
}
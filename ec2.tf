resource "aws_instance" "web" { #
  count_instance           = var.count_instance 
  ami             = var.ami
  instance_type   = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name = aws_key_pair.key _resource.key_name
  security_groups = ["allow_ssh_http"] #refer only by its name not resource name
  user_data = file("userdata_file")

  provisioner "remote-exec" { 
    connection { 
      host        = self.public_ip 
      type        = "ssh" 
      user        = var.user 
      private_key = file(var.ssh_key_location) 
    } 
    inline = [ 
      "sudo yum install -y epel-release", 
    ] 
  } 

  lifecycle{
    prevent_destroy = false
  }

  provisioner "file" { 
      source      = "awx" 
      destination = "/tmp/" 
      connection { 
         host        = self.public_ip 
         type        = "ssh" 
         user        = var.user
         private_key = file(var.ssh_key_location)
      } 

  } 

  tags = {
    Name = "ec2_instance"
  }

#resource "aws_instance" "manually" {
#    ami = "ami-00068cd7555f543d5"
#    key_name = aws_key_pair.key_resource.key_name
#    security_groups = ["allow_ssh_http"] 
#    instance_type = "t2.micro"
# }
}

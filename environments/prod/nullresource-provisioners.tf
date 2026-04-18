resource "null_resource" "name" {
    depends_on = [module.ec2.ec2_public]

    connection {
        type = "ssh"
        host = module.ec2.ec2_public_instance_public_ip
        user = "ec2-user"
        password = ""
        private_key = file("private-key/ec2-instances.pem")
    }

    provisioner "file" {
        source = "private-key/ec2-instances.pem"
        destination = "/home/ec2-user/ec2-instances.pem"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo chmod 400 /home/ec2-user/ec2-instances.pem"
        ]
    }
}
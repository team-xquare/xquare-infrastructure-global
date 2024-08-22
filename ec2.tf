resource "aws_spot_instance_request" "example" {
  ami           = "ami-00ccf68bd3cea3512"
  instance_type = "t3a.large"  # 2 vCPU, 7 GiB Memory

  spot_price    = "0.037"
  spot_type     = "one-time"
  wait_for_fulfillment = true

  tags = {
    Name = "TerraformSpotInstance"
  }

  subnet_id = module.vpc.public_subnet_ids[0]

  user_data = <<-EOF
              #!/bin/bash
              sudo systemctl restart go-agent
              EOF
}


resource "aws_spot_instance_request" "example" {
  ami           = "ami-0af209700f3504393"
  instance_type = "t3a.large"  # 2 vCPU, 7 GiB Memory

  spot_price    = "0.0257"
  spot_type     = "one-time"
  wait_for_fulfillment = true

  tags = {
    Name = "TerraformSpotInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo systemctl restart go-agent
              EOF
}

##################################################
# IAM ROLE FOR SSM
##################################################

resource "aws_iam_role" "ec2_role" {
  name = "${var.instance_name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

##################################################
# ATTACH SSM POLICY
##################################################

resource "aws_iam_role_policy_attachment" "ssm" {

  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

##################################################
# INSTANCE PROFILE
##################################################

resource "aws_iam_instance_profile" "this" {

  name = "${var.instance_name}-profile"

  role = aws_iam_role.ec2_role.name
}

##################################################
# EC2 INSTANCE
##################################################

resource "aws_instance" "this" {

  count = var.instance_count

  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  associate_public_ip_address = true

  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile = aws_iam_instance_profile.this.name

  key_name = var.key_name

  user_data = file("${path.root}/userdata.sh")

  metadata_options {

    http_endpoint = "enabled"

    http_tokens = "required"
  }

  root_block_device {

    volume_size = 20

    volume_type = "gp3"

    encrypted = true

    delete_on_termination = true
  }

  tags = {
    Name = "${var.instance_name}-${count.index + 1}"
  }
}
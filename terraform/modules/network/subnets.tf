# Subnets públicas — uma por AZ — ALB e NAT Gateway
resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  # IP público não atribuído automaticamente — controlado explicitamente por cada recurso
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-subnet-public-${count.index + 1}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Type        = "public"
  }
}

# Subnets privadas — uma por AZ — EKS nodes e RDS
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name        = "${var.project_name}-subnet-private-${count.index + 1}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Type        = "private"
  }
}

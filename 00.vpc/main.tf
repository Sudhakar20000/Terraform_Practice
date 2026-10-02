resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = local.common_tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    local.common_tags,
    {
    Name = "local.common_name-igw"
  }
  )
}

resource "aws_subnet" "frounttir" {
  count = length(var.cidrs_frounttir)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidrs_frounttir[count.index]
  availability_zone = local.availablez[count.index]
  map_public_ip_on_launch = true
  tags = merge (
    local.common_tags, 
    {
        Name = "${local.common_name}-frounttir-${split("-", local.availablez[count.index])[2]}"
    }
  )
  }

  resource "aws_subnet" "apptir" {
  count = length(var.cidrs_apptir)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidrs_apptir[count.index]
  availability_zone = local.availablez[count.index]
  tags = merge (
    local.common_tags, 
    {
        Name = "${local.common_name}-apptir-${split("-", local.availablez[count.index])[2]}"
    }
  )
  }

  resource "aws_subnet" "dbtir" {
  count = length(var.cidrs_dbtir)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidrs_dbtir[count.index]
  availability_zone = local.availablez[count.index]
  tags = merge (
    local.common_tags, 
    {
        Name = "${local.common_name}-dbtir-${split("-", local.availablez[count.index])[2]}"
    }
  )
  }

resource "aws_route_table" "frounttir" {
  vpc_id = aws_vpc.main.id


  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-frounttire"
    }
  )
}

resource "aws_route_table" "apptir" {
  vpc_id = aws_vpc.main.id


  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-apptir"
    }
  )
}

resource "aws_route_table" "dbtir" {
  vpc_id = aws_vpc.main.id


  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-dbtir"
    }
  )
}

resource "aws_route_table_association" "frounttire" {
  count          = length(var.cidrs_frounttir) 
  subnet_id      = aws_subnet.frounttir[count.index].id
  route_table_id = aws_route_table.frounttir.id
}

resource "aws_route_table_association" "apptire" {
  count          = length(var.cidrs_apptir) 
  subnet_id      = aws_subnet.apptir[count.index].id
  route_table_id = aws_route_table.apptir.id
}

resource "aws_route_table_association" "dbtire" {
  count          = length(var.cidrs_dbtir) 
  subnet_id      = aws_subnet.dbtir[count.index].id
  route_table_id = aws_route_table.dbtir.id
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags =  merge (
    local.common_tags,
    {
        Name = "${local.common_name}-nat-static-ip"
    }
  )
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.frounttir[1].id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name}-nat-gw"
    }
  )
}

resource "aws_route" "frounttir_rt" {

    route_table_id         = aws_route_table.frounttir.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  
}

resource "aws_route" "apptir_nat" {
  route_table_id         = aws_route_table.apptir.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route" "dbtir_nat" {
  route_table_id         = aws_route_table.dbtir.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
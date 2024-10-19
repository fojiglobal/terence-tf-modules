#### Resource to create a vpc name 'this #############
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
   tags = {
    Name = "${var.env}-vpc"
    Environment = var.env
    provisioner = "terraform"
    project     = "finance"
   }
}

# ##### Resource to create pub subnet for 'this vpc ##### 
# resource "aws_subnet" "public" {
#   vpc_id = aws_vpc.this.id
#   for_each = var.public_subnets
#   cidr_block = each.value["cidr"]
#   availability_zone = each.value["azs"]
#   tags = each.value["tags"]
#   map_public_ip_on_launch = var.map_pub_ip
# }
# ##### Resource to create priv subnet for 'this vpc #####
# resource "aws_subnet" "private" {
#   vpc_id = aws_vpc.this.id
#   for_each = var.private_subnets
#   cidr_block = each.value["cidr"]
#   availability_zone = each.value["azs"]
#   tags = each.value["tags"]
# }

# ##### Internete and Nat Gateway ####################
# resource "aws_internet_gateway" "this" {
#   vpc_id = aws_vpc.this.id
#   tags = {
#     Name = "${var.env}-igw"
#   }
# }
#  resource "aws_nat_gateway" "this" {
#    allocation_id = aws_eip.this.id
#    subnet_id = aws_subnet.public[var.pub-sub-name].id
#    depends_on = [ aws_internet_gateway.this ]
#    tags = {
#      Name = "${var.env}-ngw"
#    }
#  }

#  resource "aws_eip" "this" {
#   domain = "vpc"
#   depends_on = [ aws_internet_gateway.this ]
   
#  }

# ####### Public Route Tables ########################
#  resource "aws_route_table" "public" {
#    vpc_id = aws_vpc.this.id
#    route {
#     cidr_block = var.all_ipv4_cidr
#     gateway_id = aws_internet_gateway.this.id
#    }
#    tags = {
#      Name = "${var.env}-public-rtr"
#      Environment = "staging"
#    }
#  }

#  ####### Private Route Tables ########################
#  resource "aws_route_table" "private" {
#    vpc_id = aws_vpc.this.id
#    route {
#     cidr_block = var.all_ipv4_cidr
#     nat_gateway_id = aws_nat_gateway.this.id
#    }
#    tags = {
#      Name = "${var.env}-private-rtr"
#      Environment = "staging"
#    }
#  }

#  ###### Route Table Associations ##########
# resource "aws_route_table_association" "public" {
#   route_table_id = aws_route_table.public.id
#   for_each = var.public_subnets
#   subnet_id = aws_subnet.public[each.key].id
# }

# resource "aws_route_table_association" "private" {
#   route_table_id = aws_route_table.private.id
#   for_each = var.private_subnets
#   subnet_id = aws_subnet.private[each.key].id
# }

# ###### Auto Scaling Group ##################
# resource "aws_launch_template" "lt" {
#   name = "${var.env}-lt"
#   image_id = var.ami_id  ####ami-085f9c64a9b75eed5
#   instance_initiated_shutdown_behavior = "terminate"
#   instance_type = var.instance_type  ####t2.micro
#   key_name = var.instance_key ###cs2-use2-main
#   vpc_security_group_ids = [aws_security_group.private.id]

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "${var.env}-web"
#     }
#   }
#   user_data = var.user_data
# }

# ####### Associating Auto Scaling Group ############
# resource "aws_autoscaling_group" "asg" {
#   name = "${var.env}-asg"
#   vpc_zone_identifier = [for subnet in aws_subnet.private : subnet.id]
#   max_size = var.max_size
#   min_size = var.min_size
#   #target_group_arns = [aws_lb_target_group.tgw.arn]
#   launch_template {
#     id = aws_launch_template.lt.id
#     version = "$Latest"
#   }
#   tag {
#     key  = "name"
#     value =  "${var.env}-web"
#     propagate_at_launch = true
#   }
# }
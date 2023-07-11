#Wk 22 Main

#Network Workflow
module "network" {
  source         = "./modules/network"
  
}

#VPC
module "vpc" {
  source = "./module/vpc"
}

#EC2 Launch
module "ec2" {
  source  = "./module/ec2"
  ec2name = "wk22_EC2"
}

output "module_output" {
  value = module.ec2module.instance_id
}

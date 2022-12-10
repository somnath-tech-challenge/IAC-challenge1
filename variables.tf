##### Backend Variables ####

variable "backend_s3" {
    type        = string
    description = "Backend S3 value"
}

variable "backend_dynamodb" {
    type        = string
    description = "Backend dynamodb value"
}


variable "region" {
    type        = string
    description = "The primary region for deployment"
}

variable "main_cidr_block" {
    type        = string
    description = "VPC Main CIDR Block"
}

variable "public_cidr" {
    type        = list(string)
    description = "Public Subnet CIDR range"
}


variable "private_cidr" {
    type        = list(string)
    description = "Private Subnet CIDR range"
}


##### RDS Variables #####

variable "allocated_storage" {
    type        = number
    description = "storage value for RDS"
}

variable "db_engine" {
    type        = string
    description = "RDS Engine"
}

variable "engine_version" {
    type        = string
    description = "RDS Engine Version"
}

variable "instance_class" {    
    type        = string
    description = "RDS Instance class"
}

variable "multi_az" {
    type        = bool
    description = "Multi AZ deployment true/false"
}

variable "db_name" {
    type        = string
    description = "DB Username"
}

variable "rds_db_username_path" {
    type        = string
    description = "DB Username"
}

variable "rds_db_password_path" {
    type        = string
    description = "DB Password"
}








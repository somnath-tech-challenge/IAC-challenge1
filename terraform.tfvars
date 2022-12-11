region          = "us-east-1"
main_cidr_block = "10.0.0.0/16"
public_cidr     = ["10.0.1.0/24", "10.0.3.0/24"]
private_cidr    = ["10.0.4.0/24", "10.0.5.0/24"]

## RDS Variables values ##

allocated_storage    = 10
db_engine            = "mysql"
engine_version       = "5.7"
instance_class       = "db.t3.micro"
multi_az             = false
db_name              = "mydb"
rds_db_username_path = "rds_db_username"
rds_db_password_path = "rds_db_password"
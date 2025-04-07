locals {
    rds_custom_mssql_config = {
        engine                 = "custom-sqlserver-se"
        engine_version         = "15.00.4345.5.v1"
        family                 = "custom-sqlserver-se-15.0"
        major_engine_version   = "15.00"
        instance_class         = "db.r6i.large"
        allocated_storage      = 200
        storage_type           = "gp3"
        username               = "root"
        timezone               = "GMT Standard Time"
        character_set_name     = "Latin1_General_CI_AS"
        }

    rds_custom_mssql_config_new = {
        engine                 = "custom-sqlserver-se"
        engine_version         = "15.00.4345.5.v1"
        family                 = "custom-sqlserver-se-15.0"
        major_engine_version   = "15.00"
        instance_class         = "db.r6i.large"
        allocated_storage      = 200
        storage_type           = "gp3"
        username               = "root"
        timezone               = "W. Europe Standard Time"
        character_set_name     = "Latin1_General_CI_AS"
        }
}
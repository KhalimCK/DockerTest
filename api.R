#Dependencies
library(aws.s3)
library(glmnet)
library(jsonlite)
# library(aws.ec2metadata)

#* @param type
#* @param cid
#* @post /build
function(type = "build", cid){
  
  ##Input parameters
  object <- "balance.csv" #Name of the data in the s3 bucket (dummy here)
  bucket <- "exiipulsedata"
  folder_location <- "~/Documents/Exii/AWS/WebServer/" #location of the functions to be sourced in
  
  #Output parameters
  folder_out <- paste0("cid_",cid)
  object_out <- paste0(folder_out,"/Exii_model.json")
  bucket_out <- "exiipulsemodels"
  
  
  #Load functions
  path <- "functionDependencies.R"
  source(path)
  
  ##Authenticate without specifying credentials- alternatives in https://github.com/cloudyr/aws.signature/  (Which include authenticating while running in ec2 instance)
  aws.signature::use_credentials()
  # aws.signature::locate_credentials()
  
  # (role <- aws.ec2metadata::metadata$iam_info())
  # # get role credentials
  # if (!is.null(role)) {
  #   print(role)
  #   aws.ec2metadata::metadata$iam_role("s3access")
  # }
  

  ##Read in data
  Exii_data <- aws.s3::s3read_using(read.csv, stringsAsFactors = FALSE, object = object, bucket = bucket,
                                    opts = list(check_region = FALSE))
  
  #Train model
  model <- train_Exii_model(Exii_data = Exii_data, build_type = "build")
  
  #convert to json
  x <- convert_to_json(x = model)
  #convert to string
  
  #create customer folder for model
  put_folder(folder_out, bucket = bucket_out)
  
  #push to s3
  aws.s3::s3write_using(x = x, FUN = jsonlite::write_json, object = object_out, bucket = bucket_out, folder = folder_out)
  
  return(list(status = "Complete"))
}
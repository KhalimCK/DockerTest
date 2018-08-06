train_Exii_model <- function(Exii_data, build_type = "build"){
  
  y <- as.vector(Exii_data$balance)
  x1 <- 1:nrow(Exii_data)
  x2 <- runif(n = nrow(Exii_data))
  x <- cbind(x1,x2)
  
  model <- glmnet(x = x, y = y, family = "gaussian")
  
  beta <- as.matrix(model$beta)
  fit <- as.matrix(predict(model, x))
  lambda <- as.data.frame(model$lambda)
  
  out <- list(beta = beta, fit = fit, lambda = lambda)
  
  return(out)
}

convert_to_json <- function(x){
  
  json_object <- jsonlite::toJSON(x = x, pretty = FALSE)
  
  return(json_object)
}
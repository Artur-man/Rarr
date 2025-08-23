#' create_zarr_group
#'
#' create zarr groups
#' 
#' @param store the location of (zarr) store
#' @param name name of the group
#' @param version zarr version
#' @export
create_zarr_group <- function(store, name, version = "v2"){
  split.name <- strsplit(name, split = "\\/")[[1]]
  if(length(split.name) > 1){
    split.name <- vapply(seq_len(length(split.name)), 
                         function(x) paste(split.name[seq_len(x)], collapse = "/"), 
                         FUN.VALUE = character(1)) 
    split.name <- rev(tail(split.name,2))
    if(!dir.exists(file.path(store,split.name[2])))
      create_zarr_group(store = store, name = split.name[2])
  }
  dir.create(file.path(store, split.name[1]), showWarnings = FALSE)
  switch(version, 
         v2 = {
           write("{\"zarr_format\":2}", file = file.path(store, split.name[1], ".zgroup"))},
         v3 = {
           stop("Currently only zarr v2 is supported!") 
         },
         stop("only zarr v2 is supported. Use version = 'v2'")
         )
}

#' create_zarr
#'
#' create zarr store
#'
#' @param file name of zarr store, with or without \code{.zarr} extension
#' @param dir the location of zarr store
#' @param version zarr version
#' 
#' @examples
#' dir.create(td <- tempfile())
#' zarr_name <- "test"
#' create_zarr(dir = td, prefix = "test")
#' dir.exists(file.path(td, "test.zarr"))
#' 
#' @export
create_zarr <- function(file, dir = NULL, version = "v2"){
  
  # check extension
  file <- if(grepl(".zarr$", file))
    file 
  else
    paste0(file, ".zarr")
  
  # check directory is not NULL
  if(is.null(dir)) {
    dir <- dirname(file)
    file <- basename(file)
  }
  if(!dir.exists(dir))
    stop("The directory ", dir, " cannot be found!")
  
  # create zarr
  create_zarr_group(store = dir, name = file, version = version)
}
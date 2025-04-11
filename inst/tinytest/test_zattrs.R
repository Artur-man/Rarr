# create zarr
dir.create(td <- tempfile())
name <- "test"
path <- file.path(td, paste0(name, ".zarr"))
create_zarr(dir = td, prefix = name)

# add .zattrs to /
zattrs <- list(foo = "foo", bar = "bar")
write_zattrs(path = path, new.zattrs = zattrs)
expect_true(file.exists(file.path(path, ".zattrs")))

# check .zattrs
read.zattrs <- read_zattrs(path)
expect_equal(read.zattrs, zattrs)

# add new elements to .zattrs
zattrs.new.elem <- list(foo2 = "foo")
write_zattrs(path = path, new.zattrs = zattrs.new.elem)
read.zattrs <- read_zattrs(path)
expect_equal(read.zattrs, c(zattrs,zattrs.new.elem))

# overwrite
zattrs.new.elem <- list(foo2 = "foo2")
write_zattrs(path = path, new.zattrs = zattrs.new.elem)
read.zattrs <- read_zattrs(path)
zattrs[names(zattrs.new.elem)] <- zattrs.new.elem
expect_equal(read.zattrs, c(zattrs))

# overwrite = FALSE
zattrs.new.elem <- list(foo2 = "foo")
write_zattrs(path = path, new.zattrs = zattrs.new.elem, overwrite = FALSE)
read.zattrs <- read_zattrs(path)
zattrs[names(zattrs.new.elem)] <- "foo2"
expect_equal(read.zattrs, c(zattrs))

# add .zattrs to array
x <- array(runif(n = 10), dim = c(2, 5))
res <- write_zarr_array(
  x = x, zarr_array_path = file.path(path, "array"),
  chunk_dim = c(2, 5)
)
zattrs <- list(foo = "foo", bar = "bar")
array.path <- file.path(path, "array")
write_zattrs(path = array.path, zattrs)
expect_true(file.exists(file.path(array.path, ".zattrs")))
read.zattrs <- read_zattrs(array.path)
expect_equal(read.zattrs, c(zattrs))


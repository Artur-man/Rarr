

m <- matrix(runif(1e5), ncol = 100)
tf1 <- tempfile(fileext = ".zarr")
chunk_dim <- c(50,50)
z1 <- writeZarrArray(m, tf1, chunk_dim = chunk_dim)

expect_inherits(z1, class = "ZarrArray")

# getters
expect_equal(chunkdim(z1), chunk_dim)
## input and output path are not the same on all platforms e.g. Windows
## as we follow the Zarr spec rules for normalizing
expect_equal(path(z1), Rarr:::.normalize_array_path(tf1))
expect_equal(normalizePath(path(z1)), tf1)

# ways to get the array from disk to memory
expect_equal(extract_array(z1, index = list(NULL, NULL)), m)
expect_equal(realize(z1, BACKEND = NULL), m)
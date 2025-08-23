dir.create(td <- tempfile())
name <- "test"
output_zarr <- file.path(td, paste0(name, ".zarr"))

# open zarr
create_zarr(file = name, dir = td)
expect_true(dir.exists(output_zarr))
expect_true(file.exists(file.path(output_zarr, ".zgroup")))

# create group one group
create_zarr_group(store = output_zarr, name = "group1")
expect_true(dir.exists(file.path(output_zarr, "group1")))
expect_true(file.exists(file.path(output_zarr, "group1", ".zgroup")))

# create nested two groups
create_zarr_group(store = output_zarr, name = "group2/subgroup1")
expect_true(dir.exists(file.path(output_zarr, "group2")))
expect_true(file.exists(file.path(output_zarr, "group2", ".zgroup")))
expect_true(dir.exists(file.path(output_zarr, "group2/subgroup1")))
expect_true(file.exists(file.path(output_zarr, "group2/subgroup1", ".zgroup")))

# create nested three groups
create_zarr_group(store = output_zarr, name = "group3/subgroup1/subsubgroup1")
expect_true(dir.exists(file.path(output_zarr, "group3")))
expect_true(file.exists(file.path(output_zarr, "group3", ".zgroup")))
expect_true(dir.exists(file.path(output_zarr, "group3/subgroup1")))
expect_true(file.exists(file.path(output_zarr, "group3/subgroup1", ".zgroup")))
expect_true(dir.exists(file.path(output_zarr, "group3/subgroup1/subsubgroup1")))
expect_true(file.exists(file.path(output_zarr, "group3/subgroup1/subsubgroup1", ".zgroup")))

# version 3 and other entries
dir.create(td <- tempfile())
name <- "test"
output_zarr <- file.path(td, paste0(name, ".zarr"))
expect_error(create_zarr(file = name, dir = td, version = "v4"), pattern = "only zarr v2 is supported")

# null dir
dir.create(td2 <- tempfile())
output_zarr <- file.path(td2, paste0(name, ".zarr"))
create_zarr(file = output_zarr)
expect_true(dir.exists(output_zarr))

# no extension name for zarr zarr
dir.create(td3 <- tempfile())
output_zarr <- file.path(td3, name)
create_zarr(file = output_zarr)
expect_true(dir.exists(paste0(output_zarr, ".zarr")))
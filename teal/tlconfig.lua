-- Note that this needs to manually be kept in sync with the
-- dependencies in BUILD.bazel
return {
   build_dir = "../lua",
   source_dir = "src",
   global_env_def = "globals",
   include_dir = { "include", "src" },
}

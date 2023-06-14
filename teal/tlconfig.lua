-- Note that this needs to manually be kept in sync with the
-- dependencies in BUILD.bazel
return {
   source_dir = ".",
   global_env_def = "globals",
   include_dir = { "." },
}

locals {
  env_vars = { for line in split("\n", file("../../../../.env")) :
    regex("^(.*)=" , line)[0] => regex("=(.*)", line)[0]
    if length(trimspace(line)) > 0 && substr(line, 0, 1) != "#" # Ignore empty lines & comments
  }
}

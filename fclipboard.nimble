# Package
version = "0.1.0"
author = "Davide Galilei"
description = "A simple filesystem clipboard"
license = "MIT"
srcDir = "src"
bin = @["fclipboard", "fcopy", "fpaste"]

# Dependencies
requires "nim >= 1.4.2"
requires "norm"
requires "cligen"

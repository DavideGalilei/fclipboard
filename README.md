# fclipboard - a clipboard for your filesystem
This program allows you to copy and paste files within the terminal.

# Installation
```console
$ nimble install https://github.com/DavideGalilei/fclipboard
```
Remember to add `~/.nimble/bin/` to your `$PATH`, othwerwise you will not be able to use `fclipboard`, `fcopy`, `fpaste` executables.

# Usage
Just `cd` into a directory and try:
```console
$ fcopy filename.txt
$ fcopy file2 --alias:second
$ cd somewhere_else
$ fpaste second # Will paste `file2` here
$ fpaste # with no arguments, it pastes the default one
```

Use `fcliboard/fcopy/fpaste --help` for further information.

## License
Licensed under the MIT License.

Click [here](/LICENSE) for further information.

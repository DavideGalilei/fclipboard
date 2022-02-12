import std / [os, strformat, json]
import pkg / cligen
import db


proc cli*(pos: seq[string], filename: string = "", alias: string = "default"): int =
  ## ---
  ## 
  ## Refer to `fclipboard --help` for complete help.
  ##  `fcopy filename`
  ## 
  ## ---
  
  let file = if pos.len > 0: pos[0]
    else: filename

  if not fileExists(file):
    case file:
    of "": echo "You must specify a file. Example: `fcopy filename`"
    else: echo &"The specified file does not exist. ({escapeJson(file)})"
    return 1

  let conn = initDatabase()
  conn.updateRecord(NamedRecord(
    name: alias,
    path: getCurrentDir() / file,
  ))


when isMainModule:
  dispatch(cli, positional = "pos",
    help = {
      "filename": "The filename of the file to be copied",
      "alias": "Its alias in the database"
    },
    short = {"filename": 'f', "alias": 'a'})

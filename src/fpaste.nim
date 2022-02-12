import std / [os, strformat, strutils, json]
import pkg / cligen
import pkg / norm / sqlite
import db


proc cli*(pos: seq[string], alias: string = "default", path: string = ""): int =
  ## ---
  ## 
  ## Refer to `fclipboard --help` for complete help.
  ##  `fpaste [alias]`
  ## 
  ## ---
  
  var path = path.strip(chars = Whitespace)
  let file = if pos.len > 0: pos[0]
    else: alias

  try:
    let conn = initDatabase()
    let toPaste = conn.getRecord(name = file)

    if not fileExists(toPaste.path):
      echo &"The copied file does not exist anymore. ({escapeJson(file)})"
      return 1
    
    var toPath = if path != "": getCurrentDir() / path
      else: getCurrentDir() / toPaste.path.splitPath().tail

    if toPath.endswith("/") or dirExists(toPath):
      let toDir = toPath.splitPath().head & "/"
      discard existsOrCreateDir(toDir)

      copyFileToDir(
        toPaste.path,
        toPath,
      )
    else:
      copyFile(
        toPaste.path,
        toPath,
      )
  except NotFoundError:
    echo &"The alias {escapeJson(alias)} has not been found in the database."
    return 1


when isMainModule:
  dispatch(cli, positional = "pos",
    help = {
      "alias": "File alias in the database"
    },
    short = {"alias": 'a', "path": 'p'})

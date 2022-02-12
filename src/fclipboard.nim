import std / json
import pkg / cligen
import norm / sqlite
import db


proc cli*(list: bool = false, remove: bool = false, removefiles: seq[string]): int =
  ## ---
  ## 
  ## A simple program to copy files between folder
  ## without struggling to remember their paths and
  ## writing them down manually.
  ## Usage is simple, just `cd` into a directory and try:
  ##  fcopy filename.txt
  ##  fcopy file2 --alias:second
  ##  cd somewhere_else
  ##  fpaste second # Will paste the second file here
  ##  fpaste # with no arguments, it pastes the default one
  ## 
  ## ---

  if list:
    let conn = db.initDatabase()
    let records = db.getRecords(conn)
    
    if len(records) == 0:
      echo "There are no records"
      return 1

    for record in records:
      echo escapeJson(record.name), ": ", escapeJson(record.path)
    return 0
  elif remove:
    let conn = initDatabase()  
    if removefiles.len == 0:
      try:
        var record = conn.getRecord(name = "default")
        conn.delete(record)
        return 0
      except NotFoundError:
        return 1
    else:
      for toDelete in removefiles:
        var alias = if toDelete == "": "default" else: toDelete

        try:
          var record = conn.getRecord(name = alias)
          conn.delete(record)
        except NotFoundError:
          discard


when isMainModule:
  dispatch(cli, help = {
      "remove": "Remove an alias from the database if it exists.",
    },
    short = {"list": 'l', "remove": 'r'})

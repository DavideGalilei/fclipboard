import
  std / os,
  norm / [model, sqlite, pragmas]

type
  NamedRecord* {.tableName: "records"} = ref object of Model
    name* {.unique.}: string
    path*: string

proc addRecord*(conn: DbConn, record: NamedRecord): NamedRecord =
  var record = record
  conn.insert(record)
  new result
  conn.select(result, "name = ?", record.name)

proc getRecord*(conn: DbConn, name: string): NamedRecord =
  new result
  conn.select(result, "name = ?", name)

proc getRecords*(conn: DbConn): seq[NamedRecord] =
  result = @[NamedRecord()]
  selectAll[NamedRecord](conn, objs = result)

proc updateRecord*(conn: DbConn, record: NamedRecord) =
  try:
    discard conn.addRecord(record)
  except DbError:
    var fetched = conn.getRecord(record.name)
    fetched.path = record.path
    conn.update(fetched)

proc initDatabase*(path: string = getConfigDir() / "fclipboard"): DbConn =
  discard existsOrCreateDir(path)
  let conn = open(path / "records.db", "", "", "")
  conn.createTables(NamedRecord())
  return conn

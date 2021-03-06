library(RSQLite)

# start connection
dbPath <- file.path("SOdevSurvey/SOdevSurvey.db")
conn <- RSQLite::dbConnect(drv=SQLite(), dbname = dbPath)


# write tables
RSQLite::dbWriteTable(conn = conn,
             name = "master",
             value = xFrame,
             overwrite=TRUE)
                   
                   
RSQLite::dbWriteTable(conn = conn,
             name = "languages",
             value = langFrame,
             overwrite=TRUE)

RSQLite::dbWriteTable(conn = conn,
             name = "devtypes",
             value = devFrame,
             overwrite=TRUE)

RSQLite::dbWriteTable(conn = conn,
             name = "databases",
             value = dbFrame,
             overwrite=TRUE)

RSQLite::dbWriteTable(conn = conn,
             name = "frameworks",
             value = fwFrame,
             overwrite=TRUE)

RSQLite::dbWriteTable(conn=conn,
             name= "platforms",
             value = platFrame,
             overwrite=TRUE)


# close connection
RSQLite::dbDisconnect(conn)
rm(dbPath)

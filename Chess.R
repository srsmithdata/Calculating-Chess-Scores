require(DBI)
require(devtools)
require(rmarkdown)
require(knitr)
require(DBI)
require(xtable)
require(stringr)
require(XML)
require(RCurl)
require(tau)
require(graphics)
require(RMySQL)

### Loading driver
MySQLDBdrv <- dbDriver("MySQL")
MySQLcon <- dbConnect(MySQLDBdrv, user = "ricsmith", password = '666')
MySQLdiscon <- dbDisconnect(MySQLcon)
MySQLdiscon

ChsSQL1_creatdb <- 'CREATE DATABASE IF NOT EXISTS Chess ;'

tmptbl1 = read.csv( "https://www.dropbox.com/sh/tdrk13cl76iko4g/AAC_wthh5RS0tefMKky6WBPoa/tb.csv?dl=1", header = FALSE, sep = ",", quote = "\"", na.strings = -1 )

names(tmptbl1) <- c("Country", "Year",  "Gender", "Child", "Adult", "Elderly")

dbWriteTable( conn = dbcon, name = "tb", value = tmptbl1, row.names = FALSE, overwrite = TRUE)

rm("tmptbl1")

tmptbl2 = read.csv("https://www.dropbox.com/s/qrfiguuvcyff4o1/population.csv?dl=1", header = TRUE, sep = ",", quote = "\"")

dbWriteTable( conn = dbcon, name = "pop", value = tmptbl2, row.names = FALSE, overwrite = TRUE)

rm("tmptbl2")
f
sqlaggtb <- "SELECT Country, Year, Sum(Child), sum(Adult), sum(Elderly) FROM tb Group by  Country, Year;"

dfaggtb <- dbGetQuery(dbcon, sqlaggtb)

SumPopTB <- as.integer(dfaggtb[[3]]) + as.integer(dfaggtb[[4]]) + as.integer(dfaggtb[[5]])

dfyrtottb <- data.frame(dfaggtb$Country,dfaggtb$Year, SumPopTB)
names(dfyrtottb) <- c("Country", "Year", "TBTot")
dbWriteTable( conn = dbcon, name = "TBpYr", value = dfyrtottb, row.names = FALSE, overwrite = TRUE)

sql <- "SELECT TBpYr.Country, TBpYr.Year, TBpYr.TBTot, pop.population FROM TBpYr INNER JOIN pop ON TBpYr.Country = pop.country AND TBpYr.Year = pop.year;"

dfCtryYrRaw <- dbGetQuery(dbcon, sql)

tbcasep100k <- (dfCtryYrRaw[3] /  dfCtryYrRaw[4] )*100000

dfCtryYrRatio <- data.frame(dfCtryYrRaw[1], dfCtryYrRaw[2], tbcasep100k)

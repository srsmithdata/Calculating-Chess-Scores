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

## Setting SQL variables
#MySQLDBdrv <- dbDriver("MySQL")
#MySQLcon <- dbConnect(MySQLDBdrv, user = "ricsmith", password = '666')
#MySQLdiscon <- dbDisconnect(MySQLcon)
#ChsSQL1_creatdb <- 'CREATE DATABASE IF NOT EXISTS Chess ;'

## The Data
ChsLocal <- 'https://raw.githubusercontent.com/srsmithdata/Calculating-Chess-Scores/master/tournamentinfo.txt'
FileConn <- file(description = ChsLocal, open = 'rt', blocking = T )
## Importing data to R
## This code is based on the following spec. If the spec changes or does not conform, the code will give an error message and cancel out for the code to be revised.
##
## FILE SPEC:
## UTF-8 encoded file
## Headers in rows 1-4
## EOL indicator on every line
## Unit = player in 2 lines
## First player's first line is line 5
##
## Players' data correspecds to the follow alignment/positional value: (where the 2nd "#" for the comment notation is the left edge of the file. So "Pair" is in position 2)
## Pair | Player Name                     |Total|Round|Round|Round|Round|Round|Round|Round|
## Num  | USCF ID / Rtg (Pre->Post)       | Pts |  1  |  2  |  3  |  4  |  5  |  6  |  7  |

## Reading in data from file
ttbl1 = readLines(con = FileConn, warn = T)
close.connection(FileConn)

## Splitting datas by player row
Row1 <- seq.int(from = 5, by , to = length(ttbl1))
Row2 <- seq.int(from = 6, by = 3, to = length(ttbl1))
RowLabel1 <- 2
RowLabel2 <- 3

ttbl1 <- trimws(ttbl1, which = 'right')

ttbl2Lft <- ttbl1[Row1]
ttbl2Rt <- ttbl1[Row2]
ttbl2LLab <- ttbl1[RowLabel1]
ttbl2RLab <- ttbl1[RowLabel2]

## Parsing the columns
## Since the file is mostly pipe delimited, we can use that to find column start/end posns
##
ttbl2delim <- unlist(str_locate_all(ttbl2Lft[1], '\\|'))
ttbl2LPPsn <- data.frame('Lst' = c(1, ttbl2Ldelim[1:9]+1), 'Lend' = c(ttbl2Ldelim[1:10]-1) )
ttbl2RPPsn <- data.frame('Rst' = c(1, ttbl2Rdelim[1:9]+1), 'Rend' = c(ttbl2Rdelim[1:10]-1) )

## Since the report writer didn't delineate the 2nd row Player info the same, manual fix:
fixdelimR <- c(8, 16, 23, 26, 27, 29, 32, 35, 36, 38)
fixdelimR[seq.int(1,10,2)]
fixdelimR[seq.int(2,10,2)]

ttbl2RPPsn <- ttbl2RPPsn[1,], c[(8,16), (23, 26), (27, 29), (32, 35), (36, 38)], ttbl2RPPsn[3:10,])


ttbl2LVarNM <- c( trimws( substring( ttbl2LLab, ttbl2PPsn[1:10,1], ttbl2PPsn[1:10,2])))

ttbl2RVarNM <- c( trimws( substring( ttbl2RLab, ttbl2PPsn[1:10,1], ttbl2PPsn[1:10,2])))
ttbl2RVarNM

## Col Names

PairNum
PlayerFN
Total
Round1
Round2
Round3
Round4
Round5
Round6
Round7
State
USCF_ID
Pre_Rtg
Post_Rtg



## Separating lines
##
substr(



########## old code:
##########
( "https://www.dropbox.com/sh/tdrk13cl76iko4g/AAC_wthh5RS0tefMKky6WBPoa/tb.csv?dl=1", header = FALSE, sep = ",", quote = "\"", na.strings = -1 )

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

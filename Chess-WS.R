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
# require(RMySQL)

## Setting SQL variables
#MySQLDBdrv <- dbDriver("MySQL")
#MySQLcon <- dbConnect(MySQLDBdrv, user = "ricsmith", password = '666')
#MySQLdiscon <- dbDisconnect(MySQLcon)
#ChsSQL1_creatdb <- 'CREATE DATABASE IF NOT EXISTS Chess ;'

## The Data
ChsLocal <- 'https://raw.githubusercontent.com/srsmithdata/Calculating-Chess-Scores/master/tournamentinfo.txt'

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
ttbl1 = read.delim(file = ChsLocal, header = T, sep = '|', quote = '', stringsAsFactors = F, strip.white = T, skip = 1, comment.char = '-')
FrstRowNum <- seq.int(2, length(ttbl1[,1]), 2)
SecRowNum <- seq.int(3, length(ttbl1[,1]), 2)

## Splitting datas by player row
ttbl2 <- data.frame(ttbl1[FrstRowNum,], ttbl1[SecRowNum,])


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

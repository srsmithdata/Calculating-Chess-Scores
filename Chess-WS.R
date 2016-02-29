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

options(stringsAsFactors = F)

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
ttbl1 = read.delim(file = ChsLocal, header = T, sep = '|', quote = '', stringsAsFactors = F, strip.white = T, skip = 1)
FrstRowNum <- seq.int(3, length(ttbl1[,1]), 3)
SecRowNum <- seq.int(4, length(ttbl1[,1]), 3)

## Splitting data by player row
ttbl2 <- data.frame(ttbl1[FrstRowNum,], ttbl1[SecRowNum,])

## Parsing fields that didn't have delimiters and had multiple data points
## We'll first delimit the 2nd row of the name field
#### Pull space locations to facilitate delimiting
SpBr <- data.frame(str_locate_all(string = ttbl2$Player.Name.1, ' ')[1])
StPosn <- as.vector(c(1, 15, 20, 24, 29))
EndPosn <- as.vector(c(8, 18, 21, 27, 30))
SpBrttbl2 <- data.frame(StPosn, EndPosn)

#### Pulling the parsed variables with a  for loop and entering them into a matrix:
####

ttbl3_PNMFull <- matrix(ncol = 5, nrow = length(ttbl2$Player.Name.1), byrow = T)

i <- 1
while( i < (1 + length(ttbl2$Player.Name.1)))
{
    j <- 1
    while(j < 6 )
    {
        ttbl3_PNMFull[i, j] <- substr(ttbl2$Player.Name.1[i], SpBrttbl2[j, 1], SpBrttbl2[j, 2])
        j <- j + 1
    }
    i <- i + 1
}
tttbl3_PreR <- as.vector(c(as.integer(ttbl3_PNMFull[,2])))
tttbl3_PostR <- as.vector(c(as.integer(ttbl3_PNMFull[,4])))

ttbl3_PNMFull[,2] <- tttbl3_PreR
ttbl3_PNMFull[,4] <- tttbl3_PostR

#### Matrix of round data

TotRnd <- 7
RndCols <- TotRnd*3
TotPart <- length(ttbl2[,2])
ttbl3_Rnds <- matrix(ncol = RndCols, nrow = TotPart)

RndNm <- as.vector('')

for (iRnd in 1:7)
{
    OldCol <- ttbl2[,iRnd + 3]
    FirstCol <- iRnd*3 - 2
    SecCol <- iRnd*3 - 1
    ThrdCol <- iRnd*3
    ttbl3_Rnds[,FirstCol] <- substring(OldCol, 1, 1)
    ttbl3_Rnds[,SecCol] <- substring(OldCol, 3, 5)
    ## pulling the scores of the competitors
    ttbl3_Rnds[,ThrdCol] <- ttbl3_PNMFull[as.integer(ttbl3_Rnds[,SecCol]) ,2]
    RndNm <- as.vector(c(RndNm, paste("RndRlt", iRnd, collapse = ''), paste("RndOpp", iRnd, collapse = ''), paste("RndOppRat", iRnd, collapse = '')))
}

FullTbl <- data.frame( ttbl2[,1:2], ttbl2[,12], ttbl3_PNMFull[,1:5], ttbl2[,3], ttbl3_Rnds[,1:21])

names(FullTbl) <- as.vector(c("PlayerNbr", "PlayerName", "PlayerState", "USCF_ID", "Pre-Tourn_Rating", "Pre-Tourn_PSc", "Post-Tourn_Rating",  "Post-Tourn_PSc", "TotalPts", as.vector(RndNm[2:22]) ) )

str(FullTbl)

## To get the mean of the scores of the games played, we need to insure our scores are integers without missing values:
##

ScrNbr <- matrix( nrow = length(FullTbl[,2]), ncol = 7)

OppScCol <- seq(12, 30, 3)

FTbliRow <- seq(1:length(FullTbl[ , 1]) )
for( j in FTbliRow)
{
    i <- 1
    while( i < 8)
    {
        CurrColNbr <- i*3 + 9
        ScrNbr[j, i] <- as.integer( FullTbl[j, CurrColNbr] )
        i <- i + 1
    }
}

## with na.rm = T, the rowMeans function will take the average across the columns excluding the na fields

AvgCompSc <- rowMeans(ScrNbr, na.rm = T)
FullTbl <- data.frame(FullTbl, AvgCompSc)
names(FullTbl[,31]) <- 'AvgCompetitorRat'


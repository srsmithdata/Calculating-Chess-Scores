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

for(i in 1:length(ttbl2$Player.Name.1))
{
    for(j in 1:5)
    {
        ttbl3_PNMFull[i, j] <- substr(ttbl2$Player.Name.1, SpBrttbl2[i, 1], SpBrttbl2[i, 2])
    }
}


TotRndPl <- 14
TotPart <- length(ttbl2[,1])


ttbl3_PNMParseA <- ttbl3_PNMParse[ seq.int(1, length(ttbl3_PNMParse), 5) ]

ttbl3_PNMParseB <- ttbl3_PNMParse[ seq.int(1, length(ttbl3_PNMParse), 5) ]

ttbl3_PNMParseC <- ttbl3_PNMParse[ seq.int(1, length(ttbl3_PNMParse), 5) ]

ttbl3_PNMParseD <- ttbl3_PNMParse[ seq.int(1, length(ttbl3_PNMParse), 5) ]

ttbl3_PNMParseE <- ttbl3_PNMParse[ seq.int(1, length(ttbl3_PNMParse), 5) ]




#### Matrix of round data
ttbl3_Rnds <- matrix(ncol = TotRndPl, nrow = TotPart)

RndNm <- as.vector('')
for (iRnd in 1:7) {
    OldCol <- ttbl2[,iRnd + 3]
    FirstCol <- iRnd*2 - 1
    SecCol <- iRnd*2
    ttbl3_Rnds[,FirstCol] <- substring(OldCol, 1, 1)

    ttbl3_Rnds[,SecCol] <- substring(OldCol, 3, 5)
    RndNm <- as.vector(c(RndNm, paste("RndRlt", iRnd, collapse = ''), paste("RndOpp", iRnd, collapse = '')))
    }

rm(RndNm[1])


ttbl4 <-

ttbl3_Pinfo <- data.frame(


length(ttbl3_PNMParse)

tail(ttbl3_PNMParse)
## Col Names
varnm2 <- names(ttbl2)
varnm2str <- as.character( paste(varnm2[1:length(varnm2)]))

## Manually edited string gerated by varnm2str to clean up var names
names(ttbl2) <- as.vector(c("PlayerNbr", "PlayerName", "TotalPts", "Roundb", "Round.2", "Round.3", "Round.4", "Round.5", "Round.6",  "Round.7", "X", "USCF_ID", "Pre-Tourn_Rating", "Pre-Tourn_PSc", "Post-Tourn_Rating",  "Post-Tourn_PSc", "N-Score", "Round.1b", "Round.2b", "Round.3b", "Round.4b", "Round.5b", "Round.6b",  "Round.6b", "Xb"))



###### Scrap:
######
for (i in 1:5) {
ttbl3_PNMFull[ ,i] <- ttbl3_PNMParse[ seq.int(i, length(ttbl3_PNMParse), 5) ]
}
next(i)

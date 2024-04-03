library(data.table)
library(lubridate)

in_dir <- "data"

#1. export from timing software
schuss_out <- fread(file.path(in_dir,"Schuss Results Export Test.csv"))
colnames(schuss_out) <- c("bib", "gender", "first", "last", "y", "div", "time",
                          "team", "team_time","x")

#2. schuss guess time
schuss_guess <- fread(file.path(in_dir,"Schuss guess.csv"))

#3. merge
schuss <- merge(schuss_out, schuss_guess[,.(bib,guess_time)])

schuss[, guess_act := (guess_time - time), by = "bib"]

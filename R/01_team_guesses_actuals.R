library(data.table)
library(lubridate)

in_dir <- "data"

#1. export from timing software
schuss_out <- fread(file.path(in_dir,"Schuss Results Export Test.csv"))
colnames(schuss_out) <- c("bib", "gender", "first", "last", "y", "div", "time",
                          "team", "team_time","x")
str(schuss_out)
schuss_out[, time_sec := as.integer(sub(":.*", "", 
                                        time)) * 60 + as.numeric(sub(".*:", "", 
                                                                     time))]
#2. schuss guess time
schuss_guess <- fread(file.path(in_dir,"Schuss guess.csv"))
str(schuss_guess)
schuss_guess[, guess_time_sec := as.integer(sub(":.*", "", 
                                                guess_time)) * 60 + as.numeric(sub(".*:", "", 
                                                                     guess_time))]

#3. merge
schuss <- merge(schuss_out, schuss_guess[,.(bib,guess_time, guess_time_sec)])

schuss[, guess_diff := abs(guess_time_sec - time_sec), by = "bib"]

schuss_teams <- schuss[, .(team_guess = sum(guess_diff, na.rm = TRUE)), 
                       by = "team"]

setkey(schuss_teams, team_guess)

fwrite(schuss_teams, file.path(in_dir, "schuss_teams_out.csv"))

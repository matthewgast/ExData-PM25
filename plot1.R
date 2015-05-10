## plot1.R
##
## Matthew Gast, May 2015
##
## Course: "Exploratory Data Analysis" at the JHU Bloomberg School of
## Health (Coursera Data Science Specialization).  This file is part
## of the second class project on PM2.5 data.
##
## Question 1: Have total emissions from PM2.5 decreased in the United
## States from 1999 to 2008? Using the base plotting system, make a
## plot showing the total PM2.5 emission from all sources for each of
## the years 1999, 2002, 2005, and 2008.

plot1 <- function () {
    source("pm25-project.R")
    readData()
    te <- totalEmissionsByYear()

    png("plot1.png")
    barplot(te$emissions,
            names.arg=te$year,
            xlab="Year",
            ylab=expression("Total PM"[2.5]*" Emissions (tons)"),
            main=expression("PM"[2.5]*" Emissions in the U.S. By Year"),
            )

    #ToDo: rescale Y axis
    
    #ypos <- seq(0,8,by=1)
    #axis(2,at=ypos, labels=sprintf("%.2fkb", ypos/1000000))

    dev.off()
}

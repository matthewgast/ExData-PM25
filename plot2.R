## plot2.R
##
## Matthew Gast, May 2015
##
## Course: "Exploratory Data Analysis" at the JHU Bloomberg School of
## Health (Coursera Data Science Specialization).  This file is part
## of the second class project on PM2.5 data.
##
## Question 2: Have total emissions from PM2.5 decreased in the
## Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use
## the base plotting system to make a plot answering this question.

plot2 <- function () {
    source("pm25-project.R")
    readData()
    te <- totalEmissionsByYearByLocation("24510")

    png("plot2.png")
    barplot(te$emissions,
            names.arg=te$year,
            xlab="Year",
            ylab=expression("Total PM"[2.5]*" Emissions (tons)"),
            main=expression("PM"[2.5]*" Emissions in Baltimore"),
            )
    dev.off()
}

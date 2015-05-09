## plot5.R
##
## Matthew Gast, May 2015
##
## Course: "Exploratory Data Analysis" at the JHU Bloomberg School of
## Health (Coursera Data Science Specialization).  This file is part
## of the second class project on PM2.5 data.
##
## Question 5: How have emissions from motor vehicle sources changed
## from 1999–2008 in Baltimore City?

plot5 <- function () {
    source("pm25-project.R")
    readData()
    baltimore.cars <- motorVehicleEmissions("24510")

    barplot(te$emissions,
            names.arg=te$year,
            xlab="Year",
            ylab=expression("Total PM"[2.5]*" Emissions (tons)"),
            main=expression("PM"[2.5]*" Emissions in Baltimore from Cars By Year"),
            )

    # Todo: rescale y axis
}

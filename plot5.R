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
    balt.cars <- motorVehicleEmissions("24510")

    library(ggplot2)
    graph <- ggplot (balt.cars, aes(x=factor(year),y=emissions)) +
        geom_bar(stat="identity") +
        xlab("year") +
        ylab(expression("Total PM"[2.5]*" Emissions (tons)")) +
        ggtitle(expression("PM"[2.5]*" Auto Emissions in Baltimore"))

    # Todo: rescale y axis
    writePlotFile(graph, "plot5.png", "png")
}

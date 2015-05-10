## plot4.R
##
## Matthew Gast, May 2015
##
## Course: "Exploratory Data Analysis" at the JHU Bloomberg School of
## Health (Coursera Data Science Specialization).  This file is part
## of the second class project on PM2.5 data.
##
## Question 4: Across the United States, how have emissions from coal
## combustion-related sources changed from 1999–2008?

plot4 <- function () {
    source("pm25-project.R")
    readData()
    coal <- totalFuelEmissionsByYear("coal")

    library(ggplot2)
    library(scales)

    graph <- ggplot(coal,
           aes(x=factor(year),y=emissions)) +
        geom_bar(stat="identity") +
        xlab("year") +
        ylab(expression("PM"[2.5]*" Emissions (tons)")) +
        ggtitle (expression("PM"[2.5]*" Emissions from Coal Combusion in the U.S.")) +
        scale_y_continuous(labels=comma)

    writePlotFile(graph, "plot4.png", "png")
}

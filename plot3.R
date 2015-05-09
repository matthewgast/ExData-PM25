## plot3.R
##
## Matthew Gast, May 2015
##
## Course: "Exploratory Data Analysis" at the JHU Bloomberg School of
## Health (Coursera Data Science Specialization).  This file is part
## of the second class project on PM2.5 data.
##
## Question 3:Of the four types of sources indicated by the type
## (point, nonpoint, onroad, nonroad) variable, which of these four
## sources have seen decreases in emissions from 1999–2008 for
## Baltimore City? Which have seen increases in emissions from
## 1999–2008? Use the ggplot2 plotting system to make a plot answer
## this question.

plot3 <- function () {
    source("pm25-project.R")
    readData()
    te <- totalEmissionsByTypeByYearByLocation("24510")

    library(ggplot2)

    ggplot(te,
           aes(x=factor(year),y=emissions)) +

        facet_grid(. ~ type) +
        geom_bar(stat="identity") +
        xlab("year") +
        ylab("total PM2.5 emission (tons)")

    # To do: add legend for type?
    # Change vertical scale per type?
}

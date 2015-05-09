## plot6.R
##
## Matthew Gast, May 2015
##
## Course: "Exploratory Data Analysis" at the JHU Bloomberg School of
## Health (Coursera Data Science Specialization).  This file is part
## of the second class project on PM2.5 data.
##
## Question 6: Compare emissions from motor vehicle sources in
## Baltimore City with emissions from motor vehicle sources in Los
## Angeles County, California (fips == "06037"). Which city has seen
## greater changes over time in motor vehicle emissions?

# This function extracts motor vehicle emissions from the NEI data set in Baltimore and Los Angeles, and then "normalizes" the emissions to 100%.

plot6 <- function() {
    source("pm25-project.R")
    readData()

    balt.cars <- motorVehicleEmissions("24510")
    balt.cars <- mutate(balt.cars,county="Baltimore")
    balt.cars.norm <- mutate(balt.cars,emissions=emissions/max(emissions))

    la.cars <- motorVehicleEmissions("06037")
    la.cars <- mutate(la.cars,county="Los Angeles")
    la.cars.norm <- mutate(la.cars,emissions=emissions/max(emissions))

    cars <- rbind(balt.cars, la.cars)
    cars.norm <- rbind(balt.cars.norm, la.cars.norm)
    
    library(ggplot2)

    # Total emissions
    total.g <- ggplot (cars, aes(x=factor(year),y=emissions),fill=County) + geom_bar(stat="identity") +facet_grid(.~County) + ggtitle("Total emissions")

    # Normalized emissions
    normal.g <- ggplot (cars.norm, aes(x=factor(year),y=emissions),fill=County) + geom_bar(stat="identity") +facet_grid(.~County)+ggtitle("Normalized emissions to max")

    multiplot(total.g, normal.g)

}

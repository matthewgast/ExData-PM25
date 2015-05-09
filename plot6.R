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

plot6 <- function() {
    source("pm25-project.R")
    readData()
    baltimore.cars <- motorVehicleEmissions("24510")
    la.cars <- motorVehicleEmissions("06037")
}

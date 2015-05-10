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

# This function extracts motor vehicle emissions from the NEI data set
# in Baltimore and Los Angeles, and also calculates a "normalized"
# emission setting, where the normalized setting is a percentage
# relative to the peak emission year.  Because Los Angeles is larger,
# it will see greater absolute changes.

plot6 <- function() {
    source("pm25-project.R")
    readData()

    # Step 1: get the raw data, and also calculate emissions relative
    # to the peak values in both cities
    balt.cars <- motorVehicleEmissions("24510")
    balt.cars <- mutate(balt.cars,
                        emit_pct=emissions/max(emissions),
                        county="Baltimore")
    
    la.cars <- motorVehicleEmissions("06037")
    la.cars <- mutate(la.cars,
                      emit_pct=emissions/max(emissions),
                      county="Los Angeles")

    cars <- rbind(balt.cars, la.cars)

    # Step 2: graph data. The gridExtra library will allow putting
    # multiple ggplot graphics in one file.
    library(ggplot2)
    library(gridExtra)
    require(RColorBrewer)
    
    # Absolute emissions, graphed per location
    total.g <- ggplot (cars,
                       aes(x=factor(year),
                           y=emissions,
                           fill=county)) +
      xlab("year") +
      ylab("PM2.5 emissions (tons)") +
      geom_bar(stat="identity") +
      facet_grid(.~county) +
      ggtitle("Total PM2.5 auto emissions") +
      scale_fill_brewer(palette="Set1") +
      guides(fill=FALSE)

    # Normalized emissions, graphed per location
    normal.g <- ggplot (cars,
                        aes(x=factor(year),
                            y=emit_pct,
                            group=county)) +
      xlab("year") +
      ylab("Amount of peak-year emission (percent)") +
      geom_point() + 
      geom_line() +
      facet_grid(. ~ county) +
      ggtitle("PM2.5 auto emissions relative to peak") +
      scale_y_continuous(label=percent) +
      scale_fill_brewer(palette="Set1") +
      guides(fill=FALSE)

    # Finally, assemble the single graphics file
    png("plot6.png")
    grid.arrange(total.g,normal.g,ncol=1)
    dev.off()
}

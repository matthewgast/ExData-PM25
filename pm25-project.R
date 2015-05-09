readData <- function (directory) {
  
  cwd <- getwd()
  if (missing(directory)) {
    directory <- "/Users/mgast/Dropbox/data-science-specialization/4-exploratory-data-analysis/prog-assignment-2"
  }
  
  # Somewhat bad style to access global environment, but hey, these are essentially constants
  if (!exists("nei",where=globalenv())) {
    message("Reading NEI data")
    nei <<- readRDS("summarySCC_PM25.rds")    
  }
  if (!exists("scc",where=globalenv())) {
    message("Reading classification codes")
    scc <<- readRDS("Source_Classification_Code.rds")    
  }

  setwd(cwd)
}

totalEmissions <- function () {
  # Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
  # Using the base plotting system, make a plot showing the total PM2.5 emission
  # from all sources for each of the years 1999, 2002, 2005, and 2008.
  library(dplyr)
  
  summarize(group_by(nei,year),sum(Emissions))
}

totalEmissionsByLocation <- function (locationCode) {
  # Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
  # (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot
  #answering this question.
  
  library(dplyr)
  
  if (missing(locationCode)) {
    # Baltimore city
    locationCode <- 24510
  }
  
  summarize(group_by(filter(nei,fips==locationCode),year),sum(Emissions))
}

totalEmissionsByTypeByLocation <- function (locationCode) {
  # Of the four types of sources indicated by the type (point, nonpoint, onroad,
  # nonroad) variable, which of these four sources have seen decreases in emissions
  # from 1999–2008 for Baltimore City? Which have seen increases in emissions from
  # 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
  
  library(dplyr)
  
  if (missing(locationCode)) {
    # Baltimore city
    locationCode <- 24510
  }
  
  summarize(group_by(filter(nei,fips==24510),year,type),sum(Emissions))
}

totalCoalEmissions <- function () {
  # Across the United States, how have emissions from coal combustion-related
  # sources changed from 1999–2008?
  
  #is this coal combustion?
  coalEISector <- grepl("coal",scc$EI.Sector,ignore.case=TRUE)
  EIsectorcodes <- scc[coalEISector,c("SCC")]
  
  coalnei <- nei[(nei$SCC %in% EIsectorcodes),]
  summarize(group_by(coalnei,year),sum(Emissions))
}

motorVehicleEmissions <- function (location=NULL) {
  # How have emissions from motor vehicle sources changed from 1999–2008 in
  # Baltimore City?
  #
  # Compare emissions from motor vehicle sources in Baltimore City with emissions
  # from motor vehicle sources in Los Angeles County, California (fips == "06037").
  # Which city has seen greater changes over time in motor vehicle emissions?
  
  # motor vehicle only
  
  if (is.null(location)) {
    # pick everything
    road_emit <- filter(nei,type=="ON-ROAD")
  } else {
    # pick only supplied location
    road_emit <- filter(nei,fips==location & type=="ON-ROAD")
  }
  
  summarize(group_by(road_emit,year),sum(Emissions))
}

## pm25-project.R
##
## Matthew Gast, May 2015
##
## Course: "Exploratory Data Analysis" at the JHU Bloomberg School of
## Health (Coursera Data Science Specialization).  This set of
## functions supports the graphics plotting required for the second
## course project.  These functions read in the data and return data
## structures that can be plotted as required for each of the parts of
## the assignment.

readData <- function (directory) {
# This function reads the National Emissions Inventory (NEI) and its
# Source Classification Codes (SCC).  The data is read into global
# variables and then treated as a constant by other functions for
# analysis.
#
# Input:  A directory to read the two data files from.
# Output: None, but the "nei" and "scc" variables are defined in the global
#         environment.
    
  cwd <- getwd()
  if (missing(directory)) {
    directory <- "/Users/mgast/Dropbox/data-science-specialization/4-exploratory-data-analysis/prog-assignment-2"
  }

  # Reading takes some time, so only read them if they don't already exist
  #
  # Possible improvement: test to see if they have been altered and re-read
  # them if they have been accidentally overwritten
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

totalEmissionsByYear <- function () {
# This function returns the total emissions per year for all sources.
#
# Input:  None, though it accesses the NEI data in the global environment.
# Output: A data frame with total emissions by year

  library(dplyr)
  total <- summarize(group_by(nei,year),
                     sum(Emissions))
  names(total) <- c("year","emissions")
  total
}

totalEmissionsByYearByLocation <- function (locationCode) {
# This function returns the total emissions per year in a particular location,
# where the location is identified by a FIPS code.  The FIPS code is a string
# and must be matched as one.
#
# Input:  A string to be used as the location code.  The NEI data must also
#         be present in the global environment.  If no location string is
#         supplied, results will be returned for Baltimore City.
# Output: A data frame with emissions by year, for the given location.
    
  library(dplyr)
  if (missing(locationCode)) {
    # Baltimore City is 24510
    locationCode <- "24510"
  }
  
  total <- summarize(group_by(filter(nei,fips==locationCode),year),
                     sum(Emissions))
  names(total) <- c("year","emissions")
  total
}

totalEmissionsByTypeByYearByLocation <- function (locationCode) {
# This function returns the total emissions per year in a particular location
# for each type (point/nonpoint/onroad/non-road) in the NEI.
#
# Input:  A string to be used as the location code.  If no location string is
#         supplied, results will be returned for Baltimore City.  NEI data
#         must be present in the global environment.
# Output: A data frame with total emissions for each type, shown sequentially
#         by year.
    
  library(dplyr)
  if (missing(locationCode)) {
    # Baltimore City location code
    locationCode <- "24510"
  }
  
  total <- summarize(group_by(filter(nei,fips==locationCode),
                              type,year),
                     sum(Emissions))
  names(total) <- c("type", "year","emissions")
  total
}

totalFuelEmissionsByYear <- function (fuel) {
# This function returns the total emissions from a particular type of fuel
# in the entire United States over time
#
# Input:  A string with the type of fuel to assess emissions for.  If no
#         fuel is supplied, the function defaults to "coal" for the
#         assignment.  NEI data must be in the global environment.
# Output: A data frame with the total emissions from the specified fuel

  if (missing(fuel)) {
      fuel <- "coal"
  }

  # Test if this is from the given fuel, then take only those emissions
  is.from.fuel <- grepl(fuel,scc$EI.Sector,ignore.case=TRUE)
  fuel.sources <- scc[is.from.fuel,c("SCC")]
  fuel.emit <- nei[nei$SCC %in% fuel.sources,]

  total <- summarize(group_by(fuel.emit,year),sum(Emissions))
  names(total) <- c("year","emissions")
  total
}

motorVehicleEmissions <- function (location=NULL) {
# This function returns the emissions from on-road motor vehicles in a given
# location over time.
#
# Input:  A location code, as a string, to retrieve motor vehicle emission
#         information.  If no string is given, the default is to return
#         for the entire country. NEI data must be in the global environment.
# Output: A data frame with on-road emissions over time for the location.

    # Vehicle emissions are identified by a type of "ON-ROAD"
    if (is.null(location)) {
        # Select from entire country.
        road_emit <- filter(nei,type=="ON-ROAD")
    } else {
        # pick only supplied location
        road_emit <- filter(nei,fips==location & type=="ON-ROAD")
    }
  
    total <- summarize(group_by(road_emit,year),
                       sum(Emissions))
    names(total) <- c("year","emissions")
    total
}

writePlotFile <- function (plot, file, type) {
# This function writes a plot to a file.
#
# Input:  A plot to be saved to a file, a filename, and a type of file.  If
#         no file type is specified, the file will be a PNG.
# Output: The plot is written to the specified file.

    if (missing(type)) {
        type <- "png"
    }

    # Open the correct file type
    if (identical(type,"png")) {
        png(file)
    }
    if (identical(type,"pdf")) {
        pdf(file)
    }

    # print the plot and save the file
    print(plot)
    dev.off()
}


# Multiple plot function
# See http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

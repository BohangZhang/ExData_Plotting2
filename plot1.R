library(dplyr)

# Download files
u <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if ((!file.exists("summarySCC_PM25.rds")) || (!file.exists("Source_Classification_Code.rds"))) {
  download.file(u, destfile = "course_project.zip",method = "curl")
  unzip("course_project.zip")
}

# Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Construct the plot
par(mar=c(4.1,4.6,3,1.3))
NEI <- transform(NEI, year = factor(year))
new_df <- group_by(NEI, year)
final_df <- summarise(new_df, Em = sum(Emissions))
plot(as.numeric(as.character(final_df[[1]])),final_df[[2]], xlab = "Year", ylab = "Emissions (tons)",main = "Total Emissions Per Year",type="l")
text(as.numeric(as.character(final_df[[1]]))+c(1,0,0,-1),final_df[[2]]+c(0,-200000,200000,0),labels=as.character(final_df[[1]]))

# Construct the PNG file
dev.copy(png, "plot1.png")
dev.off()


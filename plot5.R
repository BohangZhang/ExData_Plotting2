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
Balti <- filter(NEI, fips == "24510")
Balti_final <- filter(Balti, type=="ON-ROAD")
final_df <- tapply(Balti_final$Emissions,Balti_final$year,sum)
plot(as.numeric(rownames(final_df)),as.vector(final_df), xlab = "Year", ylab = "Emissions (tons)",main = "Total Emissions Per Year (Baltimore City Motor Veh)",type="l",cex=0.5)
text(as.numeric(rownames(final_df))+c(0.5,0.5,0,-1),as.vector(final_df)+c(0,10,10,0),labels=rownames(final_df))

# Construct the PNG file
dev.copy(png, "plot5.png")
dev.off()

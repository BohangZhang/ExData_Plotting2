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

Los <- filter(NEI, fips == "06037")
Los_final <- filter(Los, type=="ON-ROAD")
final_df2 <- tapply(Los_final$Emissions,Los_final$year,sum)
plot(as.numeric(rownames(final_df2)),as.vector(final_df2),xlab = "Year", ylab = "Emissions (tons)",main = "Total Emissions Per Year BC vs LA Motor Veh",type="l",cex=0.5,ylim = c(100,5000),col="red")
text(as.numeric(rownames(final_df2))+c(0,0,0,0),as.vector(final_df2)+c(-150,-150,-150,-150),col="red",labels=rownames(final_df2))

Balti <- filter(NEI, fips == "24510")
Balti_final <- filter(Balti, type=="ON-ROAD")
final_df <- tapply(Balti_final$Emissions,Balti_final$year,sum)
lines(as.numeric(rownames(final_df)),as.vector(final_df))
text(as.numeric(rownames(final_df))+rep(0,4),as.vector(final_df)+c(150,150,150,150),labels=rownames(final_df))

legend("topleft",legend = c("LA","BC"),col = c("red","black"),lty=1,cex=0.75)

# Construct the PNG file
dev.copy(png, "plot6.png")
dev.off()

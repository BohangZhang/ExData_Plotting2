library(dplyr)
library(plyr)

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
C <- join(NEI,SCC)
df <- mutate(C, Coal = grepl(".*[Cc][Oo][Aa][Ll].*",C$EI.Sector) & grepl(".*[Cc][Oo][Mm][Bb].*",C$EI.Sector))
df2 <- filter(df, Coal == T)
df3 <- select(df2,year,Emissions)
final_df <- tapply(df3$Emissions,df3$year,sum)
plot(as.numeric(rownames(final_df)),as.vector(final_df), xlab = "Year", ylab = "Emissions (tons)",main = "Total Emissions Per Year (Coal Combustion)",type="l",cex=0.5)
text(as.numeric(rownames(final_df))+c(0,0,-0.5,-0.5),as.vector(final_df)+c(-10000,15000,-10000,0),labels=rownames(final_df))

# Construct the PNG file
dev.copy(png, "plot4.png")
dev.off()

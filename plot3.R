library(dplyr)
library(ggplot2)

# Download files
u <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if ((!file.exists("summarySCC_PM25.rds")) || (!file.exists("Source_Classification_Code.rds"))) {
  download.file(u, destfile = "course_project.zip",method = "curl")
  unzip("course_project.zip")
}

# Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Construct the data frame
NEI <- transform(NEI, year = factor(year))
NEI <- transform(NEI, type = factor(type, levels = c("POINT","NONPOINT","ON-ROAD","NON-ROAD")))
Balti <- filter(NEI, fips == "24510")
df1 <- mutate(Balti,nf=factor(paste(year,type,sep = "_")))
Em <- tapply(df1$Emissions,df1$nf,sum,simplify = T)
x_axis <- rep(c(1999,2002,2005,2008),each=4)
df <- data.frame(x_axis, Em)
df <- mutate(df, Tp = factor(sub(".....","",rownames(df))))

# Construct the plot
initial <- ggplot(df,aes(x_axis,Em,color = interaction(x_axis,Tp)))
initial+geom_line(aes(color=Tp))+labs(title = "Total Emissions Per Year in Baltimore City (Types)",x="Year",y="Emissions (tons)")

# Construct the PNG file
dev.copy(png, "plot3.png")
dev.off()

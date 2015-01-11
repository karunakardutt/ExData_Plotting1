## The idea is to avoid loading the entire data set into Memory 
## Instead we read each row and combine the rows tnat match a condition into a data frame

## Define File Name to be read
inputFile <- "household_power_consumption.txt"

##Create an empty data Frame with headers by reading 1 row 
df  <- read.csv(inputFile, sep = ";", header=TRUE, na.strings="?", nrows=1)  
# Remove the one row created
df <- df [-1,]
# Get the Coumn Names Vector
cNames <- colnames(df)

## we will use the list of dataframes to join rows later
listOfDataFrames <- NULL
i<-0

#Read the input file (till the end)
#line by line (into a list)

con  <- file(inputFile, open = "r")
while (length(oneLine <- readLines(con, n = 1)) > 0) {
    rowInput <- strsplit(oneLine, ";")[[1]]
    
## If the Date is '1/2/2007' or '2/2/2007'
# we create a new data frame and add it to the list of dataframes   
    if ((rowInput[1] == "1/2/2007") | (rowInput[1] == "2/2/2007")){
        df_new <- data.frame(t(matrix(rowInput)), stringsAsFactors=FALSE)
        colnames(df_new) <- cNames
        
        i<-i+1
        listOfDataFrames[[i]] <- df_new
    }
} 
close(con)

## Bind the list of dataframes in to one data frame
df <- do.call("rbind", listOfDataFrames)

#Clean the dates/times by making a New Column
df$DateTime = paste(df$Date," ",df$Time)
df$DateTime <- strptime(df$DateTime,"%d/%m/%Y %H:%M:%S")

# Clean the Numbers 
D <- transform(df, Global_active_power   =   as.numeric(Global_active_power),
                   Global_reactive_power =   as.numeric(Global_reactive_power),
                   Voltage               =   as.numeric(Voltage),
                   Global_intensity      =   as.numeric(Global_intensity),
                   Sub_metering_1        =   as.numeric(Sub_metering_1),
                   Sub_metering_2        =   as.numeric(Sub_metering_2),
                   Sub_metering_3        =   as.numeric(Sub_metering_3) )
                
#Plot The graphs in the following code

## Histogram to PNG file plot1
png(file="plot1.png", height=480, width=480)
hist(D$Global_active_power, xlab="Global Active Power(kilowatts)", main="Global Active Power", col="red")
dev.off()

## --- End ----



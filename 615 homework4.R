library(data.table)
library(lubridate)
setwd('C:/Users/Owner/Downloads')
read.csv('Rainfall.csv')
file_root<-"https://www.ndbc.noaa.gov/view_text_file.php?filename=44013h"
tail <- ".txt.gz&dir=data/historical/stdmet/"
final <- data.table()

for (year in 1985:2023) {
  path <- paste0(file_root, year, tail)
  header <- scan(path, what = 'character', nlines = 1, quiet = TRUE)
  skip_lines <- ifelse(year >= 2007, 2, 1)
  buoy_data <- fread(path, header = FALSE, skip = skip_lines, fill = Inf)
  actual_col_count <- ncol(buoy_data)
  header_col_count <- length(header)
  
  if (header_col_count > actual_col_count) {
    header <- header[1:actual_col_count]
  } else if (header_col_count < actual_col_count) {
    header <- c(header, paste0("V", (header_col_count + 1):actual_col_count))
  }
  
  colnames(buoy_data) <- header
  
  # Add a year column
  buoy_data[, Year := year]
  
  # Append to the final data table
  final <- rbind(final, buoy_data, fill = TRUE)
}

fwrite(final, "buoy_data_1985_2023.csv")





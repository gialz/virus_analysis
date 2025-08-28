library(tidyverse)
library(glue)

setwd("/Users/ginna/Desktop/internship/practice/")

fastq_table <- read.csv("SraRunTable.csv")

fastq_table <- fastq_table %>%
  mutate(
    f1 = (glue("{Run}_1.fastq.gz")),
    f2 = (glue("{Run}_2.fastq.gz"))
  )

head(fastq_table)

write.csv(fastq_table,"/Users/ginna/Desktop/internship/practice/rbasics/new_SraRunTable.csv", row.names = TRUE)
setwd("/Users/ginna/Desktop/internship/practice/rbasics/")
new_fastq_table <- read.csv("new_SraRunTable.csv", row.names = 1)

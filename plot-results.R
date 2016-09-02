library(plyr)
library(dplyr)
library(ggplot2)
library(reshape2)

benchmarks = list(
  `druid`         = "tpch_lineitem_druid.tsv",
  `big-query`     = "big_query.tsv"
)

results <- NULL
for(x in names(benchmarks)) {
  filename <- file.path("results", benchmarks[[x]])
  if(file.exists(filename)) {
    r <- read.table(filename)
    names(r) <- c("query", "time")
    r$engine <- x
    results <- rbind(results, r)
  }
}

ggplot(results, aes(x = query, y = time, color = engine)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = -90))

results$rows <- 119994608

results_summary <- ddply(results, .(engine, query),
                         summarise,
                         time = median(time),
                         rps=median(rows/time),
                         count=length(query))
results_summary$type <- "aggregation"
results_summary$type[grep("top", results_summary$query)] <- "top-n"

results %>%
  group_by(query, engine) %>%
  summarize(n = n(),
            mean_seconds = round(mean(time), 3),
            sd_seconds = round(sd(time), 3)) %>%
  as.data.frame
